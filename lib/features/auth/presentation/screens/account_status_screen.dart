import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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
    final statusConfig = _getStatusConfig(status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'রিফ্রেশ / Check Status',
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
            onPressed: () {
              ref.invalidate(currentUserProfileProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('অ্যাকাউন্টের সর্বশেষ অবস্থা যাচাই করা হচ্ছে...'),
                  duration: Duration(seconds: 1),
                  backgroundColor: AppColors.secondary,
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'লগআউট / Sign Out',
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
                        'যাচাইকরণ অগ্রগতি / Verification Progress',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildProgressStep(
                        isCompleted: true,
                        isInProgress: false,
                        title: 'মোবাইল নম্বর ও ওটিপি যাচাই',
                        subtitle: 'সফলভাবে সম্পন্ন হয়েছে',
                      ),
                      _buildProgressStep(
                        isCompleted: false,
                        isInProgress: true,
                        title: 'প্রশাসনিক পর্যালোচনা ও NID অনুমোদন',
                        subtitle: 'অ্যাডমিন টিম নথিপত্র পরীক্ষা করছে (২৪-৪৮ ঘণ্টা)',
                      ),
                      _buildProgressStep(
                        isCompleted: false,
                        isInProgress: false,
                        title: 'মার্কেটপ্লেস প্রবেশাধিকার',
                        subtitle: 'অনুমোদনের পর সম্পূর্ণ সেবা উন্মুক্ত হবে',
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
                            'মার্কেটপ্লেস সুরক্ষা নীতি',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'অননুমোদিত বা স্থগিত অ্যাকাউন্ট দ্বারা সেবা অনুসন্ধান, কর্মী বুকিং বা কাজ গ্রহণ সম্পূর্ণ ব্লক রাখা হয়।',
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
                  label: const Text('স্ট্যাটাস রিফ্রেশ করুন / Check Status'),
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
                  label: const Text('লগআউট / Sign Out'),
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

              const SizedBox(height: 24),

              Text(
                'সাহায্য প্রয়োজন? হটলাইন ১৬৪২০ অথবা support@kaajlagbe.com',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildProgressStep({
    required bool isCompleted,
    required bool isInProgress,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.secondary
                    : isInProgress
                        ? AppColors.tertiary
                        : AppColors.background,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.secondary
                      : isInProgress
                          ? AppColors.tertiary
                          : AppColors.outline,
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : isInProgress
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
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
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              if (!isLast) const SizedBox(height: 12),
            ],
          ),
        ),
      ],
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
