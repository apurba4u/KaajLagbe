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
---

## Re-enabling OTP & Dev Mode Fast Login

During development and testing, sending real SMS OTPs can consume credits or encounter third-party rate limits. KaajLagbe provides an environment toggle with a strict compile-time release guard:

### 1. The `OTP_REQUIRED` Configuration
In `.env`:
```env
# Set to false to enable OTP skip in local debug builds
OTP_REQUIRED=true
```

- **Default Value**: `true` (standard SMS OTP verification active).
- **Release Guard (`kReleaseMode`)**: In release builds (e.g., `flutter build apk --release` or `flutter build web --release`), `EnvConfig.otpRequired` evaluates strictly to `true` regardless of `.env`. The dev-mode bypass code throws an `UnsupportedError` if invoked in release mode.

### 2. How Dev-Mode Fast Login Works
When `OTP_REQUIRED=false` in debug mode:
1. The Phone Login screen displays a visible `DEV MODE: OTP skipped` banner.
2. A fast-action button `Continue without OTP (dev mode)` appears below the standard OTP button.
3. Tapping it generates a deterministic dev identity (`dev_<cleanedDigits>@kaajlagbe.local`) and authenticates via Supabase Auth without sending SMS.
4. Supabase's `handle_new_auth_user()` database trigger extracts the phone number and metadata, auto-populating `public.users` with default `pending_verification` status and enforcing all standard Row Level Security (RLS) constraints.

### 3. Supabase Requirements for Dev-Mode Fast Login
If using `OTP_REQUIRED=false`:
- Navigate to **Authentication** -> **Providers** -> **Email** in the Supabase Dashboard.
- Ensure **Email provider** is **Enabled**.
- Ensure **Confirm email** is **Disabled** (so test accounts can log in immediately).

### 4. How to Re-Enable Strict SMS OTP
To return to full SMS OTP behavior at any time:
1. In `.env`, set `OTP_REQUIRED=true` (or remove the line to restore default `true`).
2. Restart the application.
3. Configure your SMS provider (Twilio / MessageBird) or add test phone numbers under **Authentication** -> **Providers** -> **Phone** in Supabase.

---

## Demo Accounts (Dev / Testing Seed)

To rapidly test and demo all platform personas without requiring live SMS or manual registration, a dedicated seed script is provided at `supabase/seed/demo_users.sql`.

> [!CAUTION]
> **DEV/DEMO ONLY**: Never run `supabase/seed/demo_users.sql` in production environments.

### How to Run the Seed Script
1. Open your Supabase Project Dashboard -> **SQL Editor**.
2. Paste the contents of `supabase/seed/demo_users.sql` and click **Run**.
3. In your local `.env` file, set `OTP_REQUIRED=false` for instant dev login, OR keep `OTP_REQUIRED=true` and configure Supabase Test Phone Numbers below.
4. Launch the KaajLagbe app, tap any **Quick-Fill Chip** on the phone screen (or type the 10-digit number), and either tap **"Continue without OTP (dev mode)"** or tap **"Send OTP"** (entering `123456`).

### Supabase Phone OTP Test Numbers Setup
To test the real SMS OTP verification screens without consuming SMS credits or triggering carrier rate limits:
1. Open your Supabase Project Dashboard.
2. Navigate to **Authentication** -> **Providers** -> **Phone**.
3. Under **Test phone numbers**, paste the following test-number mapping string:
   ```text
   8801700000001=123456, 8801700000002=123456, 8801800000001=123456, 8801800000002=123456, 8801800000003=123456, 8801900000001=123456
   ```
4. Click **Save**.
5. Test OTP for all 6 accounts is `123456`. When verified, Supabase immediately authenticates the user into their pre-seeded profile because `auth.users.phone` is stored as `880XXXXXXXXXX` (without `+`) with `phone_confirmed_at = now()`.

### Seeded Persona Matrix

| Role | Phone (Type in App) | Full Phone | Name | What to Demo |
| :--- | :--- | :--- | :--- | :--- |
| **Customer** | `1700000001` | `+8801700000001` | Rahim Uddin | Approved Customer, booking workers, posting jobs, reviews. |
| **Customer #2** | `1700000002` | `+8801700000002` | Sadia Akter | Approved Customer #2, multi-user bookings and chat simulation. |
| **Labour #1** | `1800000001` | `+8801800000001` | Karim Mia | Master Electrician (Score: 245.5, Active Badge), Plumber (Score: 212, Active Badge), Painter (Score: 146.5). Mirpur service area, ৳600/hr. |
| **Labour #2** | `1800000002` | `+8801800000002` | Jamal Hossain | Cleaner (Score: 120), Gardener (Score: 205, Active Badge). Dhanmondi area, ৳400/hr. |
| **Labour #3** | `1800000003` | `+8801800000003` | Nasir Ahmed | **Pending Verification Demo**: Moving Helper & Carpenter. Shows pending verification status screen; used to demo Admin approval flow. |
| **Admin** | `1900000001` | `+8801900000001` | KaajLagbe Admin | **Admin Web Portal**: Dedicated admin account for logging into the Flutter Web Admin Panel (`lib/admin_main.dart`), reviewing NIDs, and approving/rejecting verifications. |

> [!NOTE]
> The Admin account (`1900000001`) is specifically intended for the Flutter Web Admin Panel built in Phase 3 Task 3.4.

---

## Localization (Bangla & English)

KaajLagbe features complete, first-class bilingual localization (Bangla default, `bn`, and English, `en`).

### Core Rules for Developers
1. **Mandatory Dual-ARB Updates**: Every new user-facing string (labels, buttons, validation errors, dialogs, banners) MUST be added to BOTH `lib/l10n/app_bn.arb` and `lib/l10n/app_en.arb`. Never hardcode user-facing strings in UI widgets.
2. **Never Mix Languages**: Bilingual slash labels (such as "ওটিপি পাঠান / Send OTP") are strictly forbidden. Use `AppLocalizations.of(context)!.sendOtp` so the UI cleanly renders in the selected language.
3. **Brand Name Immutability**: The brand name **KaajLagbe** must always remain in English across both languages.
4. **Numeral & Currency Formatting**:
   - In Bangla mode, display numbers (scores, timers, countdowns, badges) use Bengali numerals (`০-৯`).
   - Currency is formatted with the Bangladeshi Taka symbol `৳` (e.g. `৳ ৬০০`).
   - Phone and OTP input fields accept both Bengali (`০-৯`) and ASCII (`0-9`) characters and normalize them to ASCII before submitting to Supabase.
5. **Shared Language Toggle**: Use the reusable `LanguageTogglePill` (`lib/core/presentation/widgets/language_toggle_button.dart`) in top app bars, or the interactive language selector in Profile & Settings. Both immediately update the app-wide `localeProvider` and persist the choice in `shared_preferences`.
6. **Font Fallback**: All typography uses `AppTextStyles` configured with GoogleFonts Plus Jakarta Sans and graceful fallbacks for Bengali glyphs (`Noto Sans Bengali`, `Hind Siliguri`, `sans-serif`).



