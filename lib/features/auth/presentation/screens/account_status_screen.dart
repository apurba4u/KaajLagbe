import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../auth_providers.dart';

/// Screen displayed when a user's account is in a non-approved state
/// (Pending Verification, Rejected, Suspended, or Permanently Banned).
/// Strictly blocks access to marketplace features.
class AccountStatusScreen extends ConsumerWidget {
  final AccountStatus status;

  const AccountStatusScreen({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statusConfig = _getStatusConfig(status, l10n);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          const Center(child: LanguageTogglePill()),
          const SizedBox(width: 8),
          IconButton(
            tooltip: l10n.refreshStatus,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
            onPressed: () {
              ref.invalidate(currentUserProfileProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.refreshingStatus),
                  duration: const Duration(seconds: 1),
                  backgroundColor: AppColors.secondary,
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Status Icon Indicator
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: statusConfig.badgeBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: statusConfig.borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: statusConfig.iconColor.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    statusConfig.icon,
                    size: 44,
                    color: statusConfig.iconColor,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                statusConfig.title,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Explanation Message
              Text(
                statusConfig.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Verification Steps Indicator (specifically for pending users)
              if (status == AccountStatus.pendingVerification) ...[
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
                      Text(
                        l10n.verificationProgress,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildProgressStep(
                        isCompleted: true,
                        isInProgress: false,
                        title: l10n.progressStepPhone,
                        subtitle: l10n.progressStepPhoneSub,
                      ),
                      _buildProgressStep(
                        isCompleted: false,
                        isInProgress: true,
                        title: l10n.progressStepReview,
                        subtitle: l10n.progressStepReviewSub,
                      ),
                      _buildProgressStep(
                        isCompleted: false,
                        isInProgress: false,
                        title: l10n.progressStepAccess,
                        subtitle: l10n.progressStepAccessSub,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Marketplace Protection Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.marketplaceProtectionTitle,
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.marketplaceProtectionSubtitle,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.checkStatusAction),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    ref.invalidate(currentUserProfileProvider);
                  },
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout_rounded, color: AppColors.onSurface),
                  label: Text(l10n.signOut),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: AppColors.outline),
                  ),
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).signOut();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep({
    required bool isCompleted,
    required bool isInProgress,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    final circleColor = isCompleted
        ? AppColors.secondary
        : isInProgress
            ? AppColors.primary
            : AppColors.outline;

    final circleIcon = isCompleted
        ? Icons.check_rounded
        : isInProgress
            ? Icons.sync_rounded
            : Icons.circle_outlined;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.secondary
                    : isInProgress
                        ? AppColors.primaryContainer.withValues(alpha: 0.5)
                        : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: circleColor, width: 2),
              ),
              child: Icon(
                circleIcon,
                size: 14,
                color: isCompleted
                    ? Colors.white
                    : isInProgress
                        ? AppColors.primary
                        : AppColors.textMuted,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isCompleted ? AppColors.secondary : AppColors.outline,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isInProgress ? AppColors.primary : AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              if (!isLast) const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }

  _StatusDisplayConfig _getStatusConfig(AccountStatus status, AppLocalizations l10n) {
    switch (status) {
      case AccountStatus.pendingVerification:
        return _StatusDisplayConfig(
          title: l10n.statusPendingTitle,
          message: l10n.statusPendingDescription,
          icon: Icons.hourglass_top_rounded,
          iconColor: AppColors.tertiary,
          borderColor: AppColors.tertiary,
          badgeBg: AppColors.tertiaryContainer.withValues(alpha: 0.3),
        );
      case AccountStatus.approved:
        return _StatusDisplayConfig(
          title: l10n.statusApprovedTitle,
          message: l10n.statusApprovedDescription,
          icon: Icons.check_circle_rounded,
          iconColor: AppColors.secondary,
          borderColor: AppColors.secondary,
          badgeBg: AppColors.secondaryContainer.withValues(alpha: 0.3),
        );
      case AccountStatus.rejected:
        return _StatusDisplayConfig(
          title: l10n.statusRejectedTitle,
          message: l10n.statusRejectedDescription,
          icon: Icons.cancel_rounded,
          iconColor: AppColors.error,
          borderColor: AppColors.error,
          badgeBg: AppColors.errorContainer.withValues(alpha: 0.3),
        );
      case AccountStatus.suspended:
        return _StatusDisplayConfig(
          title: l10n.statusSuspendedTitle,
          message: l10n.statusSuspendedDescription,
          icon: Icons.warning_rounded,
          iconColor: AppColors.error,
          borderColor: AppColors.error,
          badgeBg: AppColors.errorContainer.withValues(alpha: 0.3),
        );
      case AccountStatus.permanentlyBanned:
        return _StatusDisplayConfig(
          title: l10n.statusBannedTitle,
          message: l10n.statusBannedDescription,
          icon: Icons.block_rounded,
          iconColor: AppColors.error,
          borderColor: AppColors.error,
          badgeBg: AppColors.errorContainer.withValues(alpha: 0.3),
        );
    }
  }
}

class _StatusDisplayConfig {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color badgeBg;

  _StatusDisplayConfig({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.badgeBg,
  });
}
