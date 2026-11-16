import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'admin_verification_desk_screen.dart';

/// Admin Operations Dashboard & Overview screen
class AdminOverviewScreen extends StatelessWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.admin_panel_settings_rounded,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              isBangla ? 'অ্যাডমিন ওভারভিউ' : 'Admin Overview',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Center(child: LanguageTogglePill()),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Health & Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            isBangla
                                ? 'জাতীয় পরিচয়পত্র যাচাই ও প্ল্যাটফর্ম নিয়ন্ত্রণ ডেস্ক'
                                : 'National ID Verification & Marketplace Control Desk',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // KPI Bento Grid
              Row(
                children: [
                  Expanded(
                    child: _buildKpiCard(
                      icon: Icons.people_outline_rounded,
                      iconColor: AppColors.primary,
                      title: isBangla ? '৬' : '6',
                      label: isBangla ? 'মোট ডেমো ইউজার' : 'Total Users',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildKpiCard(
                      icon: Icons.verified_user_rounded,
                      iconColor: AppColors.secondary,
                      title: isBangla ? '২' : '2',
                      label: isBangla ? 'অনুমোদিত শ্রমিক' : 'Verified Labour',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildKpiCard(
                      icon: Icons.pending_actions_rounded,
                      iconColor: AppColors.tertiary,
                      title: isBangla ? '১' : '1',
                      label: isBangla ? 'অপেক্ষমাণ এনআইডি' : 'Pending NID',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Quick Actions
              Text(
                isBangla ? 'অ্যাডমিন অ্যাকশন' : 'Admin Actions',
                style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminVerificationDeskScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.assignment_ind_rounded,
                            color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isBangla
                                  ? 'আইডেন্টিটি ভেরিফিকেশন ডেস্ক'
                                  : 'Identity Verification Desk',
                              style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isBangla
                                  ? 'অপেক্ষমাণ এনআইডি ও পাসপোর্ট নথি পর্যালোচনা করুন'
                                  : 'Review pending NID and Passport documents',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 16, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Recent Security & Audits
              Text(
                isBangla ? 'সাম্প্রতিক ভেরিফিকেশন রেকর্ড' : 'Recent Verifications',
                style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              _buildAuditTile(
                name: 'Nasir Ali',
                role: 'Labour',
                docType: 'NID-19958291024',
                status: isBangla ? 'অপেক্ষমাণ' : 'Pending Review',
                statusColor: AppColors.tertiary,
              ),
              const SizedBox(height: 8),
              _buildAuditTile(
                name: 'Karim Mia',
                role: 'Labour',
                docType: 'NID-19924820194',
                status: isBangla ? 'অনুমোদিত' : 'Approved',
                statusColor: AppColors.secondary,
              ),
              const SizedBox(height: 8),
              _buildAuditTile(
                name: 'Rahim Uddin',
                role: 'Customer',
                docType: 'NID-19881029381',
                status: isBangla ? 'অনুমোদিত' : 'Approved',
                statusColor: AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTile({
    required String name,
    required String role,
    required String docType,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.badge_rounded, size: 20, color: AppColors.textMuted),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text('$role • $docType',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: AppTextStyles.labelSmall.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

