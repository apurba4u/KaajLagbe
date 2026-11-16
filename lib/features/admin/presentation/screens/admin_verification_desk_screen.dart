import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../verification/domain/identity_verification.dart';
import '../../../preview/domain/preview_data.dart';

/// Admin Verification Review Desk Screen for verifying National ID & Passports
class AdminVerificationDeskScreen extends StatefulWidget {
  const AdminVerificationDeskScreen({super.key});

  @override
  State<AdminVerificationDeskScreen> createState() =>
      _AdminVerificationDeskScreenState();
}

class _AdminVerificationDeskScreenState extends State<AdminVerificationDeskScreen> {
  late List<IdentityVerification> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(PreviewData.allVerifications);
  }

  void _handleApprove(IdentityVerification item) {
    setState(() {
      final index = _items.indexWhere((v) => v.id == item.id);
      if (index != -1) {
        _items[index] = IdentityVerification(
          id: item.id,
          userId: item.userId,
          documentType: item.documentType,
          documentNumber: item.documentNumber,
          frontPath: item.frontPath,
          backPath: item.backPath,
          selfiePath: item.selfiePath,
          status: 'approved',
          adminId: PreviewData.adminId,
          createdAt: item.createdAt,
          reviewedAt: DateTime.now(),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Identity approved successfully (Preview Mode)'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  void _handleReject(IdentityVerification item) {
    showDialog(
      context: context,
      builder: (ctx) {
        final reasonCtrl = TextEditingController(
          text: 'ঝাপসা ছবি / Blurry photo, national ID number is unreadable',
        );

        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Reject Verification',
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Provide rejection reason visible to the user:',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonCtrl,
                maxLines: 3,
                style: AppTextStyles.bodySmall,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.outline),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  final index = _items.indexWhere((v) => v.id == item.id);
                  if (index != -1) {
                    _items[index] = IdentityVerification(
                      id: item.id,
                      userId: item.userId,
                      documentType: item.documentType,
                      documentNumber: item.documentNumber,
                      frontPath: item.frontPath,
                      backPath: item.backPath,
                      selfiePath: item.selfiePath,
                      status: 'rejected',
                      rejectionReason: reasonCtrl.text.trim(),
                      adminId: PreviewData.adminId,
                      createdAt: item.createdAt,
                      reviewedAt: DateTime.now(),
                    );
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Identity rejected with reason (Preview Mode)'),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              child: const Text('Confirm Reject'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Text(
          isBangla ? 'ভেরিফিকেশন ডেস্ক' : 'Verification Desk',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Center(child: LanguageTogglePill()),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final item = _items[index];
            final isPending = item.status == 'pending';
            final isApproved = item.status == 'approved';
            final isRejected = item.status == 'rejected';

            Color statusColor = AppColors.tertiary;
            String statusText = isBangla ? 'অপেক্ষমাণ' : 'Pending Review';
            if (isApproved) {
              statusColor = AppColors.secondary;
              statusText = isBangla ? 'অনুমোদিত' : 'Approved';
            } else if (isRejected) {
              statusColor = AppColors.error;
              statusText = isBangla ? 'প্রত্যাখ্যাত' : 'Rejected';
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isPending ? AppColors.tertiary.withValues(alpha: 0.5) : AppColors.outline,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            item.documentType == 'nid'
                                ? Icons.badge_rounded
                                : Icons.flight_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.documentType == 'nid' ? 'NID' : 'Passport',
                            style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
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
                          statusText,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Document Number: ${item.documentNumber}',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'User ID: ${item.userId}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                  ),

                  if (item.rejectionReason != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Reason: ${item.rejectionReason}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontSize: 11),
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Document Attachments Preview Placeholders
                  Row(
                    children: [
                      Expanded(
                        child: _buildDocPreviewCard(
                          label: 'Front',
                          icon: Icons.credit_card_rounded,
                          path: item.frontPath,
                        ),
                      ),
                      if (item.backPath != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDocPreviewCard(
                            label: 'Back',
                            icon: Icons.flip_to_back_rounded,
                            path: item.backPath!,
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDocPreviewCard(
                          label: 'Selfie',
                          icon: Icons.face_rounded,
                          path: item.selfiePath,
                        ),
                      ),
                    ],
                  ),

                  if (isPending) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Icon(Icons.close_rounded, size: 16),
                            label: const Text('Reject'),
                            onPressed: () => _handleReject(item),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: const Text('Approve'),
                            onPressed: () => _handleApprove(item),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDocPreviewCard({
    required String label,
    required IconData icon,
    required String path,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
          ),
          Text(
            path.split('/').last,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

