-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- DEV/DEMO ONLY - ONE-FILE IDEMPOTENT BOOTSTRAP SCRIPT
-- NEVER RUN THIS SCRIPT ON PRODUCTION!
-- Contains: Migrations 001, 002, 003 + Seed demo_users.sql + Verification Queries
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- ==============================================================================
-- Migration: 20261104000001_create_users_table.sql
-- Description: Creates the core public.users table, triggers, and strict RLS policies.
-- ==============================================================================

-- 1. Create public.users table
create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  phone text unique,
  full_name text,
  role text not null default 'customer' check (role in ('customer', 'labour', 'admin')),
  account_status text not null default 'pending_verification' check (
    account_status in (
      'pending_verification',
      'approved',
      'rejected',
      'suspended',
      'permanently_banned'
    )
  ),
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Indexes for rapid lookups
create index if not exists idx_users_phone on public.users(phone);
create index if not exists idx_users_role on public.users(role);
create index if not exists idx_users_account_status on public.users(account_status);

-- 2. Automatic updated_at timestamp trigger
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists set_users_updated_at on public.users;
create trigger set_users_updated_at
  before update on public.users
  for each row
  execute function public.handle_updated_at();

-- 3. Security Guard Trigger: Prevent non-admin users from altering their own role or account_status
create or replace function public.enforce_user_immutability()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  is_admin boolean;
begin
  -- Allow service role, background migrations, or SQL Editor (where auth.uid() is null)
  if auth.uid() is null then
    return new;
  end if;

  -- Check if executing user has admin role
  select exists (
    select 1 from public.users
    where id = auth.uid() and role = 'admin'
  ) into is_admin;

  -- If not an admin, freeze role and account_status to their old values
  if not coalesce(is_admin, false) then
    if new.role is distinct from old.role then
      raise exception 'Unauthorized: Users cannot change their own role.';
    end if;

    if new.account_status is distinct from old.account_status then
      raise exception 'Unauthorized: Users cannot change their own account verification status.';
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists protect_user_fields on public.users;
create trigger protect_user_fields
  before update on public.users
  for each row
  execute function public.enforce_user_immutability();

-- 4. Auth Signup Trigger: Auto-populate public.users from auth.users
create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  chosen_role text;
  meta_role text;
  user_phone text;
  user_name text;
