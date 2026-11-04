import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/user_profile.dart';
import '../auth_providers.dart';

/// Customer Profile & Settings Screen faithfully implementing Stitch design
/// screen 241d5c4532a245c1a2c06ac21e8fd5f8 with frozen Kinetic Trust tokens.
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  final UserProfile profile;

  const ProfileSettingsScreen({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  bool _isBengali = true;

  Future<void> _showEditNameDialog() async {
    final controller = TextEditingController(text: widget.profile.fullName ?? '');
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'নাম পরিবর্তন করুন / Edit Name',
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'পূর্ণ নাম লিখুন / Full name',
                filled: true,
                fillColor: AppColors.background,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'নাম খালি রাখা যাবে না / Name cannot be empty';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('বাতিল / Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop();
                  await ref.read(authControllerProvider.notifier).updateProfile(
                        fullName: controller.text.trim(),
                      );
                  ref.invalidate(currentUserProfileProvider);
                }
              },
              child: const Text('সংরক্ষণ করুন / Save'),
            ),
          ],
        );
      },
    );
  }

  void _handleSimulateAvatarChange() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('অ্যাভাটার ছবি পরিবর্তনের ক্যামেরা ডায়ালগ খোলা হয়েছে'),
        backgroundColor: AppColors.secondary,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Row(
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
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_rounded, size: 14, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text(
                  'মিরপুর ১০, ঢাকা',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar with Camera Edit Icon
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.primaryContainer,
                              backgroundImage: profile.avatarUrl != null
                                  ? NetworkImage(profile.avatarUrl!)
                                  : null,
                              child: profile.avatarUrl == null
                                  ? Text(
                                      (profile.fullName?.isNotEmpty ?? false)
                                          ? profile.fullName![0].toUpperCase()
                                          : 'U',
                                      style: AppTextStyles.headlineLarge.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : null,
                            ),
                            GestureDetector(
                              onTap: _handleSimulateAvatarChange,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.photo_camera_rounded,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 14),

                        // Name, Phone, and Edit CTA
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      profile.fullName ?? 'গ্রাহক / Customer',
                                      style: AppTextStyles.headlineSmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _showEditNameDialog,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.outline),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.edit_rounded,
                                            size: 12,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            'এডিট',
                                            style: AppTextStyles.labelSmall.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.call_rounded,
                                      size: 13, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    profile.phone ?? '+880 1XXXXXXXXX',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'রোল: ${profile.role.name.toUpperCase()}',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // NID Verification Shield Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
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
                                  'জাতীয় পরিচয়পত্র যাচাইকৃত',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'NID Verified Citizen • সর্বোচ্চ নিরাপত্তা স্তর',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Quick Stats Bento Row
              Row(
                children: [
                  Expanded(
                    child: _buildBentoCard(
                      icon: Icons.task_alt_rounded,
                      iconColor: AppColors.primary,
                      title: '০টি',
                      label: 'মোট বুকিং',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBentoCard(
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.secondary,
                      title: '১টি',
                      label: 'সেভ করা ঠিকানা',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBentoCard(
                      icon: Icons.account_balance_wallet_rounded,
                      iconColor: AppColors.tertiary,
                      title: '৳০',
                      label: 'ব্যালেন্স',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 3. Section: অ্যাকাউন্ট ও ঠিকানা (Account & Places)
              _buildSectionHeader('অ্যাকাউন্ট ও ঠিকানা', 'Account & Places'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      icon: Icons.pin_drop_rounded,
                      iconColor: AppColors.primary,
                      title: 'সংরক্ষিত ঠিকানাসমূহ',
                      subtitle: 'বাসা: মিরপুর ১০, ঢাকা',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppColors.outline),
                    _buildSettingsRow(
                      icon: Icons.credit_card_rounded,
                      iconColor: AppColors.secondary,
                      title: 'পেমেন্ট মেথড ও লেনদেন হিস্ট্রি',
                      subtitle: 'বিকাশ / নগদ / কার্ড',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. Section: নিরাপত্তা ও নীতি (Safety & Policy)
              _buildSectionHeader('নিরাপত্তা ও নীতি', 'Safety & Controls'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      icon: Icons.emergency_rounded,
                      iconColor: AppColors.error,
                      title: 'জরুরি যোগাযোগ ও নিরাপত্তা সেন্টার',
                      subtitle: 'জরুরি হেল্পলাইন ও লাইভ ট্র্যাকিং',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppColors.outline),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.translate_rounded,
                                  size: 18,
                                  color: AppColors.tertiary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ভাষা পরিবর্তন',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'অ্যাপের ভাষা নির্বাচন করুন',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.outline),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _isBengali = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isBengali ? AppColors.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      'বাংলা',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: _isBengali ? Colors.white : AppColors.textMuted,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _isBengali = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !_isBengali ? AppColors.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      'ENG',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: !_isBengali ? Colors.white : AppColors.textMuted,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.outline),
                    _buildSettingsRow(
                      icon: Icons.policy_rounded,
                      iconColor: AppColors.onSurface,
                      title: 'গোপনীয়তা ও টার্মস অব সার্ভিস',
                      subtitle: 'ব্যবহারকারীর তথ্য সুরক্ষা নীতি',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 5. Section: সহায়তা ও অভিযোগ (Help & Support)
              _buildSectionHeader('সহায়তা ও অভিযোগ', 'Help & Disputes'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      icon: Icons.support_agent_rounded,
                      iconColor: AppColors.secondary,
                      title: 'হেল্প সেন্টার ও কাস্টমার কেয়ার',
                      subtitle: 'হটলাইন ১৬৪২০ অথবা লাইভ চ্যাট (২৪/৭)',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppColors.outline),
                    _buildSettingsRow(
                      icon: Icons.report_problem_rounded,
                      iconColor: AppColors.tertiary,
                      title: 'আমার বিরোধ ও অভিযোগের স্ট্যাটাস',
                      subtitle: 'সক্রিয় বিরোধসমূহ ট্র্যাকিং',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 6. Section: Log Out Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout_rounded, color: AppColors.primary),
                  label: Text(
                    'লগআউট (Log Out)',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).signOut();
                    if (!context.mounted) return;
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Column(
                  children: [
                    Text(
                      'KaajLagbe v1.0.0 (Dhaka Release)',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'সর্বস্বত্ব সংরক্ষিত © ২০২৬ কাজলাগবে বাংলাদেশ',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
