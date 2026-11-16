import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Prominent banner displayed across the Design Preview Hub
class DesignPreviewBanner extends StatelessWidget {
  final bool isBangla;

  const DesignPreviewBanner({
    super.key,
    required this.isBangla,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.tertiary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.visibility_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBangla
                      ? 'ডিজাইন প্রিভিউ: লগইন নিষ্ক্রিয়'
                      : 'DESIGN PREVIEW: Login Disabled',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.tertiary,
                  ),
                ),
                Text(
                  isBangla
                      ? 'সব স্ক্রিন ও স্টেট ইন-মেমোরি ফেক ডাটা দিয়ে পরীক্ষা করুন।'
                      : 'Browse every screen directly with in-memory mock personas.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.75),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

