import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/user_profile.dart';
import '../../../auth/presentation/screens/profile_settings_screen.dart';
import '../../../labour/presentation/screens/labour_profile_view_screen.dart';
import '../../../preview/domain/preview_data.dart';
import 'worker_search_screen.dart';

/// Customer Home Marketplace screen faithfully following Stitch design `ad6310cdd4fd43349c132fa59cb87832`.
class CustomerHomeScreen extends ConsumerStatefulWidget {
  final UserProfile? profile;

  const CustomerHomeScreen({
    super.key,
    this.profile,
  });

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  int _currentNavIndex = 0;

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

  void _navigateToSearch({String? category}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkerSearchScreen(initialCategory: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';
    final activeUser = widget.profile ?? PreviewData.rahimCustomer;
    final displayName = activeUser.fullName ?? (isBangla ? 'গ্রাহক' : 'Customer');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        titleSpacing: 12,
        title: Text(
          AppConstants.appName,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const Center(child: LanguageTogglePill()),
          const SizedBox(width: 4),
          IconButton(
            tooltip: l10n.profileAndSettings,
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProfileSettingsScreen(profile: activeUser),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Greeting & Active Search Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isBangla ? 'ঢাকা • মিরপুর ১০' : 'DHAKA • MIRPUR 10',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.goodMorningUser(displayName.split(' ').first),
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _showPreviewOnlySnackBar(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.notifications_none_rounded, color: AppColors.primary, size: 22),
                          Positioned(
                            top: 8,
                            right: 9,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Interactive Search Bar
              InkWell(
                onTap: () => _navigateToSearch(),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.customerSearchHint,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () => _showPreviewOnlySnackBar(context),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.mic_rounded, color: AppColors.primary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 2. 100% NID Trust Assurance Strip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.verifiedChipBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  l10n.nidAssuranceTitle,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Secure',
                                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Text(
                            l10n.nidAssuranceSubtitle,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.secondaryDark.withValues(alpha: 0.8),
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Live Active Booking Card (En Route Tracker)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l10n.workerEnRoute,
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              l10n.withinMinutes(isBangla ? '১৪' : '14'),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 9.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 18, color: AppColors.divider),
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.background,
                              child: const Icon(Icons.person_rounded, size: 28, color: AppColors.secondary),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, size: 10, color: Colors.white),
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
                                children: [
                                  Flexible(
                                    child: Text(
                                      'রফিকুল ইসলাম (Rafiqul)',
                                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: AppColors.ratingChipBg,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isBangla ? '★ ৪.৯' : '★ 4.9',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.ratingChipText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.electricWiringFix,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                l10n.workerBranchMirpur,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.onSurface,
                              side: const BorderSide(color: AppColors.outline),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.explore_outlined, size: 16, color: AppColors.secondary),
                            label: Text(l10n.liveTracking, style: AppTextStyles.labelMedium),
                            onPressed: () => _showPreviewOnlySnackBar(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.call_rounded, size: 16),
                            label: Text(l10n.callAction, style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                            onPressed: () => _showPreviewOnlySnackBar(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. Service Categories (2x4 Grid)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.emergencyDailyServices,
                          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          l10n.callWorkerInMinutes,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _navigateToSearch(),
                    child: Text(
                      l10n.viewAll,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 8,
                childAspectRatio: 0.72,
                children: [
                  _buildCategoryCard(
                    title: l10n.skillElectrician,
                    icon: Icons.bolt_rounded,
                    color: AppColors.primary,
                    onTap: () => _navigateToSearch(category: 'Electrician'),
                  ),
                  _buildCategoryCard(
                    title: l10n.skillPlumber,
                    icon: Icons.plumbing_rounded,
                    color: AppColors.secondary,
                    onTap: () => _navigateToSearch(category: 'Plumber'),
                  ),
                  _buildCategoryCard(
                    title: l10n.skillCleaner,
                    icon: Icons.cleaning_services_rounded,
                    color: AppColors.secondary,
                    onTap: () => _navigateToSearch(category: 'Cleaner'),
                  ),
                  _buildCategoryCard(
                    title: l10n.skillAppliance,
                    icon: Icons.ac_unit_rounded,
                    color: AppColors.tertiary,
                    onTap: () => _navigateToSearch(category: 'Appliance Repair'),
                  ),
                  _buildCategoryCard(
                    title: l10n.skillMoving,
                    icon: Icons.local_shipping_rounded,
                    color: AppColors.onSurface,
                    onTap: () => _navigateToSearch(category: 'Moving Helper'),
                  ),
                  _buildCategoryCard(
                    title: l10n.skillPainter,
                    icon: Icons.format_paint_rounded,
                    color: AppColors.primary,
                    onTap: () => _navigateToSearch(category: 'Painter'),
                  ),
                  _buildCategoryCard(
                    title: l10n.skillCarpenter,
                    icon: Icons.carpenter_rounded,
                    color: AppColors.tertiary,
                    onTap: () => _navigateToSearch(category: 'Carpenter'),
                  ),
                  _buildCategoryCard(
                    title: l10n.skillGeneralHelper,
                    icon: Icons.handyman_rounded,
                    color: AppColors.secondary,
                    onTap: () => _navigateToSearch(category: 'General Helper'),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 5. Promotional Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.promoOfferBadge,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.promoBannerTitle,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.promoBannerCode('KAAJNEW'),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.local_offer_rounded, size: 40, color: Colors.white24),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 6. Popular Workers Horizontal Carousel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              l10n.topRatedWorkers,
                              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.verifiedChipBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                l10n.locationMirpur.split(',').first,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          l10n.topRatedWorkersSub,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _navigateToSearch(),
                    child: Text(
                      l10n.viewAll,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildWorkerCard(
                      name: 'Karim Mia (করিম মিঞা)',
                      specialty: l10n.skillElectrician,
                      rating: isBangla ? '★ ৪.৯' : '★ 4.9',
                      jobCount: isBangla ? '(১২৮ কাজ)' : '(128 jobs)',
                      availability: l10n.availableIn30Mins,
                      wage: NumberFormatter.formatCurrency(350, languageCode: isBangla ? 'bn' : 'en'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LabourProfileViewScreen(workerId: PreviewData.labour1Id),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildWorkerCard(
                      name: 'Jamal Hossain (জামাল)',
                      specialty: l10n.skillCleaner,
                      rating: isBangla ? '★ ৪.৮' : '★ 4.8',
                      jobCount: isBangla ? '(৯৪ কাজ)' : '(94 jobs)',
                      availability: l10n.availableToday,
                      wage: NumberFormatter.formatCurrency(400, languageCode: isBangla ? 'bn' : 'en'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LabourProfileViewScreen(workerId: PreviewData.labour2Id),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildWorkerCard(
                      name: 'Mobarak Hossain (মোবারক)',
                      specialty: l10n.skillAppliance,
                      rating: isBangla ? '★ ৪.৮' : '★ 4.8',
                      jobCount: isBangla ? '(২১০ কাজ)' : '(210 jobs)',
                      availability: l10n.availableToday,
                      wage: NumberFormatter.formatCurrency(500, languageCode: isBangla ? 'bn' : 'en'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LabourProfileViewScreen(workerId: PreviewData.labour1Id),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 7. KaajLagbe Safety Guarantee
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.secondary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.kaajLagbeSafetyTitle,
                            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSafetyItem(
                            icon: Icons.verified_user_rounded,
                            title: l10n.safetyNidVerified,
                            subtitle: l10n.safetyNidVerifiedSub,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildSafetyItem(
                            icon: Icons.payments_rounded,
                            title: l10n.safetyTransparentRates,
                            subtitle: l10n.safetyTransparentRatesSub,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSafetyItem(
                            icon: Icons.support_agent_rounded,
                            title: l10n.safetyDisputeResolution,
                            subtitle: l10n.safetyDisputeResolutionSub,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildSafetyItem(
                            icon: Icons.published_with_changes_rounded,
                            title: l10n.safetyEasyRebooking,
                            subtitle: l10n.safetyEasyRebookingSub,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 1) {
            _navigateToSearch();
          } else if (index == 4) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProfileSettingsScreen(profile: activeUser),
              ),
            );
          } else if (index != 0) {
            _showPreviewOnlySnackBar(context);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_rounded),
            label: l10n.navSearch,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_rounded),
            label: l10n.navBookings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: l10n.navMessages,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerCard({
    required String name,
    required String specialty,
    required String rating,
    required String jobCount,
    required String availability,
    required String wage,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 250,
      padding: const EdgeInsets.all(12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.background,
                    child: const Icon(Icons.person, color: AppColors.primary, size: 26),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1.5),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified, size: 10, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      specialty,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          rating,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.ratingChipText,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            jobCount,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          availability,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$wage${l10n.perHour}',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: onTap,
              child: Text(
                l10n.viewProfileAndBook,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.secondary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
