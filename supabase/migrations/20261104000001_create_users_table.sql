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
create policy "Users can update own profile"
  on public.users
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Note: No client-side INSERT policy exists.
-- User creation is handled exclusively via the security definer on_auth_user_created trigger.
