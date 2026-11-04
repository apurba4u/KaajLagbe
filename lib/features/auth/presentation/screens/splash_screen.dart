import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// High-fidelity Mobile Splash Screen matching Stitch project 4425920303127488102
/// screen 7a4f55ca4234427fb8f643fc12ed915c with frozen Kinetic Trust tokens.
class SplashScreen extends StatelessWidget {
  final bool showProgress;
  final String statusText;

  const SplashScreen({
    super.key,
    this.showProgress = true,
    this.statusText = 'Connecting verified pros...',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 1. Top Bar: Presence & Language Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Dhaka',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Live Service',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.outline),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'বাং',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' / ',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.outline,
                                    ),
                                  ),
                                  Text(
                                    'EN',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // 2. Centered Hero Branding
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.outline),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.onSurface.withValues(alpha: 0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.handyman_rounded,
                                size: 36,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // App Name
                        Text(
                          AppConstants.appName,
                          style: AppTextStyles.displayLarge.copyWith(
                            color: AppColors.primary,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Bengali Tagline
                        Text(
                          'বিশ্বস্ত শ্রম ও দক্ষ কর্মী সেবা',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Verified Trust Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.verifiedChipBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified_user_rounded,
                                size: 16,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Verified Labour & Skilled Services',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Trust Metrics Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _buildMetricChip(
                                icon: Icons.check_circle_rounded,
                                iconColor: AppColors.secondary,
                                title: '100% NID',
                                subtitle: 'Verified Identity',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMetricChip(
                                icon: Icons.bolt_rounded,
                                iconColor: AppColors.primary,
                                title: '15 Mins',
                                subtitle: 'Fast Response',
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // 3. Bottom Progress & Trust Footer
                        if (showProgress) ...[
                          SizedBox(
                            width: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const LinearProgressIndicator(
                                minHeight: 4,
                                backgroundColor: AppColors.outline,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                statusText,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Security Assurance Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.shield_rounded,
                                    size: 16,
                                    color: AppColors.secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '100% Verified Workers • Transparent Pricing',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'National ID Checked • Trade Tested Reviews',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _buildMetricChip({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: iconColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

