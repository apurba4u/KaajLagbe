import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../auth_providers.dart';

/// Screen displayed when a user's account is not in an approved state.
/// Blocks access to marketplace features.
class AccountStatusScreen extends ConsumerWidget {
  final AccountStatus status;

  const AccountStatusScreen({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusConfig = _getStatusConfig(status);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Status Icon Indicator
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: statusConfig.badgeBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: statusConfig.borderColor, width: 2),
                ),
                child: Center(
                  child: Icon(
                    statusConfig.icon,
                    size: 48,
                    color: statusConfig.iconColor,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                statusConfig.title,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

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

              // Marketplace Protection Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Marketplace features (browsing, posting, and booking) remain locked for unverified accounts.',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Sign Out / Refresh Row
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('লগআউট / Sign Out'),
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).signOut();
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  static _StatusConfig _getStatusConfig(AccountStatus status) {
    switch (status) {
      case AccountStatus.pendingVerification:
        return _StatusConfig(
          title: 'যাচাইকরণ প্রক্রিয়াধীন / Under Verification',
          message:
              'আপনার জাতীয় পরিচয়পত্র ও অ্যাকাউন্ট তথ্য আমাদের প্রশাসনিক টিম যাচাই করছে। সাধারণ কার্যদিবসে ২৪-৪৮ ঘণ্টার মধ্যে অনুমোদন নিশ্চিত করা হবে।',
          icon: Icons.hourglass_top_rounded,
          iconColor: AppColors.tertiary,
          badgeBg: AppColors.ratingChipBg,
          borderColor: AppColors.tertiary,
        );
      case AccountStatus.rejected:
        return _StatusConfig(
          title: 'আবেদন প্রত্যাখ্যাত / Verification Rejected',
          message:
              'প্রদত্ত তথ্যে গরমিল বা অস্পষ্ট নথির কারণে আপনার অ্যাকাউন্ট যাচাইকরণ গ্রহণ করা সম্ভব হয়নি। সহায়তার জন্য হেল্প ডেস্কে যোগাযোগ করুন।',
          icon: Icons.cancel_outlined,
          iconColor: AppColors.error,
          badgeBg: AppColors.errorContainer,
          borderColor: AppColors.error,
        );
      case AccountStatus.suspended:
        return _StatusConfig(
          title: 'অ্যাকাউন্ট সাময়িক স্থগিত / Suspended',
          message:
              'প্ল্যাটফর্মের নীতিমালার সুরক্ষায় আপনার অ্যাকাউন্ট সাময়িকভাবে স্থগিত রাখা হয়েছে। পুনরায় সক্রিয় করতে অ্যাডমিনের সাথে যোগাযোগ করুন।',
          icon: Icons.warning_amber_rounded,
          iconColor: AppColors.tertiary,
          badgeBg: AppColors.tertiaryContainer,
          borderColor: AppColors.tertiary,
        );
      case AccountStatus.permanentlyBanned:
        return _StatusConfig(
          title: 'অ্যাকাউন্ট স্থায়ীভাবে নিষিদ্ধ / Banned',
          message:
              'গুরুতর নীতিমালা লঙ্ঘনের কারণে আপনার অ্যাকাউন্ট স্থায়ীভাবে নিষিদ্ধ করা হয়েছে। এই অ্যাকাউন্ট দ্বারা আর কোনো কার্যক্রম চালানো যাবে না।',
          icon: Icons.block_rounded,
          iconColor: AppColors.error,
          badgeBg: AppColors.errorContainer,
          borderColor: AppColors.error,
        );
      case AccountStatus.approved:
        return _StatusConfig(
          title: 'অনুমোদিত / Approved',
          message: 'আপনার অ্যাকাউন্ট সম্পূর্ণ সক্রিয়।',
          icon: Icons.verified_user_rounded,
          iconColor: AppColors.secondary,
          badgeBg: AppColors.verifiedChipBg,
          borderColor: AppColors.secondary,
        );
    }
  }
}

class _StatusConfig {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color badgeBg;
  final Color borderColor;

  _StatusConfig({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.badgeBg,
    required this.borderColor,
  });
}
