import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    // Admin is never selectable
    if (_selectedRole == UserRole.admin) {
      setState(() {
        _errorMessage = l10n.roleAdminBlockedError;
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
        _errorMessage = l10n.roleSaveError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  const LanguageTogglePill(),
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
                      l10n.roleSelectionTrustBadge,
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
                l10n.roleSelectionTitle,
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                l10n.roleSelectionSubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
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
                title: l10n.customerRoleTitle,
                roleBadge: l10n.customerRoleBadge,
                description: l10n.customerRoleSubtitle,
                perks: [
                  l10n.customerPerk1,
                  l10n.customerPerk2,
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
                title: l10n.labourRoleTitle,
                roleBadge: l10n.labourRoleBadge,
                description: l10n.labourRoleSubtitle,
                perks: [
                  l10n.labourPerk1,
                  l10n.labourPerk2,
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

              const SizedBox(height: 28),

              // 5. Submit Action Button
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
                              l10n.continueAction,
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
              const SizedBox(height: 16),
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
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? iconColor : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            roleBadge,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: iconColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? iconColor : AppColors.outline,
                      width: 2,
                    ),
                    color: isSelected ? iconColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            ...perks.map((perk) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, size: 14, color: iconColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        perk,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
