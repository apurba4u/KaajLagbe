# KaajLagbe

KaajLagbe is a verified labour finding and booking marketplace built with Flutter and Supabase. Customers post jobs and book verified labours (Electricians, Plumbers, Cleaners, Painters, Gardeners, Carpenters, Moving Helpers). Labours create profiles, showcase skills, accept bookings, verify work on-site, and earn skill-specific scores and badges.

## Architecture & Technology Stack

- **Mobile Application**: Flutter (Android & iOS), Material 3 design system.
- **Admin Panel**: Flutter Web (unified in repository).
- **Design System**: Kinetic Trust (Stitch MCP design tokens: Plus Jakarta Sans, `#E83E4D` Coral Red, `#168653` Verified Forest Green, `#D97706` Amber Alert).
- **State Management**: Riverpod.
- **Backend & Database**: Supabase (Auth, PostgreSQL, Realtime, Storage, RLS).
- **Push Notifications**: Firebase Cloud Messaging (FCM).
- **Maps**: OpenStreetMap / flutter_map.

## Project Structure

```
lib/
├── core/
│   ├── config/       # Environment & client configurations
│   ├── theme/        # Kinetic Trust theme tokens (colors, typography, theme)
│   ├── network/      # API & Supabase clients
│   └── utils/        # Common formatters & business rule validators
└── features/         # Feature-first domain modules
    ├── auth/         # Phone OTP auth, role selection & profile setup
    ├── verification/ # NID identity verification
    ├── labour/       # Labour profiles, skills & badges
    ├── booking/      # Work-hour matching, bookings & QR check-in
    ├── chat/         # In-app real-time chat & scope agreement
    ├── payment/      # Secure Payment (Sandbox simulation)
    ├── review/       # Skill-specific voting & scoring
    ├── dispute/      # Complaints & evidence handling
    └── admin/        # Admin web portal
```

---

## Authentication & Account Recovery

KaajLagbe utilizes passwordless Phone Number Authentication via Supabase SMS OTP:
- **Phone Number as Universal Identity**: In Bangladesh, mobile numbers (+880 prefix) serve as the primary identity key.
- **Account Recovery Built-in**: Because authentication relies entirely on SMS OTP verification, account recovery is intrinsically handled by the phone login flow. If a user changes their device or loses access, re-entering their phone number and verifying the 6-digit OTP restores access to their existing account and profile immediately without needing password reset links or security questions.

---

## Security & Row Level Security (RLS) Immutability

### Immutability Rules
1. **Self-Service Restriction**: Clients can only edit non-sensitive profile fields (`full_name`, `avatar_url`).
2. **Role & Account Status Immutability**: Neither `role` nor `account_status` can be changed client-side. The PostgreSQL trigger `enforce_user_immutability()` blocks non-admin users from updating these columns.
3. **Admin Promotion**: Only administrators (or service role / SQL Editor where `auth.uid() is null`) can elevate user roles or alter verification statuses.

### Manual Verification of RLS in Supabase SQL Editor

You can manually verify that users cannot escalate their privileges by executing the following in the Supabase SQL Editor:

```sql
-- 1. Simulate an authenticated user session
set local role authenticated;
set local request.jwt.claim.sub = '00000000-0000-0000-0000-000000000001';

-- 2. Attempt to self-promote to 'admin' (MUST FAIL)
update public.users
set role = 'admin'
where id = '00000000-0000-0000-0000-000000000001';
-- Expected Result:
-- ERROR: Unauthorized: Users cannot change their own role.

-- 3. Attempt to approve own account status (MUST FAIL)
update public.users
set account_status = 'approved'
where id = '00000000-0000-0000-0000-000000000001';
-- Expected Result:
-- ERROR: Unauthorized: Users cannot change their own account verification status.

-- 4. Legitimate update of display name (MUST SUCCEED)
update public.users
set full_name = 'Updated Name'
where id = '00000000-0000-0000-0000-000000000001';
-- Expected Result:
-- UPDATE 1
```

---

## Getting Started

### Prerequisites
- Flutter SDK 3.47+
- Dart SDK 3.13+

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/apurba4u/kaajlagbe.git
   cd kaajlagbe
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Copy environment configuration:
   ```bash
   cp .env.example .env
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## Supabase Manual Configuration Steps

To connect your local app with your live Supabase project, follow these manual steps in the Supabase Dashboard:

1. **Apply Database Migrations** (in Supabase Dashboard -> SQL Editor):
   - Run `supabase/migrations/20261104000001_create_users_table.sql`
   - Run `supabase/migrations/20261104000002_create_avatars_storage_bucket.sql`
2. **Enable Phone Authentication**:
   - Go to **Authentication** -> **Providers** -> **Phone**.
   - Enable Phone provider (e.g. via Twilio, MessageBird, or SMS Sandbox).
3. **Add Test Phone Numbers** (for testing without spending SMS credits):
   - Under **Authentication** -> **Providers** -> **Phone** -> **Test phone numbers**:
   - Add e.g. `+8801700000000` with OTP `123456`.
   - Add e.g. `+8801800000000` with OTP `123456`.
4. **Confirm Avatars Storage Bucket**:
   - Go to **Storage** -> Buckets. Verify the `avatars` bucket is marked public with 2MB limit.
