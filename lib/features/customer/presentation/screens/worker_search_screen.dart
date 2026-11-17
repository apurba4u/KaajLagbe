import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../labour/presentation/screens/labour_profile_view_screen.dart';
import '../../../preview/domain/preview_data.dart';

/// Worker Search & Filter Screen faithfully following Stitch design `35ba7c8cf386414caf2f94ca099c8579`.
class WorkerSearchScreen extends StatefulWidget {
  final String? initialCategory;

  const WorkerSearchScreen({
    super.key,
    this.initialCategory,
  });

  @override
  State<WorkerSearchScreen> createState() => _WorkerSearchScreenState();
}

class _WorkerSearchScreenState extends State<WorkerSearchScreen> {
  late final TextEditingController _searchController;
  bool _filterVerifiedOnly = true;
  bool _filterRatingHigh = true;
  bool _filterAvailableToday = false;
  bool _filterMaxRate = false;
  bool _filterUrgent = false;

  double _maxBudgetHourly = 400;
  bool _filterNidChecked = true;
  bool _filterLicenseChecked = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.initialCategory != null
          ? widget.initialCategory!
          : '',
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _resetFilters() {
    setState(() {
      _filterVerifiedOnly = false;
      _filterRatingHigh = false;
      _filterAvailableToday = false;
      _filterMaxRate = false;
      _filterUrgent = false;
      _searchController.clear();
    });
  }

