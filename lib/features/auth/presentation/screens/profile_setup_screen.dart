import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../auth_providers.dart';

/// Profile Setup Screen allowing new users to set their Full Name and Avatar
class ProfileSetupScreen extends ConsumerStatefulWidget {
  final UserRole selectedRole;

  const ProfileSetupScreen({
    super.key,
    required this.selectedRole,
  });

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? _avatarUrl;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSaveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'আপনার পূর্ণ নাম লিখুন / Please enter your full name';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final authController = ref.read(authControllerProvider.notifier);
    final success = await authController.updateProfile(
      fullName: name,
      avatarUrl: _avatarUrl,
    );

    if (!mounted) return;

    if (success) {
      // Invalidate profile stream to trigger AuthGate routing
      ref.invalidate(currentUserProfileProvider);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _errorMessage = 'প্রোফাইল সংরক্ষণ ব্যর্থ হয়েছে। ইন্টারনেট সংযোগ পরীক্ষা করুন।';
      });
    }
  }

  void _simulateAvatarPick() {
    // Generates a high-quality initial placeholder avatar URL
    final name = _nameController.text.trim();
    final seed = name.isNotEmpty ? Uri.encodeComponent(name) : 'KaajLagbeUser';
    setState(() {
      _avatarUrl = 'https://api.dicebear.com/7.x/initials/png?seed=$seed';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('অ্যাভাটার যুক্ত করা হয়েছে / Avatar selected'),
        backgroundColor: AppColors.secondary,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(
                    'প্রোফাইল সেটআপ',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.selectedRole == UserRole.labour
                          ? AppColors.secondaryContainer.withValues(alpha: 0.4)
                          : AppColors.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.selectedRole == UserRole.labour ? 'কর্মী' : 'গ্রাহক',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: widget.selectedRole == UserRole.labour
                            ? AppColors.secondary
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Avatar Selection Lockup
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.outline, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.onSurface.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _avatarUrl != null
                          ? Image.network(
                              _avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.person_rounded,
                                size: 54,
                                color: AppColors.textMuted,
                              ),
                            )
                          : const Icon(
                              Icons.person_rounded,
                              size: 54,
                              color: AppColors.textMuted,
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _simulateAvatarPick,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_camera_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextButton.icon(
                icon: const Icon(Icons.add_photo_alternate_rounded, size: 16),
                label: const Text('ছবি আপলোড করুন / Change Photo'),
                onPressed: _simulateAvatarPick,
              ),

              const SizedBox(height: 20),

              // Input Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'আপনার পূর্ণ নাম (NID অনুযায়ী) *',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Full Name as in National Identity Card',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      focusNode: _focusNode,
                      style: AppTextStyles.titleMedium,
                      decoration: InputDecoration(
                        hintText: 'যেমন: Tanvir Ahmed',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textMuted),
                      ),
                      onSubmitted: (_) => _handleSaveProfile(),
                    ),
                  ],
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 14),
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

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSaveProfile,
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
                              'সম্পূর্ণ করুন / Complete Profile',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.check_rounded, size: 20),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
