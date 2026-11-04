import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../auth_providers.dart';
import 'profile_setup_screen.dart';

/// Role Selection Screen strictly implementing Stitch design 6418713b4a11452e9ffe37d0572454a6
/// with frozen Kinetic Trust tokens.
class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.customer;
  String? _errorMessage;

  Future<void> _handleContinue() async {
    // Admin is never selectable
    if (_selectedRole == UserRole.admin) {
      setState(() {
        _errorMessage = 'অ্যাডমিন ভূমিকা নির্বাচনযোগ্য নয় / Admin role cannot be selected.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final authController = ref.read(authControllerProvider.notifier);
    final success = await authController.setInitialRole(_selectedRole);

    if (!mounted) return;

    if (success) {
      // Also update auth user metadata safely
      try {
        final client = ref.read(supabaseClientProvider);
        await client.auth.updateUser(
          UserAttributes(data: {'role': _selectedRole.value}),
        );
      } catch (_) {
        // Silently tolerate if offline or handled via server-side trigger
      }

      if (!mounted) return;

      // Navigate to profile setup (name + avatar)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfileSetupScreen(selectedRole: _selectedRole),
        ),
      );
    } else {
      setState(() {
        _errorMessage =
            'ভূমিকা সংরক্ষণ করতে সমস্যা হয়েছে। ইন্টারনেট সংযোগ পরীক্ষা করুন।';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Navigation Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      side: const BorderSide(color: AppColors.outline),
                    ),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.handyman_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppConstants.appName,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Text(
                      'বাং | EN',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 2. Trust Chip & Headlines
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      size: 14,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'নিরাপদ ও সহজ শুরু',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'আপনার ভূমিকা নির্বাচন করুন',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'আপনি কীভাবে KaajLagbe ব্যবহার করতে চান?',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),

              Text(
                'Choose how you\'d like to use KaajLagbe',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 24),

              // 3. Role 1: Customer Card
              _buildRoleCard(
                role: UserRole.customer,
                isSelected: _selectedRole == UserRole.customer,
                icon: Icons.home_repair_service_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                title: 'আমার সেবা প্রয়োজন',
                roleBadge: 'গ্রাহক / Customer',
                description:
                    'বাসা বা অফিসের কাজের জন্য যাচাইকৃত ও বিশ্বস্ত কর্মী খুঁজে নিন ও বুক করুন',
                perks: const [
                  'যাচাইকৃত দক্ষ কর্মী',
                  'স্বচ্ছ রেট ও সরাসরি বুকিং',
                ],
                onTap: () {
                  setState(() {
                    _selectedRole = UserRole.customer;
                  });
                },
              ),

              const SizedBox(height: 16),

              // 4. Role 2: Labour / Worker Card
              _buildRoleCard(
                role: UserRole.labour,
                isSelected: _selectedRole == UserRole.labour,
                icon: Icons.engineering_rounded,
                iconColor: AppColors.secondary,
                iconBgColor: AppColors.secondaryContainer.withValues(alpha: 0.3),
                title: 'আমি কাজ করতে চাই',
                roleBadge: 'কর্মী / Labour',
                description:
                    'আপনার দক্ষতা যোগ করুন, সরাসরি বুকিং পান এবং আয় বৃদ্ধি করুন',
                perks: const [
                  'সরাসরি পেমেন্ট',
                  'নতুন কাজের নিয়মিত সুযোগ',
                ],
                onTap: () {
                  setState(() {
                    _selectedRole = UserRole.labour;
                  });
                },
              ),

              // Error display
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // 5. Verification Assurance Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: AppColors.secondary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'জাতীয় পরিচয়পত্র যাচাইকরণ বাধ্যতামূলক • ১০০% সুরক্ষিত প্ল্যাটফর্ম',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 6. Continue CTA Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'চালিয়ে যান / Continue',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'এগিয়ে যাওয়ার মাধ্যমে আপনি KaajLagbe-এর নিয়মাবলীতে সম্মতি জানাচ্ছেন',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required bool isSelected,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String roleBadge,
    required String description,
    required List<String> perks,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryContainer.withValues(alpha: 0.5)
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          roleBadge,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Radio indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outline,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.outline),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: perks.map((perk) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 15,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      perk,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
