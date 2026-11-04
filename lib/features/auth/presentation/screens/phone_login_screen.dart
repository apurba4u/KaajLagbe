import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Mobile Phone Login screen placeholder (to be completed in Task 2.3)
class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Phone Login Screen',
          style: AppTextStyles.headlineMedium,
        ),
      ),
    );
  }
}
