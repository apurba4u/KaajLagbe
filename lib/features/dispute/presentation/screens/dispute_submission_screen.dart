import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../l10n/app_localizations.dart';

/// Complaint & Dispute Submission screen faithfully implementing Stitch design `aff63324750c406290dbda503c15ec91`.
class DisputeSubmissionScreen extends ConsumerStatefulWidget {
  final String? bookingId;
  final String? workerName;

  const DisputeSubmissionScreen({
    super.key,
    this.bookingId,
    this.workerName,
  });

  @override
  ConsumerState<DisputeSubmissionScreen> createState() => _DisputeSubmissionScreenState();
}

class _DisputeSubmissionScreenState extends ConsumerState<DisputeSubmissionScreen> {
  String _selectedCategory = 'quality';
  final TextEditingController _descController = TextEditingController();
  bool _mockAttachmentVisible = true;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _showPreviewSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';
    final langCode = isBangla ? 'bn' : 'en';

    final bookingId = widget.bookingId ?? '#KL-849204';
    final workerName = widget.workerName ?? (isBangla ? 'রফিকুল ইসলাম' : 'Rafiqul Islam');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.disputeTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: LanguageTogglePill(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        key: const Key('dispute_submission_scroll_view'),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Booking Details Context Header Card
            _buildDisputeHeaderCard(isBangla, bookingId, workerName),
            const SizedBox(height: 16),

            // Step 1: Issue Category Selection
            _buildCategorySection(isBangla),
            const SizedBox(height: 16),

            // Step 2: Detailed Description
            _buildDescriptionSection(l10n, isBangla, langCode),
            const SizedBox(height: 16),

            // Step 3: Evidence Attachments
            _buildEvidenceSection(l10n, isBangla),
            const SizedBox(height: 16),

            // Policy Notice Banner
            _buildPolicyBanner(isBangla),
            const SizedBox(height: 20),

            // Submit and Back Actions
            _buildActionButtons(l10n, isBangla),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDisputeHeaderCard(bool isBangla, String bookingId, String workerName) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        isBangla ? 'বিরোধ নিষ্পত্তি আবেদন' : 'Dispute Resolution Request',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${isBangla ? 'বুকিং আইডি' : 'Booking'} $bookingId',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${isBangla ? 'কর্মী:' : 'Worker:'} $workerName (${isBangla ? 'ইলেকট্রিশিয়ান' : 'Electrician'})',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  isBangla ? 'তারিখ: ২৭ অক্টোবর, ২০২৪ • দুপুর ৩:৩০' : 'Date: Oct 27, 2024 • 3:30 PM',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline),
            ),
            child: const Icon(Icons.gavel_rounded, color: AppColors.primary, size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(bool isBangla) {
    final categories = [
      _CategoryOption(
        id: 'quality',
        titleBn: 'কাজের মান খারাপ বা অসমাপ্ত',
        titleEn: 'Poor Quality / Incomplete',
        subtitleBn: 'কাজের মান সন্তোষজনক নয়',
        subtitleEn: 'Unsatisfactory work result',
        icon: Icons.build_circle_rounded,
      ),
      _CategoryOption(
        id: 'skill',
        titleBn: 'দক্ষতার ঘাটতি ও অমিল',
        titleEn: 'Skill Mismatch',
        subtitleBn: 'প্রয়োজনীয় অভিজ্ঞতা নেই',
        subtitleEn: 'Lacks required technical skill',
        icon: Icons.psychology_alt_rounded,
      ),
      _CategoryOption(
        id: 'impersonation',
        titleBn: 'ভুল ব্যক্তি উপস্থিত হওয়া',
        titleEn: 'Wrong Person Arrived',
        subtitleBn: 'প্রোফাইলের ব্যক্তির অমিল',
        subtitleEn: 'Identity does not match profile',
        icon: Icons.no_accounts_rounded,
      ),
      _CategoryOption(
        id: 'breach',
        titleBn: 'চুক্তির শর্ত বা সময় লঙ্ঘন',
        titleEn: 'Breach of Terms',
        subtitleBn: 'সময় বা চুক্তি না মানা',
        subtitleEn: 'Violated agreed scope or time',
        icon: Icons.schedule_rounded,
      ),
      _CategoryOption(
        id: 'overcharge',
        titleBn: 'অতিরিক্ত অর্থ দাবি',
        titleEn: 'Overcharging / Price Mismatch',
        subtitleBn: 'অযৌক্তিক অতিরিক্ত মূল্য',
        subtitleEn: 'Demanded unjustified extra payment',
        icon: Icons.payments_rounded,
      ),
      _CategoryOption(
        id: 'safety',
        titleBn: 'অসদাচরণ বা ঝুঁকি',
        titleEn: 'Harassment / Unsafe Behavior',
        subtitleBn: 'খারাপ ব্যবহার বা নিরাপত্তা ঝুঁকি',
        subtitleEn: 'Hostile conduct or safety risk',
        icon: Icons.warning_amber_rounded,
        isAlert: true,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  isBangla ? '১' : '1',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      isBangla ? 'সমস্যার ধরন বেছে নিন' : 'Select Issue Category',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      isBangla ? 'বাধ্যতামূলক' : 'Required',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Category chips
          Column(
            children: categories.map((cat) {
              final isSelected = _selectedCategory == cat.id;
              final title = isBangla ? cat.titleBn : cat.titleEn;
              final subtitle = isBangla ? cat.subtitleBn : cat.subtitleEn;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  key: Key('dispute_category_${cat.id}'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat.id;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (cat.isAlert
                              ? AppColors.errorContainer.withValues(alpha: 0.3)
                              : AppColors.primaryContainer.withValues(alpha: 0.2))
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? (cat.isAlert ? AppColors.error : AppColors.primary)
                            : AppColors.outline,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          cat.icon,
                          color: cat.isAlert
                              ? AppColors.error
                              : (isSelected ? AppColors.primary : AppColors.onSurfaceVariant),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cat.isAlert && isSelected ? AppColors.error : AppColors.onSurface,
                                ),
                              ),
                              Text(
                                subtitle,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                          color: isSelected
                              ? (cat.isAlert ? AppColors.error : AppColors.primary)
                              : AppColors.textMuted,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(AppLocalizations l10n, bool isBangla, String langCode) {
    final count = _descController.text.length;
    final formattedCount = NumberFormatter.formatNumber(count, languageCode: langCode);
    final formattedMax = NumberFormatter.formatNumber(500, languageCode: langCode);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  isBangla ? '২' : '2',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      l10n.descriptionLabel,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      '$formattedCount / $formattedMax',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            key: const Key('dispute_description_input'),
            controller: _descController,
            maxLines: 4,
            maxLength: 500,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              counterText: '',
              hintText: l10n.descriptionPlaceholder,
              hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  isBangla
                      ? 'আপনার তথ্য সম্পূর্ণ সুরক্ষিত ও গোপন রাখা হবে'
                      : 'Your information is encrypted and treated with strict confidentiality.',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceSection(AppLocalizations l10n, bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  isBangla ? '৩' : '3',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      l10n.uploadEvidenceLabel,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      isBangla ? 'সর্বোচ্চ ৪টি ফাইল' : 'Max 4 files',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Attached file preview tile
          if (_mockAttachmentVisible)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.outline),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'fan_wiring_damage.jpg',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          isBangla ? '১.২ মেগাবাইট • সংযুক্ত হয়েছে ✓' : '1.2 MB • Attached ✓',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: const Key('remove_attachment_btn'),
                    icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.error),
                    onPressed: () {
                      setState(() {
                        _mockAttachmentVisible = false;
                      });
                      _showPreviewSnackBar(isBangla ? 'ফাইল সরানো হয়েছে' : 'File removed');
                    },
                  ),
                ],
              ),
            ),

          // Upload buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: const Key('attach_photo_btn'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.outline),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: () => _showPreviewSnackBar(
                  isBangla ? 'ছবি আপলোড: প্রিভিউ মোড' : 'Upload photo: Preview only',
                ),
                icon: const Icon(Icons.add_a_photo_rounded, size: 18, color: AppColors.primary),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    isBangla ? 'কাজের ছবি যোগ করুন' : 'Attach Photo',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
              OutlinedButton.icon(
                key: const Key('attach_receipt_btn'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.outline),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: () => _showPreviewSnackBar(
                  isBangla ? 'রসিদ আপলোড: প্রিভিউ মোড' : 'Upload receipt: Preview only',
                ),
                icon: const Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.secondary),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    isBangla ? 'মেমো / রসিদ' : 'Attach Memo / Receipt',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyBanner(bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.balance_rounded, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBangla ? 'তদন্ত ও ন্যায্য সমাধান নীতিমালা' : 'Mediation & Fair Resolution Policy',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isBangla
                      ? '২৪ ঘণ্টার মধ্যে বিরোধ নিষ্পত্তি কমিটি উভয় পক্ষের সাথে নিরপেক্ষভাবে কথা বলে দ্রুততম সময়ে সার্ভিস রি-ওয়ার্ক বা ওয়ালেটে রিফান্ড নিশ্চিত করবে।'
                      : 'Our dedicated dispute resolution team investigates impartially within 24 hours to secure either rework or wallet refund.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n, bool isBangla) {
    return Column(
      children: [
        ElevatedButton.icon(
          key: const Key('submit_dispute_button'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          onPressed: () => _showPreviewSnackBar(l10n.disputeSubmittedMessage),
          icon: const Icon(Icons.send_rounded, size: 18),
          label: Text(
            l10n.submitDisputeCta,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(
            isBangla ? 'ফিরে যান' : 'Go Back',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryOption {
  final String id;
  final String titleBn;
  final String titleEn;
  final String subtitleBn;
  final String subtitleEn;
  final IconData icon;
  final bool isAlert;

  _CategoryOption({
    required this.id,
    required this.titleBn,
    required this.titleEn,
    required this.subtitleBn,
    required this.subtitleEn,
    required this.icon,
    this.isAlert = false,
  });
}
