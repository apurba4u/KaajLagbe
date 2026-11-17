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
import '../../../customer/presentation/screens/worker_search_screen.dart';
import '../../../preview/domain/preview_data.dart';

/// Labour Home Dashboard screen faithfully following Stitch design `91283845cfe5472fb7e476191ce91387`.
class LabourHomeScreen extends ConsumerStatefulWidget {
  final UserProfile? profile;

  const LabourHomeScreen({
    super.key,
    this.profile,
  });

  @override
  ConsumerState<LabourHomeScreen> createState() => _LabourHomeScreenState();
}

class _LabourHomeScreenState extends ConsumerState<LabourHomeScreen> {
  int _currentNavIndex = 0;
  bool _isOnline = true;
  bool _isJobCardVisible = true;
  bool _isJobAccepted = false;

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

  void _handleAcceptJob() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isJobAccepted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.jobAcceptedMessage),
        backgroundColor: AppColors.secondary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleDeclineJob() {
    setState(() {
      _isJobCardVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';
    final activeUser = widget.profile ?? PreviewData.karimLabour;
    final displayName = activeUser.fullName ?? (isBangla ? 'করিম মিঞা' : 'Karim Mia');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        titleSpacing: 12,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.handyman_rounded, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppConstants.appName,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.labourPanelTitle,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted,
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
        actions: [
          const Center(child: LanguageTogglePill()),
          const SizedBox(width: 4),
          IconButton(
            tooltip: l10n.profileAndSettings,
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'K',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.secondary,
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
              // 1. Worker Welcome & Availability Card
              Container(
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
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.5),
                              child: const Icon(Icons.person, color: AppColors.primary, size: 28),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _isOnline ? AppColors.secondary : AppColors.textMuted,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
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
                                children: [
                                  Flexible(
                                    child: Text(
                                      isBangla ? 'শুভ অপরাহ্ন, $displayName' : 'Good Afternoon, $displayName',
                                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, color: AppColors.secondary, size: 16),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isBangla ? 'মাস্টার ইলেকট্রিশিয়ান Lv. 3' : 'Master Electrician Lv. 3',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Online / Offline Toggle Pill
                        ElevatedButton.icon(
                          key: const Key('labour_online_toggle_btn'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isOnline ? AppColors.secondary : AppColors.outline,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: Icon(
                            _isOnline ? Icons.sensors_rounded : Icons.sensors_off_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          label: Text(
                            _isOnline ? l10n.statusOnline : l10n.statusOffline,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() => _isOnline = !_isOnline);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Availability Status Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isOnline ? AppColors.verifiedChipBg : AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cell_tower_rounded,
                                  size: 16,
                                  color: _isOnline ? AppColors.secondary : AppColors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _isOnline ? l10n.radarActiveBanner : (isBangla ? 'অফলাইন • নতুন কাজের কল বন্ধ' : 'Offline • Not receiving jobs'),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: _isOnline ? AppColors.secondary : AppColors.textMuted,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isOnline) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isBangla ? 'রাডার চালু' : 'Radar On',
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 2. Real-time Incoming Job Alert Card (if visible)
              if (_isJobCardVisible) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _isJobAccepted
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 44),
                              const SizedBox(height: 8),
                              Text(
                                isBangla ? 'কাজটি গ্রহণ করা হয়েছে!' : 'Job Accepted!',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isBangla
                                    ? 'গ্রাহক তানভীর আহমেদকে নোটিফিকেশন পাঠানো হয়েছে।'
                                    : 'Customer Tanvir Ahmed has been notified.',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : Column(
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
                                    l10n.newJobRequestAlert,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.timer_outlined, size: 12, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        isBangla ? '০১:৪৫' : '01:45',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 18, color: AppColors.divider),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isBangla ? 'সিলিং ফ্যান ও শর্ট সার্কিট মেরামত' : 'Ceiling Fan & Short Circuit Repair',
                                        style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Icons.near_me_outlined, size: 13, color: AppColors.primary),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              isBangla ? 'ধানমণ্ডি রোড ৮/এ, ঢাকা (২.৪ কিমি)' : 'Dhanmondi Rd 8/A (2.4 km)',
                                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      NumberFormatter.formatCurrency(700, languageCode: isBangla ? 'bn' : 'en'),
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      l10n.plusTipsOption,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.secondary,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Proposed Schedule Pills
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.proposedTime,
                                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 9),
                                        ),
                                        Text(
                                          isBangla ? 'আজ বিকেল ৫:০০ - ৭:০০' : 'Today 5:00 - 7:00 PM',
                                          style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.estimatedDuration,
                                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 9),
                                        ),
                                        Text(
                                          isBangla ? 'আনুমানিক ২ ঘণ্টা' : 'Approx 2 hours',
                                          style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Action Decision Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.onSurface,
                                      side: const BorderSide(color: AppColors.outline),
                                      padding: const EdgeInsets.symmetric(vertical: 9),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.close_rounded, size: 16),
                                    label: Text(l10n.declineAction, style: AppTextStyles.labelMedium),
                                    onPressed: _handleDeclineJob,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 9),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                                    label: Text(l10n.acceptAction, style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                                    onPressed: _handleAcceptJob,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
              ],

              // 3. Quick Stats Bento Grid (3 cards)
              Row(
                children: [
                  Expanded(
                    child: _buildBentoStatCard(
                      icon: Icons.payments_outlined,
                      iconColor: AppColors.primary,
                      title: l10n.todaysEarnings,
                      value: NumberFormatter.formatCurrency(1400, languageCode: isBangla ? 'bn' : 'en'),
                      subtitle: l10n.jobsCompletedCount(isBangla ? '২' : '2'),
                      badgeText: '+14%',
                      badgeColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBentoStatCard(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: AppColors.tertiary,
                      title: l10n.pendingPayout,
                      value: NumberFormatter.formatCurrency(2150, languageCode: isBangla ? 'bn' : 'en'),
                      subtitle: l10n.payoutProcessing,
                      badgeColor: AppColors.tertiary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBentoStatCard(
                      icon: Icons.track_changes_rounded,
                      iconColor: AppColors.secondary,
                      title: l10n.weeklyTarget,
                      value: isBangla ? '৭১%' : '71%',
                      subtitle: l10n.targetGoal,
                      badgeText: '71%',
                      badgeColor: AppColors.secondary,
                      progressValue: 0.71,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 4. Upcoming Work Schedule
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l10n.upcomingSchedule,
                            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _showPreviewOnlySnackBar(context),
                    child: Text(
                      l10n.viewAll,
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isBangla ? 'কাল' : 'TMRW',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                            ),
                            Text(
                              isBangla ? '১০:০০' : '10:00',
                              style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.verifiedChipBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isBangla ? 'নিশ্চিত' : 'Confirmed',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.secondary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                isBangla ? 'ডিবি সুইচবোর্ড সার্ভিসিং' : 'DB Switchboard Servicing',
                                style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isBangla ? 'মিরপুর ১০, ব্লক-সি (৪.১ কিমি)' : 'Mirpur 10, Block-C (4.1 km)',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          NumberFormatter.formatCurrency(1200, languageCode: isBangla ? 'bn' : 'en'),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          l10n.cashPayment,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 5. Reputation & Skill Badges Widget
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l10n.reputationBadgesTitle,
                                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.verifiedChipBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.masterTier,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricBlock(
                            icon: Icons.bolt_rounded,
                            iconColor: AppColors.primary,
                            value: isBangla ? '৯৮/১০০' : '98/100',
                            label: l10n.wiringSafetyScore,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricBlock(
                            icon: Icons.star_rounded,
                            iconColor: AppColors.tertiary,
                            value: isBangla ? '৪.৯ ★' : '4.9 ★',
                            label: isBangla ? '১৪২টি কাজ' : '142 jobs',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricBlock(
                            icon: Icons.alarm_on_rounded,
                            iconColor: AppColors.secondary,
                            value: isBangla ? '৯৯%' : '99%',
                            label: l10n.onTimePerformance,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 6. Discover Nearby Work Floating CTA Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.radar_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.findWorkBannerTitle,
                                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.findWorkBannerSub,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WorkerSearchScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(l10n.exploreAction, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, size: 14),
                        ],
                      ),
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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WorkerSearchScreen()),
            );
          } else if (index == 4) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ProfileSettingsScreen(profile: activeUser)),
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

  Widget _buildBentoStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    String? badgeText,
    Color? badgeColor,
    double? progressValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: iconColor),
              if (badgeText != null)
                Text(
                  badgeText,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: badgeColor ?? AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (progressValue != null) ...[
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 4,
                backgroundColor: AppColors.background,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              ),
            ),
          ],
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 8),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBlock({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 9),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
