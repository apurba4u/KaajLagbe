-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- DEV/DEMO ONLY - NEVER RUN THIS SCRIPT ON PRODUCTION!
-- Description: Seeds 6 deterministic test accounts with known phone-derived
--              credentials matching SupabaseAuthRepository.signInWithDevPhone.
-- Safe to re-run multiple times (idempotent).
--
-- Password for all demo accounts follows the deterministic pattern:
--   Email:    dev_<digits>@kaajlagbe.local
--   Password: DevKaajLagbe!<digits>
-- where <digits> is the 13-digit E.164 number without '+' (e.g., 8801700000001).
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

do $$
declare
  v_crypt_func text;
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

  -- Helper closure logic for upserting an auth user
  -- ---------------------------------------------------------------------------
  -- 1. CUSTOMER #1: Rahim Uddin (01700000001 -> +8801700000001)
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_customer1_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801700000001@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801700000001', extensions.gen_salt('bf')),
    now(),
    '+8801700000001',
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"full_name": "Rahim Uddin", "role": "customer", "phone": "+8801700000001"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    encrypted_password = extensions.crypt('DevKaajLagbe!8801700000001', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Rahim Uddin", "role": "customer", "phone": "+8801700000001"}'::jsonb,
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
  -- 2. CUSTOMER #2: Sadia Akter (01700000002 -> +8801700000002)
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_customer2_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801700000002@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801700000002', extensions.gen_salt('bf')),
    now(),
    '+8801700000002',
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"full_name": "Sadia Akter", "role": "customer", "phone": "+8801700000002"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    encrypted_password = extensions.crypt('DevKaajLagbe!8801700000002', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Sadia Akter", "role": "customer", "phone": "+8801700000002"}'::jsonb,
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
  -- 3. LABOUR #1: Karim Mia (01800000001 -> +8801800000001) [Electrician Master]
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_labour1_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801800000001@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801800000001', extensions.gen_salt('bf')),
    now(),
    '+8801800000001',
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"full_name": "Karim Mia", "role": "labour", "phone": "+8801800000001"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    encrypted_password = extensions.crypt('DevKaajLagbe!8801800000001', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Karim Mia", "role": "labour", "phone": "+8801800000001"}'::jsonb,
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
  -- 4. LABOUR #2: Jamal Hossain (01800000002 -> +8801800000002) [Cleaner & Gardener]
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_labour2_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801800000002@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801800000002', extensions.gen_salt('bf')),
    now(),
    '+8801800000002',
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"full_name": "Jamal Hossain", "role": "labour", "phone": "+8801800000002"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    encrypted_password = extensions.crypt('DevKaajLagbe!8801800000002', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Jamal Hossain", "role": "labour", "phone": "+8801800000002"}'::jsonb,
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
  -- 5. LABOUR #3: Nasir Ahmed (01800000003 -> +8801800000003) [Pending Admin Review Demo]
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_labour3_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801800000003@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801800000003', extensions.gen_salt('bf')),
    now(),
    '+8801800000003',
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"full_name": "Nasir Ahmed", "role": "labour", "phone": "+8801800000003"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    encrypted_password = extensions.crypt('DevKaajLagbe!8801800000003', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "Nasir Ahmed", "role": "labour", "phone": "+8801800000003"}'::jsonb,
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
  -- 6. ADMIN: KaajLagbe Admin (01900000001 -> +8801900000001) [Admin Web Portal]
  -- ---------------------------------------------------------------------------
  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, phone, raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    v_admin_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'dev_8801900000001@kaajlagbe.local',
    extensions.crypt('DevKaajLagbe!8801900000001', extensions.gen_salt('bf')),
    now(),
    '+8801900000001',
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"full_name": "KaajLagbe Admin", "role": "admin", "phone": "+8801900000001"}'::jsonb,
    now(), now()
  ) on conflict (id) do update set
    encrypted_password = extensions.crypt('DevKaajLagbe!8801900000001', extensions.gen_salt('bf')),
    raw_user_meta_data = '{"full_name": "KaajLagbe Admin", "role": "admin", "phone": "+8801900000001"}'::jsonb,
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
