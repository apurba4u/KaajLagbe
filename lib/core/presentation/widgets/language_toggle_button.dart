import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../localization/locale_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Reusable Language Toggle Pill strictly following the Stitch Kinetic Trust design.
/// Seamlessly toggles between Bangla ('bn') and English ('en') and updates the entire app.
class LanguageTogglePill extends ConsumerWidget {
  const LanguageTogglePill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isBangla = currentLocale.languageCode == 'bn';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(localeProvider.notifier).toggleLocale();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  color: isBangla ? AppColors.primary : AppColors.textMuted,
                  fontWeight: isBangla ? FontWeight.bold : FontWeight.w500,
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
                  color: !isBangla ? AppColors.primary : AppColors.textMuted,
                  fontWeight: !isBangla ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

