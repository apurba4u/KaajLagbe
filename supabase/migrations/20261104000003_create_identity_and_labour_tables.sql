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

create policy "Anyone can read skills directory"
  on public.skills for select
  using (true);

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

create policy "Users can view their own identity verifications"
  on public.identity_verifications for select
  using (user_id = auth.uid());

create policy "Admins can view all identity verifications"
  on public.identity_verifications for select
  using (
    exists (
      select 1 from public.users
      where id = auth.uid() and role = 'admin'
    )
  );

create policy "Users can submit their own identity verification"
  on public.identity_verifications for insert
  with check (
    user_id = auth.uid()
    and status = 'pending'
    and admin_id is null
    and reviewed_at is null
  );

-- Direct client updates/deletes on verification records are disabled (admin reviews via RPC)
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

create policy "Anyone can read labour profiles"
  on public.labour_profiles for select
  using (true);

create policy "Labours can insert their own profile"
  on public.labour_profiles for insert
  with check (user_id = auth.uid());

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

create policy "Anyone can view labour skills"
  on public.labour_skills for select
  using (true);

create policy "Labours can add skills to their profile"
  on public.labour_skills for insert
  with check (
    labour_id = auth.uid()
    and score = 0
    and badge_active = false
  );

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

create policy "Users can view their own notifications"
  on public.notifications for select
  using (user_id = auth.uid());

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
