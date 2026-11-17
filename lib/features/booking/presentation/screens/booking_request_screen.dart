import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../l10n/app_localizations.dart';

/// Instant Booking & Overlap Check screen faithfully following Stitch design `b8ad026972874ee1906adde386ddc417`.
class BookingRequestScreen extends ConsumerStatefulWidget {
  final String? workerName;
  final String? serviceCategory;
  final int? hourlyRate;

  const BookingRequestScreen({
    super.key,
    this.workerName,
    this.serviceCategory,
    this.hourlyRate,
  });

  @override
  ConsumerState<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends ConsumerState<BookingRequestScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeSlotIndex = 2; // 3:00 PM default
  int _selectedDurationIndex = 1; // 2 hours default
  bool _includeTeaBreak = true;
  bool _termsAccepted = true;

  void _showPreviewOnlySnackBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.previewOnlyMessage),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    final effectiveWorkerName = widget.workerName ?? (isBangla ? 'রফিকুল ইসলাম' : 'Rafiqul Islam');
    final effectiveTrade = isBangla ? 'মাস্টার ইলেকট্রিশিয়ান' : 'Master Electrician';
    final effectiveRate = widget.hourlyRate ?? 350;

    final durationHours = _selectedDurationIndex == 0 ? 1 : (_selectedDurationIndex == 1 ? 2 : (_selectedDurationIndex == 2 ? 3 : 4));
    final wageTotal = durationHours * effectiveRate;
    final platformFee = (wageTotal * 0.05).round();
    final grandTotal = wageTotal + platformFee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          l10n.instantBookingTitle,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: LanguageTogglePill(),
          ),
          SizedBox(width: 8),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryContainer,
              child: Icon(Icons.person, size: 20, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Stepper Progress
            _buildStepper(l10n),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2. Worker Profile Snapshot Card
                  _buildWorkerSnapshotCard(
                    isBangla: isBangla,
                    workerName: effectiveWorkerName,
                    trade: effectiveTrade,
                    rate: effectiveRate,
                  ),

                  const SizedBox(height: 14),

                  // 3. Selected Task & Location Summary Card
                  _buildTaskLocationCard(isBangla: isBangla, l10n: l10n),

                  const SizedBox(height: 14),

                  // 4. Date & Slot Guard Section
                  _buildDateAndSlotSection(
                    context: context,
                    isBangla: isBangla,
                    l10n: l10n,
                    durationHours: durationHours,
                  ),

                  const SizedBox(height: 14),

                  // 5. Transparent Price Breakdown
                  _buildPriceBreakdownCard(
                    context: context,
                    isBangla: isBangla,
                    l10n: l10n,
                    durationHours: durationHours,
                    hourlyRate: effectiveRate,
                    wageTotal: wageTotal,
                    platformFee: platformFee,
                    grandTotal: grandTotal,
                  ),

                  const SizedBox(height: 14),

                  // 6. Policy Highlights & Trust Guarantee Card
                  _buildPolicyTrustCard(l10n: l10n),

                  const SizedBox(height: 14),

                  // 7. Terms Acceptance Checkbox
                  _buildTermsCheckbox(l10n: l10n),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomCtaDock(
        context: context,
        l10n: l10n,
        grandTotal: grandTotal,
      ),
    );
  }

  Widget _buildStepper(AppLocalizations l10n) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Step 1: Work (Done)
          Expanded(
            child: _buildStepItem(
              icon: Icons.check,
              label: l10n.bookingStepWork,
              isCompleted: true,
              isActive: false,
            ),
          ),
          Container(
            width: 20,
            height: 2,
            color: AppColors.secondary,
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          // Step 2: Time & Break (Active)
          Expanded(
            child: _buildStepItem(
              text: '2',
              label: l10n.bookingStepTimeBreak,
              isCompleted: false,
              isActive: true,
            ),
          ),
          Container(
            width: 20,
            height: 2,
            color: AppColors.outline,
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          // Step 3: Confirmation (Pending)
          Expanded(
            child: _buildStepItem(
              text: '3',
              label: l10n.bookingStepConfirmation,
              isCompleted: false,
              isActive: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    IconData? icon,
    String? text,
    required String label,
    required bool isCompleted,
    required bool isActive,
  }) {
    final bgColor = isCompleted
        ? AppColors.secondary
        : (isActive ? AppColors.primary : AppColors.outline);
    final fgColor = isCompleted
        ? AppColors.onSecondary
        : (isActive ? AppColors.onPrimary : AppColors.textMuted);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: isActive ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2.5) : null,
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, size: 14, color: fgColor)
                : Text(
                    text ?? '',
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 9.5,
              fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
              color: isCompleted
                  ? AppColors.secondary
                  : (isActive ? AppColors.primary : AppColors.textMuted),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkerSnapshotCard({
    required bool isBangla,
    required String workerName,
    required String trade,
    required int rate,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.outline,
                child: Icon(Icons.person, size: 30, color: AppColors.onSurfaceVariant),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified, size: 14, color: AppColors.onSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      workerName,
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedChipBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isBangla ? 'NID ভেরিফায়েড' : 'NID Verified',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.verifiedChipText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isBangla ? '$trade • ১২+ বছর অভিজ্ঞতা' : '$trade • 12+ yrs experience',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 14, color: AppColors.tertiary),
                        const SizedBox(width: 2),
                        Text(
                          isBangla ? '৪.৯ (১২৮)' : '4.9 (128)',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isBangla
                          ? '৳${NumberFormatter.toBengaliDigits(rate)}/ঘণ্টা'
                          : '৳$rate/hr',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textMuted),
            onPressed: () => _showPreviewOnlySnackBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskLocationCard({
    required bool isBangla,
    required AppLocalizations l10n,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Service item
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.electrical_services, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.selectedServiceLabel.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 9.5,
                        letterSpacing: 0.8,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isBangla ? 'সিলিং ফ্যান ও সুইচ বোর্ড মেরামত' : 'Ceiling Fan & Switch Board Repair',
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      isBangla ? '২টি ফ্যান রেগুলেশন ও ১টি প্রধান সার্কিট চেক' : '2 fan regulators & 1 main circuit check',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _showPreviewOnlySnackBar(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isBangla ? 'পরিবর্তন' : 'Change',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 18, color: AppColors.divider),
          // Location item
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on, color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.serviceAddressLabel.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 9.5,
                        letterSpacing: 0.8,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'House 42, Road 7, Block C, Mirpur 10, Dhaka',
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.my_location, size: 12, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            isBangla ? 'মিরপুর এলাকা কাভারেজ জোনে অন্তর্ভুক্ত' : 'Mirpur coverage zone included',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 11,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndSlotSection({
    required BuildContext context,
    required bool isBangla,
    required AppLocalizations l10n,
    required int durationHours,
  }) {
    final dates = [
      {'label': l10n.todayLabel, 'date': isBangla ? '২৭ অক্টো' : '27 Oct', 'day': isBangla ? 'রবিবার' : 'Sun'},
      {'label': l10n.tomorrowLabel, 'date': isBangla ? '২৮ অক্টো' : '28 Oct', 'day': isBangla ? 'সোমবার' : 'Mon'},
      {'label': l10n.dayAfterLabel, 'date': isBangla ? '২৯ অক্টো' : '29 Oct', 'day': isBangla ? 'মঙ্গলবার' : 'Tue'},
    ];

    final timeSlots = [
      {'time': isBangla ? '১:০০ PM' : '1:00 PM', 'disabled': true},
      {'time': isBangla ? '২:০০ PM' : '2:00 PM', 'disabled': true},
      {'time': isBangla ? '৩:০০ PM' : '3:00 PM', 'disabled': false},
      {'time': isBangla ? '৪:০০ PM' : '4:00 PM', 'disabled': false},
    ];

    final durations = [
      isBangla ? '১ ঘণ্টা' : '1 hr',
      isBangla ? '২ ঘণ্টা' : '2 hrs',
      isBangla ? '৩ ঘণ্টা' : '3 hrs',
      isBangla ? '৪+ ঘণ্টা' : '4+ hrs',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with realtime slot badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.selectDateTimeTitle,
                        style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.realtimeSlotBadge,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Date chips grid
          Row(
            children: List.generate(dates.length, (index) {
              final item = dates[index];
              final isSelected = _selectedDateIndex == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == dates.length - 1 ? 0 : 6),
                  child: InkWell(
                    onTap: () => setState(() => _selectedDateIndex = index),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item['label']!,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.onPrimary : AppColors.textMuted,
                            ),
                          ),
                          Text(
                            item['date']!,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                            ),
                          ),
                          Text(
                            item['day']!,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 9.5,
                              color: isSelected ? AppColors.onPrimary.withValues(alpha: 0.8) : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Time Slot Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.startTimeLabel,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Flexible(
                child: Text(
                  l10n.workerAvailableFrom(isBangla ? '৩:০০ PM' : '3:00 PM'),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(timeSlots.length, (index) {
              final slot = timeSlots[index];
              final isDisabled = slot['disabled'] as bool;
              final isSelected = _selectedTimeSlotIndex == index && !isDisabled;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == timeSlots.length - 1 ? 0 : 6),
                  child: InkWell(
                    onTap: isDisabled
                        ? null
                        : () => setState(() => _selectedTimeSlotIndex = index),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDisabled
                                ? AppColors.outline.withValues(alpha: 0.3)
                                : AppColors.outline.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        slot['time'] as String,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? AppColors.onPrimary
                              : (isDisabled ? AppColors.textMuted : AppColors.onSurface),
                          decoration: isDisabled ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Duration Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.durationLabel,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Flexible(
                child: Text(
                  isBangla ? '$durationHours ঘণ্টা (৩:০০ PM – ৫:০০ PM)' : '$durationHours hrs (3:00 PM – 5:00 PM)',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(durations.length, (index) {
              final isSelected = _selectedDurationIndex == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == durations.length - 1 ? 0 : 6),
                  child: InkWell(
                    onTap: () => setState(() => _selectedDurationIndex = index),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.surface : AppColors.outline.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        durations[index],
                        style: AppTextStyles.labelMedium.copyWith(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.primary : AppColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Tea Break Toggle Card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.coffee, size: 18, color: AppColors.tertiary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.teaBreakIncluded,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        l10n.teaBreakSub,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 9.5,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _includeTeaBreak,
                  activeThumbColor: AppColors.secondary,
                  onChanged: (val) => setState(() => _includeTeaBreak = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Overlap Guard Live Validation Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified, size: 16, color: AppColors.secondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.overlapGuardTitle,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.overlapGuardDesc,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: AppColors.onSurface,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdownCard({
    required BuildContext context,
    required bool isBangla,
    required AppLocalizations l10n,
    required int durationHours,
    required int hourlyRate,
    required int wageTotal,
    required int platformFee,
    required int grandTotal,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.costBreakdownTitle,
                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l10n.transparentBilling,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildPriceRow(
            label: isBangla
                ? 'কাজের মজুরি ($durationHours ঘণ্টা × ৳$hourlyRate)'
                : 'Labour Wage ($durationHours hrs × ৳$hourlyRate)',
            value: isBangla
                ? '৳${NumberFormatter.toBengaliDigits(wageTotal)}'
                : '৳$wageTotal',
          ),
          const SizedBox(height: 6),
          _buildPriceRow(
            label: l10n.platformSafetyFee,
            value: isBangla
                ? '৳${NumberFormatter.toBengaliDigits(platformFee)}'
                : '৳$platformFee',
          ),
          const SizedBox(height: 6),
          _buildPriceRow(
            label: l10n.teaBreakFee,
            value: l10n.freeLabel,
            valueColor: AppColors.secondary,
            isBold: true,
          ),
          const Divider(height: 18, color: AppColors.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.totalPayable,
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      l10n.payableAfterInspection,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                isBangla
                    ? '৳${NumberFormatter.toBengaliDigits(grandTotal)}'
                    : '৳$grandTotal',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyTrustCard({required AppLocalizations l10n}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user, size: 18, color: AppColors.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.kaajlagbeSafetyGuarantee,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.safetyGuaranteeBullets,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox({required AppLocalizations l10n}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _termsAccepted,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _termsAccepted = val ?? false),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            l10n.bookingTermsAgreement,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCtaDock({
    required BuildContext context,
    required AppLocalizations l10n,
    required int grandTotal,
  }) {
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.confirmableBill,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                Wrap(
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      isBangla
                          ? '৳${NumberFormatter.toBengaliDigits(grandTotal)}'
                          : '৳$grandTotal',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      l10n.cashOrBkash,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton(
                key: const Key('confirm_booking_btn'),
                onPressed: () => _showPreviewOnlySnackBar(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.confirmBookingCta,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, size: 18, color: AppColors.onPrimary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