begin
  -- Extract metadata safely
  meta_role := lower(coalesce(new.raw_user_meta_data->>'role', 'customer'));
  user_phone := coalesce(new.phone, new.raw_user_meta_data->>'phone');
  user_name := new.raw_user_meta_data->>'full_name';

  -- Enforce role rule: Only 'customer' or 'labour' is selectable at signup.
  -- 'admin' is NEVER self-selectable.
  if meta_role = 'labour' then
    chosen_role := 'labour';
  else
    chosen_role := 'customer';
  end if;

  insert into public.users (
    id,
    phone,
    full_name,
    role,
    account_status,
    created_at,
    updated_at
  )
  values (
    new.id,
    user_phone,
    user_name,
    chosen_role,
    'pending_verification',
    now(),
    now()
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_auth_user();

-- 5. Enable Row Level Security (RLS)
alter table public.users enable row level security;

-- Policy: Users can view their own profile; Admins can view all profiles
drop policy if exists "Users can view own profile or admins can view all" on public.users;
create policy "Users can view own profile or admins can view all"
  on public.users
  for select
  using (
    auth.uid() = id
    or exists (
      select 1 from public.users u
      where u.id = auth.uid() and u.role = 'admin'
    )
  );

-- Policy: Users can update their own profile (name, avatar, etc.)
drop policy if exists "Users can update own profile" on public.users;
create policy "Users can update own profile"
  on public.users
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Note: No client-side INSERT policy exists.
-- User creation is handled exclusively via the security definer on_auth_user_created trigger.

-- ==============================================================================
-- Migration: 20261104000002_create_avatars_storage_bucket.sql
-- Description: Creates the public avatars storage bucket and RLS policies.
-- ==============================================================================

-- 1. Create the 'avatars' storage bucket if it does not already exist
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'avatars',
  'avatars',
  true,
  2097152, -- 2MB maximum file size
  array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
on conflict (id) do update set
  public = true,
  file_size_limit = 2097152,
  allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp', 'image/gif'];

-- 2. Storage Objects RLS Policies
-- Enable RLS on storage.objects (if not already enabled)
alter table storage.objects enable row level security;

-- Policy 1: Anyone can read avatar images (public bucket)
drop policy if exists "Avatars are publicly readable" on storage.objects;
create policy "Avatars are publicly readable"
  on storage.objects
  for select
  using (bucket_id = 'avatars');

-- Policy 2: Authenticated users can upload their own avatar file to their folder
drop policy if exists "Users can upload their own avatar" on storage.objects;
create policy "Users can upload their own avatar"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Policy 3: Authenticated users can update their own avatar
drop policy if exists "Users can update their own avatar" on storage.objects;
create policy "Users can update their own avatar"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Policy 4: Authenticated users can delete their own avatar
drop policy if exists "Users can delete their own avatar" on storage.objects;
create policy "Users can delete their own avatar"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- ==============================================================================
-- Migration: 20261104000003_create_identity_and_labour_tables.sql
-- Description: Phase 3 Identity Verification, Skills, Labour Profiles, Audit Logs,
--              Notifications, Private Storage Bucket & Admin Review RPC.
-- ==============================================================================

-- 1. Skills Directory (Seeded with core marketplace skills)
create table if not exists public.skills (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  name_bn text not null,
  description text,
  icon_name text,
  created_at timestamptz not null default now()
);

-- Seed core skills idempotently
insert into public.skills (name, name_bn, description, icon_name)
values
  ('Electrician', 'ইলেকট্রিশিয়ান', 'বৈদ্যুতিক ওয়্যারিং, ফ্যান, লাইট ও সার্কিট মেরামত', 'electrical_services'),
  ('Plumber', 'প্লাম্বার', 'পাইপলাইন, পানির কল, বেসিন ও বাথরুম স্যানিটারি কাজ', 'plumbing'),
  ('Cleaner', 'ক্লিনার', 'বাড়ি, অফিস বা বাণিজ্যিক স্থান গভীর পরিষ্কার সেবা', 'cleaning_services'),
  ('Painter', 'পেইন্টার', 'ভবনের ভেতর ও বাহিরের রঙ ও টেক্সচার পেইন্টিং', 'format_paint'),
  ('Gardener', 'মালী', 'বাগান পরিচর্যা, ঘাস কাটা ও গাছ রোপণ সেবা', 'yard'),
  ('Carpenter', 'কাঠমিস্ত্রি', 'কাঠের আসবাবপত্র তৈরি, মেরামত ও পলিশিং', 'carpenter'),
  ('Moving Helper', 'মুভিং হেল্পার', 'আসবাবপত্র ও মালামাল সাবধানে লোডিং, আনলোডিং ও শিফটিং', 'local_shipping')
on conflict (name) do nothing;

create index if not exists idx_skills_name on public.skills(name);

-- Enable RLS for skills
alter table public.skills enable row level security;

drop policy if exists "Anyone can read skills directory" on public.skills;
create policy "Anyone can read skills directory"
  on public.skills for select
  using (true);

drop policy if exists "Only admin can insert or modify skills" on public.skills;
create policy "Only admin can insert or modify skills"
  on public.skills for all
  using (
    exists (
      select 1 from public.users
      where id = auth.uid() and role = 'admin'
    )
  );

-- 2. Identity Verifications Table
create table if not exists public.identity_verifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  document_type text not null check (document_type in ('nid', 'passport')),
  document_number text not null,
  front_path text not null,
  back_path text,
  selfie_path text not null,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  admin_id uuid references public.users(id) on delete set null,
  rejection_reason text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz
);

create index if not exists idx_id_verifications_user on public.identity_verifications(user_id);
create index if not exists idx_id_verifications_status on public.identity_verifications(status);

-- Enable RLS for identity_verifications
alter table public.identity_verifications enable row level security;

drop policy if exists "Users can view their own identity verifications" on public.identity_verifications;
create policy "Users can view their own identity verifications"
  on public.identity_verifications for select
  using (user_id = auth.uid());

drop policy if exists "Admins can view all identity verifications" on public.identity_verifications;
create policy "Admins can view all identity verifications"
  on public.identity_verifications for select
  using (
    exists (
      select 1 from public.users
      where id = auth.uid() and role = 'admin'
    )
  );

drop policy if exists "Users can submit their own identity verification" on public.identity_verifications;
create policy "Users can submit their own identity verification"
  on public.identity_verifications for insert
  with check (
    user_id = auth.uid()
    and status = 'pending'
    and admin_id is null
    and reviewed_at is null
  );

