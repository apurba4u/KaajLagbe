import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/user_profile.dart';
import '../auth_providers.dart';

/// Placeholder Home Screen displayed for Approved users until Phase 4 (Marketplace Discovery)
class HomeScreenPlaceholder extends ConsumerWidget {
  final UserProfile profile;

  const HomeScreenPlaceholder({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          IconButton(
            tooltip: 'Sign Out',
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
              // User Greeting Banner
              Container(
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
                          ? Text(
                              (profile.fullName?.isNotEmpty ?? false)
                                  ? profile.fullName![0].toUpperCase()
                                  : 'U',
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  profile.fullName ?? 'KaajLagbe Member',
                                  style: AppTextStyles.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.verifiedChipBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.verified_rounded,
                                      size: 12,
                                      color: AppColors.secondary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Approved',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.phone ?? 'No phone attached',
                            style: AppTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Role: ${profile.role.name.toUpperCase()}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Marketplace Placeholder Notice
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.explore_rounded, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          profile.isLabour
                              ? 'Labour Job Dashboard'
                              : 'Marketplace Service Discovery',
                          style: AppTextStyles.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile.isLabour
                          ? 'Your account is verified and ready. You will receive booking requests from customers in your area once marketplace jobs are published.'
                          : 'Discover certified electricians, plumbers, cleaners, and technicians across Dhaka. Full search and booking will be enabled in Phase 4.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
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
