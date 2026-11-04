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
│   └── utils/        # Common formatters & helpers
└── features/         # Feature-first domain modules
    ├── auth/         # Phone OTP auth & role selection
    ├── verification/ # NID/Passport identity verification
    ├── labour/       # Labour profiles, skills & badges
    ├── booking/      # Work-hour matching, bookings & QR check-in
    ├── chat/         # In-app real-time chat & scope agreement
    ├── payment/      # Secure payment simulation (sandbox)
    ├── review/       # Skill-specific voting & scoring
    ├── dispute/      # Complaints & evidence handling
    └── admin/        # Admin web portal
```

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
