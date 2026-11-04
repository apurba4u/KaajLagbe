import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../auth_providers.dart';
import 'account_status_screen.dart';
import 'home_screen_placeholder.dart';
import 'phone_login_screen.dart';
import 'role_selection_screen.dart';
import 'splash_screen.dart';

/// Central reactive authentication and account status router for KaajLagbe
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    final user = ref.watch(currentAuthUserProvider);

    // 1. Unauthenticated -> Redirect to Phone Login
    if (session == null || user == null) {
      return const PhoneLoginScreen();
    }

    // 2. Authenticated -> Inspect user profile from Supabase
    final profileAsync = ref.watch(currentUserProfileProvider);

    return profileAsync.when(
      loading: () => const SplashScreen(
        statusText: 'অ্যাকাউন্ট লোড হচ্ছে / Verifying account...',
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  'সংযোগ বিচ্ছিন্ন হয়েছে / Network Error',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('পুনরায় চেষ্টা করুন / Retry'),
                  onPressed: () {
                    ref.invalidate(currentUserProfileProvider);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      data: (profile) {
        // If user profile is not yet in public.users (fresh signup)
        if (profile == null) {
          return const RoleSelectionScreen();
        }

        // New user without role or full name
        final metadataRole = user.userMetadata?['role'];
        if (metadataRole == null &&
            (profile.fullName == null || profile.fullName!.trim().isEmpty)) {
          return const RoleSelectionScreen();
        }

        // Account Status Gates
        if (profile.accountStatus == AccountStatus.approved) {
          return HomeScreenPlaceholder(profile: profile);
        } else {
          return AccountStatusScreen(status: profile.accountStatus);
        }
      },
    );
  }
}