  void _openFilterBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outline,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.filterModalTitle,
                              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.maxHourlyRate,
                          style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${NumberFormatter.formatCurrency(_maxBudgetHourly, languageCode: isBangla ? 'bn' : 'en')}${l10n.perHour}',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _maxBudgetHourly,
                      min: 150,
                      max: 1000,
                      divisions: 17,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.background,
                      onChanged: (val) {
                        setModalState(() => _maxBudgetHourly = val);
                        setState(() => _maxBudgetHourly = val);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('৳১৫০', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                        Text('৳৫০০', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                        Text('৳১০০০+', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.trustLevelsTitle,
                      style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.secondary,
                      value: _filterNidChecked,
                      title: Text(l10n.safetyNidVerified, style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.bold)),
                      subtitle: Text(l10n.safetyNidVerifiedSub, style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
                      onChanged: (val) {
                        setModalState(() => _filterNidChecked = val ?? false);
                        setState(() => _filterNidChecked = val ?? false);
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.secondary,
                      value: _filterLicenseChecked,
                      title: Text(l10n.tradeLicenseCertified, style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.bold)),
                      subtitle: Text(l10n.tradeLicenseCertifiedSub, style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
                      onChanged: (val) {
                        setModalState(() => _filterLicenseChecked = val ?? false);
                        setState(() => _filterLicenseChecked = val ?? false);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.onSurface,
                              side: const BorderSide(color: AppColors.outline),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              _resetFilters();
                              Navigator.of(ctx).pop();
                            },
                            child: Text(l10n.resetAllAction),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text(l10n.applyFiltersAction, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outline),
                ),
                child: TextField(
                  controller: _searchController,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 16),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    hintText: l10n.searchServiceHint,
                    hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Center(child: LanguageTogglePill()),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Locality Radius Pill
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outline),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.my_location_rounded, size: 14, color: AppColors.secondary),
                            const SizedBox(width: 4),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 190),
                              child: Text(
                                l10n.radiusPillText,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.onSurface,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        icon: const Icon(Icons.tune_rounded, size: 14, color: AppColors.primary),
                        label: Text(
                          l10n.changeAreaAction,
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _openFilterBottomSheet(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 2. Horizontal Scrollable Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: l10n.filterVerifiedOnly,
                          isSelected: _filterVerifiedOnly,
                          selectedColor: AppColors.secondary,
                          icon: Icons.verified_rounded,
                          onTap: () => setState(() => _filterVerifiedOnly = !_filterVerifiedOnly),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: l10n.filterRatingHigh,
                          isSelected: _filterRatingHigh,
                          selectedColor: AppColors.primary,
                          icon: Icons.star_rounded,
                          onTap: () => setState(() => _filterRatingHigh = !_filterRatingHigh),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: l10n.filterAvailableToday,
                          isSelected: _filterAvailableToday,
                          selectedColor: AppColors.secondary,
                          icon: Icons.bolt_rounded,
                          onTap: () => setState(() => _filterAvailableToday = !_filterAvailableToday),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: l10n.filterMaxRate,
                          isSelected: _filterMaxRate,
                          selectedColor: AppColors.tertiary,
                          onTap: () => setState(() => _filterMaxRate = !_filterMaxRate),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: l10n.filterUrgent,
                          isSelected: _filterUrgent,
                          selectedColor: AppColors.tertiary,
                          icon: Icons.flash_on_rounded,
                          onTap: () => setState(() => _filterUrgent = !_filterUrgent),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3. Results Header & Count
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text(
                              l10n.verifiedWorkersFound(isBangla ? '৩৮' : '38'),
                              style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.verifiedChipBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              l10n.onlineBadge,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.secondary,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => _showPreviewOnlySnackBar(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Text(
                            l10n.sortPopular,
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 4. Worker Cards Feed
                  // Worker 1: Karim Mia
                  _buildWorkerDetailCard(
                    name: 'Karim Mia (করিম মিঞা)',
                    rating: isBangla ? '৪.৯' : '4.9',
                    reviewCount: isBangla ? '(১১২)' : '(112)',
                    craftTitle: isBangla ? 'Master Electrician Lv. ৩' : 'Master Electrician Lv. 3',
                    successRate: l10n.successRate(isBangla ? '৯৮' : '98'),
                    skills: [
                      isBangla ? 'শর্ট সার্কিট নির্ণয়' : 'Short Circuit Diagnostic',
                      isBangla ? 'ফ্যান ও লাইট ফিটিং' : 'Fan & Light Fitting',
                      isBangla ? 'DB Board মেরামত' : 'DB Board Repair',
                    ],
                    location: isBangla ? 'Mirpur 10, Pallabi (২.৪ কিমি)' : 'Mirpur 10, Pallabi (2.4 km)',
                    timeSlot: isBangla ? 'আজ দুপুর ২:০০' : 'Today 2:00 PM',
                    wage: NumberFormatter.formatCurrency(350, languageCode: isBangla ? 'bn' : 'en'),
                    fixedWageNote: isBangla ? '৳৮০০ ফিক্সড রেট অপশন' : '৳800 Fixed Option',
                    onProfileTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LabourProfileViewScreen(workerId: PreviewData.labour1Id),
                        ),
                      );
                    },
                    onBookTap: () => _showPreviewOnlySnackBar(context),
                  ),

                  const SizedBox(height: 12),

                  // Worker 2: Jamal Hossain
                  _buildWorkerDetailCard(
                    name: 'Jamal Hossain (জামাল)',
                    rating: isBangla ? '৪.৮' : '4.8',
                    reviewCount: isBangla ? '(৮৬)' : '(86)',
                    craftTitle: isBangla ? 'Home Cleaning Expert' : 'Home Cleaning Expert',
                    successRate: l10n.successRate(isBangla ? '৯৫' : '95'),
                    skills: [
                      isBangla ? 'ডিপ হোম ক্লিনিং' : 'Deep Home Cleaning',
                      isBangla ? 'বাগান পরিচর্যা' : 'Garden Maintenance',
                      isBangla ? 'পানি পাম্প চেক' : 'Water Pump Check',
                    ],
                    location: isBangla ? 'Dhanmondi, Banani (৩.৮ কিমি)' : 'Dhanmondi, Banani (3.8 km)',
                    timeSlot: isBangla ? 'আজ বিকেল ৩:৩০' : 'Today 3:30 PM',
                    wage: NumberFormatter.formatCurrency(400, languageCode: isBangla ? 'bn' : 'en'),
                    fixedWageNote: isBangla ? 'কোন অতিরিক্ত হিডেন চার্জ নেই' : 'No Hidden Charges',
                    onProfileTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LabourProfileViewScreen(workerId: PreviewData.labour2Id),
                        ),
                      );
                    },
                    onBookTap: () => _showPreviewOnlySnackBar(context),
                  ),

                  const SizedBox(height: 12),

                  // Worker 3: Nasir Ahmed / Student Worker
                  _buildWorkerDetailCard(
                    name: 'Nasir Ahmed (নাসির)',
                    rating: isBangla ? '৪.৭' : '4.7',
                    reviewCount: isBangla ? '(৪২)' : '(42)',
                    craftTitle: isBangla ? 'Moving & Lifting Helper' : 'Moving & Lifting Helper',
                    successRate: l10n.successRate(isBangla ? '৯৩' : '93'),
                    skills: [
                      isBangla ? 'আসবাবপত্র স্থানান্তর' : 'Furniture Moving',
                      isBangla ? 'প্যাকিং ও লোডিং' : 'Packing & Loading',
                    ],
                    location: isBangla ? 'Mirpur 10, Kazipara (১.১ কিমি)' : 'Mirpur 10, Kazipara (1.1 km)',
                    timeSlot: isBangla ? 'আজ বিকেল ৪:০০' : 'Today 4:00 PM',
                    wage: NumberFormatter.formatCurrency(250, languageCode: isBangla ? 'bn' : 'en'),
                    fixedWageNote: isBangla ? 'সুলভ ছাত্র সহযোগী' : 'Student Helper',
                    onProfileTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LabourProfileViewScreen(workerId: PreviewData.labour3Id),
                        ),
                      );
                    },
                    onBookTap: () => _showPreviewOnlySnackBar(context),
                  ),

                  const SizedBox(height: 16),

                  // 5. Reset Filter Helper Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.filter_alt_off_rounded, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isBangla ? 'কাঙ্ক্ষিত কর্মী খুঁজে পাননি?' : "Didn't find desired worker?",
                                style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                l10n.noWorkersFoundSub,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _resetFilters,
                          child: Text(l10n.resetFilters, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 70), // Padding for floating filter drawer trigger
                ],
              ),
            ),

            // Floating Bottom Filter Drawer Trigger
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onSurface,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 18, color: AppColors.primaryContainer),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isBangla ? 'সব ফিল্টার ও রেঞ্জ' : 'All Filters & Ranges',
                          style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isBangla ? '২ সক্রিয়' : '2 Active',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () => _openFilterBottomSheet(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Color selectedColor,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? selectedColor : AppColors.outline),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? Colors.white : AppColors.textMuted),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? Colors.white : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerDetailCard({
    required String name,
    required String rating,
    required String reviewCount,
    required String craftTitle,
    required String successRate,
    required List<String> skills,
    required String location,
    required String timeSlot,
    required String wage,
    required String fixedWageNote,
    required VoidCallback onProfileTap,
    required VoidCallback onBookTap,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.background,
                    child: const Icon(Icons.person, color: AppColors.secondary, size: 30),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.ratingChipBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, size: 12, color: AppColors.ratingChipText),
                              const SizedBox(width: 2),
                              Text(
                                rating,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.ratingChipText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                reviewCount,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.verifiedChipBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, size: 10, color: AppColors.secondary),
                              const SizedBox(width: 3),
                              Text(
                                'NID Verified ✓',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            craftTitle,
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurface, fontSize: 9),
                          ),
                        ),
                        Text(
                          successRate,
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.secondary, fontSize: 9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Skills chips
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: skills.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  s,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface, fontSize: 10),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          // Location & Timeslot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.near_me_rounded, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule_rounded, size: 14, color: AppColors.tertiary),
                  const SizedBox(width: 4),
                  Text(
                    timeSlot,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.tertiary, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 18, color: AppColors.divider),
          // Wage & CTAs
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        wage,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.perHour,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                      ),
                    ],
                  ),
                  Text(
                    fixedWageNote,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.secondary, fontSize: 9),
                  ),
                ],
              ),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.onSurface,
                      side: const BorderSide(color: AppColors.outline),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: onProfileTap,
                    child: Text(isBangla ? 'প্রোফাইল' : 'Profile', style: const TextStyle(fontSize: 11)),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.event_available_rounded, size: 14),
                    label: Text(l10n.bookNowAction, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: onBookTap,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
