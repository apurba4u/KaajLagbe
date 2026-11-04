import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Profile Setup Screen placeholder (to be completed in Task 2.5)
class ProfileSetupScreen extends StatelessWidget {
  final UserRole selectedRole;

  const ProfileSetupScreen({
    super.key,
    required this.selectedRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Profile Setup Screen (${selectedRole.name})',
          style: AppTextStyles.headlineMedium,
        ),
      ),
    );
  }
}