-- Direct client updates/deletes on verification records are disabled (admin reviews via RPC)
drop policy if exists "Only admin can update identity verifications" on public.identity_verifications;
create policy "Only admin can update identity verifications"
  on public.identity_verifications for update
  using (
    exists (
      select 1 from public.users
      where id = auth.uid() and role = 'admin'
    )
  );

-- 3. Labour Profiles Table
create table if not exists public.labour_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique not null references public.users(id) on delete cascade,
  experience text,
  service_area text,
  expected_wage numeric,
  availability text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_labour_profiles_user on public.labour_profiles(user_id);

-- Updated_at trigger for labour_profiles
drop trigger if exists set_labour_profiles_updated_at on public.labour_profiles;
create trigger set_labour_profiles_updated_at
  before update on public.labour_profiles
  for each row
  execute function public.handle_updated_at();

-- Enable RLS for labour_profiles
alter table public.labour_profiles enable row level security;

drop policy if exists "Anyone can read labour profiles" on public.labour_profiles;
create policy "Anyone can read labour profiles"
  on public.labour_profiles for select
  using (true);

drop policy if exists "Labours can insert their own profile" on public.labour_profiles;
create policy "Labours can insert their own profile"
  on public.labour_profiles for insert
  with check (user_id = auth.uid());

drop policy if exists "Labours can update their own profile" on public.labour_profiles;
create policy "Labours can update their own profile"
  on public.labour_profiles for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- 4. Labour Skills Table (with server-side score and badge protection)
create table if not exists public.labour_skills (
  id uuid primary key default gen_random_uuid(),
  labour_id uuid not null references public.users(id) on delete cascade,
  skill_id uuid not null references public.skills(id) on delete cascade,
  score numeric not null default 0 check (score >= 0),
  badge_active boolean not null default false,
  created_at timestamptz not null default now(),
  unique (labour_id, skill_id)
);

create index if not exists idx_labour_skills_labour on public.labour_skills(labour_id);
create index if not exists idx_labour_skills_skill on public.labour_skills(skill_id);

-- Trigger: Protect labour_skills score and badge_active from client-side tampering
create or replace function public.enforce_labour_skills_immutability()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Allow service role or admin
  if auth.uid() is null then
    return new;
  end if;

  if exists (select 1 from public.users where id = auth.uid() and role = 'admin') then
    return new;
  end if;

  -- Normal workers cannot alter score or badge_active
  if new.score is distinct from old.score or new.badge_active is distinct from old.badge_active then
    raise exception 'Unauthorized: Skill score and badge status are calculated strictly server-side.';
  end if;

  return new;
end;
$$;

drop trigger if exists protect_labour_skills_fields on public.labour_skills;
create trigger protect_labour_skills_fields
  before update on public.labour_skills
  for each row
  execute function public.enforce_labour_skills_immutability();

-- Enable RLS for labour_skills
alter table public.labour_skills enable row level security;

drop policy if exists "Anyone can view labour skills" on public.labour_skills;
create policy "Anyone can view labour skills"
  on public.labour_skills for select
  using (true);

drop policy if exists "Labours can add skills to their profile" on public.labour_skills;
create policy "Labours can add skills to their profile"
  on public.labour_skills for insert
  with check (
    labour_id = auth.uid()
    and score = 0
    and badge_active = false
  );

drop policy if exists "Labours can remove skills from their profile" on public.labour_skills;
create policy "Labours can remove skills from their profile"
  on public.labour_skills for delete
  using (labour_id = auth.uid());

-- 5. Audit Logs Table
create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references public.users(id) on delete set null,
  action text not null,
  target_type text not null,
  target_id text not null,
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_audit_logs_actor on public.audit_logs(actor_id);
create index if not exists idx_audit_logs_target on public.audit_logs(target_type, target_id);

alter table public.audit_logs enable row level security;

drop policy if exists "Admins can view audit logs" on public.audit_logs;
create policy "Admins can view audit logs"
  on public.audit_logs for select
  using (
    exists (
      select 1 from public.users
      where id = auth.uid() and role = 'admin'
    )
  );

-- 6. Notifications Table
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  title text not null,
  body text not null,
  type text not null default 'general',
  is_read boolean not null default false,
  data jsonb default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_notifications_user on public.notifications(user_id);
create index if not exists idx_notifications_unread on public.notifications(user_id, is_read);

alter table public.notifications enable row level security;

