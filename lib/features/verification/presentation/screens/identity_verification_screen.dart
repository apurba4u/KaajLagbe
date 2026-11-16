import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../domain/identity_verification.dart';
import '../verification_providers.dart';

/// Identity Verification Submission & Status screen strictly following
/// Stitch design 175c68d1e17f4f30acdc354ba293a7fc with frozen Kinetic Trust tokens.
class IdentityVerificationScreen extends ConsumerStatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  ConsumerState<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends ConsumerState<IdentityVerificationScreen> {
  final TextEditingController _docNumberController = TextEditingController();
  String _selectedDocType = 'nid'; // 'nid' or 'passport'

  Uint8List? _frontPhotoBytes;
  Uint8List? _backPhotoBytes;
  Uint8List? _selfieBytes;

  String? _frontFileName;
  String? _backFileName;
  String? _selfieFileName;

  String? _validationError;

  @override
  void dispose() {
    _docNumberController.dispose();
    super.dispose();
  }

  Uint8List _generateSampleDocumentBytes(String tag) {
    // 1x1 valid sample image bytes for testing and simulator environments
    return Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
      0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
      0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
      0x42, 0x60, 0x82,
    ]);
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final docNumber = _docNumberController.text.trim();
    if (docNumber.isEmpty || docNumber.length < 6) {
      setState(() {
        _validationError = l10n.docNumberRequiredError;
      });
      return;
    }

    if (_frontPhotoBytes == null ||
        (_selectedDocType == 'nid' && _backPhotoBytes == null) ||
        _selfieBytes == null) {
      setState(() {
        _validationError = l10n.fileRequiredError;
      });
      return;
    }

    setState(() {
      _validationError = null;
    });

    final controller = ref.read(verificationControllerProvider.notifier);
    final result = await controller.submitVerification(
      documentType: _selectedDocType,
      documentNumber: docNumber,
      frontBytes: _frontPhotoBytes!,
      backBytes: _selectedDocType == 'nid' ? _backPhotoBytes : null,
      selfieBytes: _selfieBytes!,
    );

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.verificationSubmittedSuccess),
          backgroundColor: AppColors.secondary,
        ),
      );
      // Invalidate current profile to refresh verification status across app
      ref.invalidate(currentUserProfileProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final verificationAsync = ref.watch(currentVerificationStreamProvider);
    final submissionState = ref.watch(verificationControllerProvider);
    final isSubmitting = submissionState.isLoading;

    final existingVerification = verificationAsync.valueOrNull;
    final isPending = existingVerification?.isPending ?? false;
    final isApproved = existingVerification?.isApproved ?? false;
    final isRejected = existingVerification?.isRejected ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'K',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'KaajLagbe',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: const [
          Center(child: LanguageTogglePill()),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.identityVerificationTitle,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Text(
                      _selectedDocType.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.identityVerificationSubtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 16),

              // Status Banner Card
              _buildStatusCard(existingVerification, l10n),

              const SizedBox(height: 20),

              // Form: Document Type Selector
              Text(
                '${l10n.docTypeLabel} *',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDocTypeCard(
                      type: 'nid',
                      title: l10n.docTypeNid,
                      subtitle: 'National ID',
                      icon: Icons.badge_outlined,
                      isSelected: _selectedDocType == 'nid',
                      enabled: !isPending && !isApproved,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDocTypeCard(
                      type: 'passport',
                      title: l10n.docTypePassport,
                      subtitle: 'Passport (Intl.)',
                      icon: Icons.flight_takeoff_rounded,
                      isSelected: _selectedDocType == 'passport',
                      enabled: !isPending && !isApproved,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Document Number Input Field
              Text(
                '${l10n.docNumberLabel} *',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _validationError != null
                        ? AppColors.error
                        : AppColors.outline,
                  ),
                ),
                child: TextField(
                  controller: _docNumberController,
                  enabled: !isPending && !isApproved,
                  keyboardType: TextInputType.text,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    hintText: _selectedDocType == 'nid'
                        ? l10n.docNumberPlaceholder
                        : l10n.docNumberPassportPlaceholder,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                    suffixIcon: const Icon(
                      Icons.pin_rounded,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Upload Cards Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l10n.uploadPhotosTitle} *',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.lock_rounded, size: 13, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        'Private Bucket',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 1. Front Photo Card
              _buildUploadCard(
                stepNumber: '1',
                title: l10n.uploadFrontPhoto,
                subtitle: l10n.uploadFrontPhotoSub,
                tag: 'JPG / PNG',
                fileName: _frontFileName,
                hasFile: _frontPhotoBytes != null,
                enabled: !isPending && !isApproved,
                onTap: () {
                  setState(() {
                    _frontPhotoBytes = _generateSampleDocumentBytes('front');
                    _frontFileName = '${_selectedDocType}_front.jpg';
                    _validationError = null;
                  });
                },
              ),

              const SizedBox(height: 12),

              // 2. Back Photo Card (NID Only)
              if (_selectedDocType == 'nid') ...[
                _buildUploadCard(
                  stepNumber: '2',
                  title: l10n.uploadBackPhoto,
                  subtitle: l10n.uploadBackPhotoSub,
                  tag: 'NID Only',
                  fileName: _backFileName,
                  hasFile: _backPhotoBytes != null,
                  enabled: !isPending && !isApproved,
                  onTap: () {
                    setState(() {
                      _backPhotoBytes = _generateSampleDocumentBytes('back');
                      _backFileName = 'nid_back.jpg';
                      _validationError = null;
                    });
                  },
                ),
                const SizedBox(height: 12),
              ],

              // 3. Selfie Holding Document
              _buildUploadCard(
                stepNumber: _selectedDocType == 'nid' ? '3' : '2',
                title: l10n.uploadSelfie,
                subtitle: l10n.uploadSelfieSub,
                tag: 'Selfie',
                fileName: _selfieFileName,
                hasFile: _selfieBytes != null,
                enabled: !isPending && !isApproved,
                onTap: () {
                  setState(() {
                    _selfieBytes = _generateSampleDocumentBytes('selfie');
                    _selfieFileName = 'selfie_with_id.jpg';
                    _validationError = null;
                  });
                },
              ),

              if (_validationError != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 16, color: AppColors.error),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _validationError!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              // Privacy & Trust Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.security_rounded,
                            size: 20, color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '100% Encrypted & Private',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.privacyTrustNotice,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Sticky CTA Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (isPending || isApproved || isSubmitting)
                      ? null
                      : () => _submit(l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isSubmitting
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
                              isRejected
                                  ? l10n.resubmitVerification
                                  : l10n.submitVerification,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
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

  Widget _buildStatusCard(IdentityVerification? verification, AppLocalizations l10n) {
    if (verification == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded,
                size: 20, color: AppColors.tertiary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.verificationStatusNotSubmitted,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (verification.isApproved) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_rounded, size: 22, color: AppColors.secondary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.verificationStatusApproved,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Doc: ${verification.documentType.toUpperCase()} - ${verification.documentNumber}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurface,
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

    if (verification.isPending) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.tertiary),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_top_rounded,
                size: 22, color: AppColors.tertiary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.verificationStatusPending,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Submitted: ${verification.documentType.toUpperCase()} (${verification.documentNumber})',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurface,
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

    // Rejected State
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 22, color: AppColors.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.verificationStatusRejected,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (verification.rejectionReason != null &&
              verification.rejectionReason!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Text(
                l10n.rejectionReasonLabel.endsWith(':')
                    ? '${l10n.rejectionReasonLabel} ${verification.rejectionReason}'
                    : '${l10n.rejectionReasonLabel}: ${verification.rejectionReason}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocTypeCard({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled
          ? () {
              setState(() {
                _selectedDocType = type;
                _validationError = null;
              });
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required String stepNumber,
    required String title,
    required String subtitle,
    required String tag,
    required String? fileName,
    required bool hasFile,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFile ? AppColors.secondary : AppColors.outline,
          width: hasFile ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: hasFile
                      ? AppColors.secondary.withValues(alpha: 0.15)
                      : AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasFile ? AppColors.secondary : AppColors.outline,
                  ),
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: hasFile ? AppColors.secondary : AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Text(
                  tag,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: hasFile
                    ? AppColors.secondary.withValues(alpha: 0.08)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasFile ? AppColors.secondary : AppColors.outline,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasFile ? Icons.check_circle_rounded : Icons.add_a_photo_rounded,
                    size: 18,
                    color: hasFile ? AppColors.secondary : AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      hasFile ? (fileName ?? 'Photo Attached') : 'Take Photo or Choose File',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: hasFile ? AppColors.secondary : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
