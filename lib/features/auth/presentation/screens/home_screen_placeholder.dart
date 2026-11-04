import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/user_profile.dart';
import '../auth_providers.dart';
import 'profile_settings_screen.dart';

/// Placeholder Home Screen displayed for Approved users until Phase 4 (Marketplace Discovery)
class HomeScreenPlaceholder extends ConsumerWidget {
  final UserProfile profile;

  const HomeScreenPlaceholder({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final displayName = profile.fullName ??
        (profile.role == UserRole.labour ? l10n.labourRoleBadge : l10n.customerRoleBadge);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.handyman_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          const Center(child: LanguageTogglePill()),
          const SizedBox(width: 4),
          IconButton(
            tooltip: l10n.profileSettingsTitle,
            icon: const Icon(Icons.person_rounded, color: AppColors.onSurface),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileSettingsScreen(profile: profile),
                ),
              );
            },
          ),
          IconButton(
            tooltip: l10n.signOut,
            icon: const Icon(Icons.logout_rounded, color: AppColors.onSurface),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Greeting Banner (Tappable to open Profile & Settings)
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileSettingsScreen(profile: profile),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outline),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.onSurface.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryContainer,
                        backgroundImage: profile.avatarUrl != null
                            ? NetworkImage(profile.avatarUrl!)
                            : null,
                        child: profile.avatarUrl == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 32,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.welcomeUser(displayName),
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.role == UserRole.labour
                                  ? l10n.labourRoleBadge
                                  : l10n.customerRoleBadge,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Placeholder Marketplace Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  children: [
                    Icon(
                      profile.role == UserRole.labour
                          ? Icons.work_history_rounded
                          : Icons.engineering_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.homeTitle,
                      style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile.role == UserRole.labour
                          ? l10n.homePlaceholderLabour
                          : l10n.homePlaceholderCustomer,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