drop policy if exists "Users can view their own notifications" on public.notifications;
create policy "Users can view their own notifications"
  on public.notifications for select
  using (user_id = auth.uid());

drop policy if exists "Users can update read status of their notifications" on public.notifications;
create policy "Users can update read status of their notifications"
  on public.notifications for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- 7. Private Storage Bucket: identity-documents
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'identity-documents',
  'identity-documents',
  false,
  10485760, -- 10MB limit
  array['image/jpeg', 'image/png', 'image/webp', 'application/pdf']
)
on conflict (id) do update set
  public = false,
  file_size_limit = 10485760,
  allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp', 'application/pdf'];

-- RLS for private storage bucket identity-documents
drop policy if exists "Users can upload own identity documents" on storage.objects;
create policy "Users can upload own identity documents"
  on storage.objects for insert
  with check (
    bucket_id = 'identity-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Users can view own identity documents" on storage.objects;
create policy "Users can view own identity documents"
  on storage.objects for select
  using (
    bucket_id = 'identity-documents'
    and (
      (storage.foldername(name))[1] = auth.uid()::text
      or exists (
        select 1 from public.users
        where id = auth.uid() and role = 'admin'
      )
    )
  );

-- 8. Admin Security Definer RPC: review_identity_verification
create or replace function public.review_identity_verification(
  p_verification_id uuid,
  p_status text,
  p_rejection_reason text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin_id uuid := auth.uid();
  v_is_admin boolean;
  v_verification record;
  v_new_account_status text;
  v_notif_title text;
  v_notif_body text;
begin
  -- 1. Security Check: Caller must be authenticated admin
  if v_admin_id is null then
    raise exception 'Unauthorized: Authentication required.';
  end if;

  select exists (
    select 1 from public.users
    where id = v_admin_id and role = 'admin'
  ) into v_is_admin;

  if not coalesce(v_is_admin, false) then
    raise exception 'Unauthorized: Only administrators can review identity verifications.';
  end if;

  -- 2. Validate target status
  if p_status not in ('approved', 'rejected') then
    raise exception 'Invalid status: Must be approved or rejected.';
  end if;

  -- 3. Fetch verification record
  select * into v_verification
  from public.identity_verifications
  where id = p_verification_id
  for update;

  if not found then
    raise exception 'Identity verification request not found.';
  end if;

  if v_verification.status <> 'pending' then
    raise exception 'Verification request has already been reviewed.';
  end if;

  -- 4. Determine new account status
  if p_status = 'approved' then
    v_new_account_status := 'approved';
    v_notif_title := 'পরিচয় যাচাইকরণ সফল হয়েছে / Identity Verified';
    v_notif_body := 'আপনার জাতীয় পরিচয়পত্র সফলভাবে অনুমোদিত হয়েছে। এখন আপনি কাজ শুরু করতে পারবেন।';
  else
    v_new_account_status := 'rejected';
    v_notif_title := 'পরিচয় যাচাইকরণ বাতিল / Verification Rejected';
    v_notif_body := coalesce(
      p_rejection_reason,
      'আপনার পরিচয়পত্রের তথ্য সঠিক নয়। অনুগ্রহ করে পুনরায় সঠিক নথি আপলোড করুন।'
    );
  end if;

  -- 5. Update identity_verifications
  update public.identity_verifications
  set
    status = p_status,
    admin_id = v_admin_id,
    rejection_reason = p_rejection_reason,
    reviewed_at = now()
  where id = p_verification_id;

  -- 6. Update user's account_status in public.users
  update public.users
  set account_status = v_new_account_status
  where id = v_verification.user_id;

  -- 7. Write to audit_logs
  insert into public.audit_logs (actor_id, action, target_type, target_id, metadata)
  values (
    v_admin_id,
    'review_identity_verification',
    'identity_verification',
    p_verification_id::text,
    jsonb_build_object(
      'status', p_status,
      'target_user_id', v_verification.user_id,
      'rejection_reason', p_rejection_reason
    )
  );

  -- 8. Insert in-app notification
  insert into public.notifications (user_id, title, body, type, data)
  values (
    v_verification.user_id,
    v_notif_title,
    v_notif_body,
    'identity_verification_' || p_status,
    jsonb_build_object(
      'verification_id', p_verification_id,
      'status', p_status,
      'rejection_reason', p_rejection_reason
    )
  );

  return jsonb_build_object(
    'success', true,
    'verification_id', p_verification_id,
    'status', p_status,
    'user_id', v_verification.user_id
  );
end;
$$;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- DEV/DEMO ONLY - NEVER RUN THIS SCRIPT ON PRODUCTION!
-- Description: Seeds 6 deterministic test accounts with known phone-derived
--              credentials matching SupabaseAuthRepository.signInWithDevPhone
--              and Supabase Phone OTP test numbers (880XXXXXXXXXX=123456).
-- Safe to re-run multiple times (idempotent).
--
-- Credentials for all demo accounts:
--   Phone:    880XXXXXXXXXX (without '+', confirmed for test OTP)
--   Test OTP: 123456 (configured in Supabase Phone Provider)
--   Email:    dev_<digits>@kaajlagbe.local
--   Password: DevKaajLagbe!<digits>
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

do $$
declare
  v_customer1_id uuid := '00000000-0000-0000-0000-000000000001'::uuid;
  v_customer2_id uuid := '00000000-0000-0000-0000-000000000002'::uuid;
  v_labour1_id   uuid := '00000000-0000-0000-0000-000000000003'::uuid;
  v_labour2_id   uuid := '00000000-0000-0000-0000-000000000004'::uuid;
  v_labour3_id   uuid := '00000000-0000-0000-0000-000000000005'::uuid;
  v_admin_id     uuid := '00000000-0000-0000-0000-000000000006'::uuid;

  v_skill_electrician uuid;
  v_skill_plumber     uuid;
  v_skill_cleaner     uuid;
  v_skill_painter     uuid;
  v_skill_gardener    uuid;
  v_skill_carpenter   uuid;
  v_skill_moving      uuid;
begin
  -- Resolve skill IDs from public.skills (seeded in migration 003)
  select id into v_skill_electrician from public.skills where name = 'Electrician';
  select id into v_skill_plumber     from public.skills where name = 'Plumber';
  select id into v_skill_cleaner     from public.skills where name = 'Cleaner';
  select id into v_skill_painter     from public.skills where name = 'Painter';
  select id into v_skill_gardener    from public.skills where name = 'Gardener';
  select id into v_skill_carpenter   from public.skills where name = 'Carpenter';
  select id into v_skill_moving      from public.skills where name = 'Moving Helper';

  -- ---------------------------------------------------------------------------
  -- 1. CUSTOMER #1: Rahim Uddin (01700000001 -> 8801700000001)
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, phone_confirmed_at,
    confirmation_token, recovery_token, email_change, email_change_token_new,
    raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_customer1_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801700000001@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801700000001', extensions.gen_salt('bf')),
    now(),
    '8801700000001',
    now(),
    '', '', '', '',
    '{"provider": "phone", "providers": ["email", "phone"]}'::jsonb,
    '{"full_name": "Rahim Uddin", "role": "customer", "phone": "8801700000001"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    phone = '8801700000001',
    phone_confirmed_at = now(),
    confirmation_token = '',
    recovery_token = '',
    email_change = '',
    email_change_token_new = '',
    encrypted_password = extensions.crypt('DevKaajLagbe!8801700000001', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Rahim Uddin", "role": "customer", "phone": "8801700000001"}'::jsonb,
    email_confirmed_at = now();

  insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  values (
    v_customer1_id::text, v_customer1_id,
    jsonb_build_object('sub', v_customer1_id::text, 'email', 'dev_8801700000001@kaajlagbe.local'),
    'email', 'dev_8801700000001@kaajlagbe.local', now(), now(), now()
  ) on conflict (provider, provider_id) do update set last_sign_in_at = now();

  update public.users set
    full_name = 'Rahim Uddin',
    phone = '+8801700000001',
    role = 'customer',
    account_status = 'approved',
    avatar_url = null
  where id = v_customer1_id;

  -- Approved identity verification record for Customer #1
  delete from public.identity_verifications where user_id = v_customer1_id;
  insert into public.identity_verifications (
    user_id, document_type, document_number, front_path, selfie_path,
    status, admin_id, created_at, reviewed_at
  ) values (
    v_customer1_id, 'nid', 'NID-19881029381',
    'demo/nid_rahim_front.jpg', 'demo/selfie_rahim.jpg',
    'approved', v_admin_id, now() - interval '2 days', now() - interval '1 day'
  );

  -- ---------------------------------------------------------------------------
  -- 2. CUSTOMER #2: Sadia Akter (01700000002 -> 8801700000002)
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, phone_confirmed_at,
    confirmation_token, recovery_token, email_change, email_change_token_new,
    raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_customer2_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801700000002@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801700000002', extensions.gen_salt('bf')),
    now(),
    '8801700000002',
    now(),
    '', '', '', '',
    '{"provider": "phone", "providers": ["email", "phone"]}'::jsonb,
    '{"full_name": "Sadia Akter", "role": "customer", "phone": "8801700000002"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    phone = '8801700000002',
    phone_confirmed_at = now(),
    confirmation_token = '',
    recovery_token = '',
    email_change = '',
    email_change_token_new = '',
    encrypted_password = extensions.crypt('DevKaajLagbe!8801700000002', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Sadia Akter", "role": "customer", "phone": "8801700000002"}'::jsonb,
    email_confirmed_at = now();

  insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  values (
    v_customer2_id::text, v_customer2_id,
    jsonb_build_object('sub', v_customer2_id::text, 'email', 'dev_8801700000002@kaajlagbe.local'),
    'email', 'dev_8801700000002@kaajlagbe.local', now(), now(), now()
  ) on conflict (provider, provider_id) do update set last_sign_in_at = now();

  update public.users set
    full_name = 'Sadia Akter',
    phone = '+8801700000002',
    role = 'customer',
    account_status = 'approved',
    avatar_url = null
  where id = v_customer2_id;

  -- ---------------------------------------------------------------------------
  -- 3. LABOUR #1: Karim Mia (01800000001 -> 8801800000001) [Electrician Master]
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, phone_confirmed_at,
    confirmation_token, recovery_token, email_change, email_change_token_new,
    raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_labour1_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801800000001@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801800000001', extensions.gen_salt('bf')),
    now(),
    '8801800000001',
    now(),
    '', '', '', '',
    '{"provider": "phone", "providers": ["email", "phone"]}'::jsonb,
    '{"full_name": "Karim Mia", "role": "labour", "phone": "8801800000001"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    phone = '8801800000001',
    phone_confirmed_at = now(),
    confirmation_token = '',
    recovery_token = '',
    email_change = '',
    email_change_token_new = '',
    encrypted_password = extensions.crypt('DevKaajLagbe!8801800000001', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Karim Mia", "role": "labour", "phone": "8801800000001"}'::jsonb,
    email_confirmed_at = now();

  insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  values (
    v_labour1_id::text, v_labour1_id,
    jsonb_build_object('sub', v_labour1_id::text, 'email', 'dev_8801800000001@kaajlagbe.local'),
    'email', 'dev_8801800000001@kaajlagbe.local', now(), now(), now()
  ) on conflict (provider, provider_id) do update set last_sign_in_at = now();

  update public.users set
    full_name = 'Karim Mia',
    phone = '+8801800000001',
    role = 'labour',
    account_status = 'approved'
  where id = v_labour1_id;

  -- Approved identity for Karim Mia
  delete from public.identity_verifications where user_id = v_labour1_id;
  insert into public.identity_verifications (
    user_id, document_type, document_number, front_path, back_path, selfie_path,
    status, admin_id, created_at, reviewed_at
  ) values (
    v_labour1_id, 'nid', 'NID-19924820194',
    'demo/nid_karim_front.jpg', 'demo/nid_karim_back.jpg', 'demo/selfie_karim.jpg',
    'approved', v_admin_id, now() - interval '5 days', now() - interval '4 days'
  );

  -- Labour Profile for Karim Mia
  insert into public.labour_profiles (user_id, experience, service_area, expected_wage, availability)
  values (
    v_labour1_id,
    '8 years, residential wiring and repair',
    'Mirpur, Dhaka',
    600,
    'Sat-Thu 09:00-18:00'
  ) on conflict (user_id) do update set
    experience = '8 years, residential wiring and repair',
    service_area = 'Mirpur, Dhaka',
    expected_wage = 600,
    availability = 'Sat-Thu 09:00-18:00';

  -- Labour Skills for Karim Mia (Scores & Badges)
  delete from public.labour_skills where labour_id = v_labour1_id;
  if v_skill_electrician is not null then
    insert into public.labour_skills (labour_id, skill_id, score, badge_active)
    values (v_labour1_id, v_skill_electrician, 245.5, true);
  end if;
  if v_skill_plumber is not null then
    insert into public.labour_skills (labour_id, skill_id, score, badge_active)
    values (v_labour1_id, v_skill_plumber, 212.0, true);
  end if;
  if v_skill_painter is not null then
    insert into public.labour_skills (labour_id, skill_id, score, badge_active)
    values (v_labour1_id, v_skill_painter, 146.5, false);
  end if;

  -- ---------------------------------------------------------------------------
  -- 4. LABOUR #2: Jamal Hossain (01800000002 -> 8801800000002) [Cleaner & Gardener]
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, phone_confirmed_at,
    confirmation_token, recovery_token, email_change, email_change_token_new,
    raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_labour2_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801800000002@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801800000002', extensions.gen_salt('bf')),
    now(),
    '8801800000002',
    now(),
    '', '', '', '',
    '{"provider": "phone", "providers": ["email", "phone"]}'::jsonb,
    '{"full_name": "Jamal Hossain", "role": "labour", "phone": "8801800000002"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    phone = '8801800000002',
    phone_confirmed_at = now(),
    confirmation_token = '',
    recovery_token = '',
    email_change = '',
    email_change_token_new = '',
    encrypted_password = extensions.crypt('DevKaajLagbe!8801800000002', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Jamal Hossain", "role": "labour", "phone": "8801800000002"}'::jsonb,
    email_confirmed_at = now();

  insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  values (
    v_labour2_id::text, v_labour2_id,
    jsonb_build_object('sub', v_labour2_id::text, 'email', 'dev_8801800000002@kaajlagbe.local'),
    'email', 'dev_8801800000002@kaajlagbe.local', now(), now(), now()
  ) on conflict (provider, provider_id) do update set last_sign_in_at = now();

  update public.users set
    full_name = 'Jamal Hossain',
    phone = '+8801800000002',
    role = 'labour',
    account_status = 'approved'
  where id = v_labour2_id;

  -- Approved identity for Jamal Hossain
  delete from public.identity_verifications where user_id = v_labour2_id;
  insert into public.identity_verifications (
    user_id, document_type, document_number, front_path, selfie_path,
    status, admin_id, created_at, reviewed_at
  ) values (
    v_labour2_id, 'nid', 'NID-19907162534',
    'demo/nid_jamal_front.jpg', 'demo/selfie_jamal.jpg',
    'approved', v_admin_id, now() - interval '3 days', now() - interval '2 days'
  );

  -- Labour Profile for Jamal Hossain
  insert into public.labour_profiles (user_id, experience, service_area, expected_wage, availability)
  values (
    v_labour2_id,
    '5 years in residential cleaning and terrace gardening',
    'Dhanmondi, Dhaka',
    400,
    'Sat-Fri 08:00-17:00'
  ) on conflict (user_id) do update set
    experience = '5 years in residential cleaning and terrace gardening',
    service_area = 'Dhanmondi, Dhaka',
    expected_wage = 400,
    availability = 'Sat-Fri 08:00-17:00';

  -- Labour Skills for Jamal Hossain
  delete from public.labour_skills where labour_id = v_labour2_id;
  if v_skill_cleaner is not null then
    insert into public.labour_skills (labour_id, skill_id, score, badge_active)
    values (v_labour2_id, v_skill_cleaner, 120.0, false);
  end if;
  if v_skill_gardener is not null then
    insert into public.labour_skills (labour_id, skill_id, score, badge_active)
    values (v_labour2_id, v_skill_gardener, 205.0, true);
  end if;

  -- ---------------------------------------------------------------------------
  -- 5. LABOUR #3: Nasir Ahmed (01800000003 -> 8801800000003) [Pending Admin Review Demo]
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, phone_confirmed_at,
    confirmation_token, recovery_token, email_change, email_change_token_new,
    raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_labour3_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801800000003@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801800000003', extensions.gen_salt('bf')),
    now(),
    '8801800000003',
    now(),
    '', '', '', '',
    '{"provider": "phone", "providers": ["email", "phone"]}'::jsonb,
    '{"full_name": "Nasir Ahmed", "role": "labour", "phone": "8801800000003"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    phone = '8801800000003',
    phone_confirmed_at = now(),
    confirmation_token = '',
    recovery_token = '',
    email_change = '',
    email_change_token_new = '',
    encrypted_password = extensions.crypt('DevKaajLagbe!8801800000003', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Nasir Ahmed", "role": "labour", "phone": "8801800000003"}'::jsonb,
    email_confirmed_at = now();

  insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  values (
    v_labour3_id::text, v_labour3_id,
    jsonb_build_object('sub', v_labour3_id::text, 'email', 'dev_8801800000003@kaajlagbe.local'),
    'email', 'dev_8801800000003@kaajlagbe.local', now(), now(), now()
  ) on conflict (provider, provider_id) do update set last_sign_in_at = now();

  update public.users set
    full_name = 'Nasir Ahmed',
    phone = '+8801800000003',
    role = 'labour',
    account_status = 'pending_verification'
  where id = v_labour3_id;

  -- Pending identity verification record for Nasir Ahmed (for Admin Desk Review Demo)
  delete from public.identity_verifications where user_id = v_labour3_id;
  insert into public.identity_verifications (
    user_id, document_type, document_number, front_path, back_path, selfie_path,
    status, admin_id, created_at, reviewed_at
  ) values (
    v_labour3_id, 'nid', 'NID-19957382910',
    'demo/nid_nasir_front.jpg', 'demo/nid_nasir_back.jpg', 'demo/selfie_nasir.jpg',
    'pending', null, now() - interval '2 hours', null
  );

  -- Labour Profile for Nasir Ahmed
  insert into public.labour_profiles (user_id, experience, service_area, expected_wage, availability)
  values (
    v_labour3_id,
    '3 years moving helper & carpenter',
    'Uttara, Dhaka',
    350,
    'Everyday 09:00-20:00'
  ) on conflict (user_id) do update set
    experience = '3 years moving helper & carpenter',
    service_area = 'Uttara, Dhaka',
    expected_wage = 350,
    availability = 'Everyday 09:00-20:00';

  delete from public.labour_skills where labour_id = v_labour3_id;
  if v_skill_moving is not null then
    insert into public.labour_skills (labour_id, skill_id, score, badge_active)
    values (v_labour3_id, v_skill_moving, 0, false);
  end if;
  if v_skill_carpenter is not null then
    insert into public.labour_skills (labour_id, skill_id, score, badge_active)
    values (v_labour3_id, v_skill_carpenter, 0, false);
  end if;

  -- ---------------------------------------------------------------------------
  -- 6. ADMIN: KaajLagbe Admin (01900000001 -> 8801900000001) [Admin Web Portal]
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, phone_confirmed_at,
    confirmation_token, recovery_token, email_change, email_change_token_new,
    raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_admin_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801900000001@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801900000001', extensions.gen_salt('bf')),
    now(),
    '8801900000001',
    now(),
    '', '', '', '',
    '{"provider": "phone", "providers": ["email", "phone"]}'::jsonb,
    '{"full_name": "KaajLagbe Admin", "role": "admin", "phone": "8801900000001"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    phone = '8801900000001',
    phone_confirmed_at = now(),
    confirmation_token = '',
    recovery_token = '',
    email_change = '',
    email_change_token_new = '',
    encrypted_password = extensions.crypt('DevKaajLagbe!8801900000001', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "KaajLagbe Admin", "role": "admin", "phone": "8801900000001"}'::jsonb,
    email_confirmed_at = now();

  insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  values (
    v_admin_id::text, v_admin_id,
    jsonb_build_object('sub', v_admin_id::text, 'email', 'dev_8801900000001@kaajlagbe.local'),
    'email', 'dev_8801900000001@kaajlagbe.local', now(), now(), now()
  ) on conflict (provider, provider_id) do update set last_sign_in_at = now();

  update public.users set
    full_name = 'KaajLagbe Admin',
    phone = '+8801900000001',
    role = 'admin',
    account_status = 'approved'
  where id = v_admin_id;

end $$;

-- ==============================================================================
-- VERIFICATION QUERIES
-- ==============================================================================
select 'users_count' as metric, count(*)::text as value from public.users
union all
select 'skills_count' as metric, count(*)::text as value from public.skills
union all
select 'bucket_' || id as metric, case when public then 'public' else 'private' end as value
from storage.buckets where id in ('avatars', 'identity-documents')
order by metric;

select id, phone, full_name, role, account_status
from public.users
where id in (
  '00000000-0000-0000-0000-000000000001'::uuid,
  '00000000-0000-0000-0000-000000000002'::uuid,
  '00000000-0000-0000-0000-000000000003'::uuid,
  '00000000-0000-0000-0000-000000000004'::uuid,
  '00000000-0000-0000-0000-000000000005'::uuid,
  '00000000-0000-0000-0000-000000000006'::uuid
) order by id;
