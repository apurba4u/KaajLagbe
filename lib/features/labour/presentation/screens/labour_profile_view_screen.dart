import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/user_profile.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../domain/labour_profile.dart';
import '../../domain/labour_skill.dart';
import '../labour_providers.dart';
import 'labour_profile_setup_screen.dart';

/// Worker Profile & Badges Public View screen strictly implementing Stitch design
/// 68c4db14bec047c1a42a814d7cbf8c1a with frozen Kinetic Trust tokens.
///
/// Features:
/// - Server-calculated score and badge status are strictly READ-ONLY.
/// - Current score is displayed directly beside the badge.
/// - Demonstrates seeded data for Karim Mia (worker #1).
/// - Customers can view worker details, verified badges, schedule and rate.
/// - Worker viewing own profile can tap "Edit Profile".
class LabourProfileViewScreen extends ConsumerWidget {
  final String workerId;

  const LabourProfileViewScreen({
    super.key,
    required this.workerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final isBangla = currentLocale.languageCode == 'bn';

    final currentUser = ref.watch(currentUserProfileProvider).valueOrNull;
    final workerUserAsync = ref.watch(userProfileProvider(workerId));
    final labourProfileAsync = ref.watch(labourProfileStreamProvider(workerId));
    final labourSkillsAsync = ref.watch(labourSkillsStreamProvider(workerId));

    final workerUser = workerUserAsync.valueOrNull;
    final labourProfile = labourProfileAsync.valueOrNull;
    final skills = labourSkillsAsync.valueOrNull ?? [];

    final isOwnProfile = currentUser != null && currentUser.id == workerId;
    final workerName = workerUser?.fullName ?? (isBangla ? 'করিম মিঞা' : 'Karim Mia');
    final rate = labourProfile?.expectedWage ?? 600.0;
    final formattedRate = NumberFormatter.formatCurrency(rate, languageCode: currentLocale.languageCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          key: const Key('profile_view_back_button'),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.labourProfileViewTitle,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Trust Ribbon
              _buildTrustRibbon(l10n, workerUser),

              const SizedBox(height: 12),

              // 2. Worker Hero Card
              _buildWorkerHeroCard(
                context,
                workerName: workerName,
                workerUser: workerUser,
                labourProfile: labourProfile,
                skills: skills,
                isBangla: isBangla,
                l10n: l10n,
              ),

              const SizedBox(height: 16),

              // 3. Pricing & Rates Card
              _buildPricingCard(
                rate: rate,
                formattedRate: formattedRate,
                isBangla: isBangla,
                l10n: l10n,
              ),

              const SizedBox(height: 16),

              // 4. Verified Skill Scores & Badges Card (Crucial Requirement)
              _buildSkillScoresCard(
                skills: skills,
                isBangla: isBangla,
                l10n: l10n,
              ),

              const SizedBox(height: 16),

              // 5. Work Area & Schedule Card
              _buildScheduleCard(
                labourProfile: labourProfile,
                isBangla: isBangla,
                l10n: l10n,
              ),

              const SizedBox(height: 16),

              // 6. Customer Reviews Card
              _buildReviewsCard(isBangla: isBangla, l10n: l10n),

              const SizedBox(height: 16),

              // 7. Platform Safety Guarantee Banner
              _buildSafetyGuaranteeCard(l10n: l10n),

              const SizedBox(height: 90), // Bottom bar clearance
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomStickyBar(
        context: context,
        formattedRate: formattedRate,
        isOwnProfile: isOwnProfile,
        l10n: l10n,
      ),
    );
  }

  Widget _buildTrustRibbon(AppLocalizations l10n, UserProfile? workerUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_rounded, size: 14, color: AppColors.secondary),
              const SizedBox(width: 5),
              Text(
                l10n.nidVerifiedBadge,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outline),
              ),
              child: const Icon(Icons.share_rounded, size: 16, color: AppColors.onSurface),
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outline),
              ),
              child: const Icon(Icons.flag_outlined, size: 16, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWorkerHeroCard(
    BuildContext context, {
    required String workerName,
    required UserProfile? workerUser,
    required LabourProfile? labourProfile,
    required List<LabourSkill> skills,
    required bool isBangla,
    required AppLocalizations l10n,
  }) {
    // Generate trade headline from active skills
    final activeSkillNames = skills
        .where((s) => s.badgeActive)
        .map((s) => isBangla ? (s.skillNameBn ?? s.skillName ?? '') : (s.skillName ?? ''))
        .where((n) => n.isNotEmpty)
        .toList();

    final headline = activeSkillNames.isNotEmpty
        ? (isBangla
            ? 'সার্টিফাইড ${activeSkillNames.join(' ও ')} স্পেশালিস্ট'
            : 'Certified ${activeSkillNames.join(' & ')} Specialist')
        : (isBangla ? 'দক্ষ প্রফেশনাল কর্মী' : 'Verified Skilled Professional');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with verified badge indicator
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                    backgroundImage: workerUser?.avatarUrl != null
                        ? NetworkImage(workerUser!.avatarUrl!)
                        : null,
                    child: workerUser?.avatarUrl == null
                        ? const Icon(Icons.person_rounded, size: 38, color: AppColors.primary)
                        : null,
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workerName,
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      headline,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Rating & Jobs pill
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: AppColors.tertiary),
                              const SizedBox(width: 3),
                              Text(
                                NumberFormatter.formatNumber(4.9, languageCode: isBangla ? 'bn' : 'en'),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.tertiary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isBangla ? '১৪২ টি সম্পন্ন কাজ' : '142 Jobs Completed',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Trust Credentials Bento Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildBentoTrustCell(
                    icon: Icons.policy_rounded,
                    iconColor: AppColors.secondary,
                    title: isBangla ? 'পুলিশ রেকর্ড' : 'Police Record',
                    subtitle: isBangla ? 'ক্লিয়ার' : 'Clear',
                    subtitleColor: AppColors.secondary,
                  ),
                ),
                Container(width: 1, height: 36, color: AppColors.outline),
                Expanded(
                  child: _buildBentoTrustCell(
                    icon: Icons.speed_rounded,
                    iconColor: AppColors.primary,
                    title: isBangla ? 'সময়ানুবর্তিতা' : 'Punctuality',
                    subtitle: isBangla ? '৯৯% অন-টাইম' : '99% On-time',
                    subtitleColor: AppColors.primary,
                  ),
                ),
                Container(width: 1, height: 36, color: AppColors.outline),
                Expanded(
                  child: _buildBentoTrustCell(
                    icon: Icons.military_tech_rounded,
                    iconColor: AppColors.tertiary,
                    title: isBangla ? 'সার্টিফিকেশন' : 'Certification',
                    subtitle: isBangla ? 'কাজলাগবে প্রো' : 'KaajLagbe Pro',
                    subtitleColor: AppColors.tertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoTrustCell({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color subtitleColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(height: 3),
        Text(
          title,
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          subtitle,
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: subtitleColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPricingCard({
    required double rate,
    required String formattedRate,
    required bool isBangla,
    required AppLocalizations l10n,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Row(
                children: [
                  const Icon(Icons.payments_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.ratesAndPackagesTitle,
                    style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.transparentRatesBadge,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBangla ? 'ঘণ্টাভিত্তিক সেবা' : 'Hourly Service Rate',
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isBangla ? 'নূন্যতম ১ ঘণ্টার চার্জ' : 'Minimum 1 hour booking',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedRate,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isBangla ? '/ ঘণ্টা' : '/ hour',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Crucial Task 3.3 Requirement:
  /// - Server-calculated score and badge status are strictly READ-ONLY.
  /// - Current score is displayed directly beside the badge.
  /// - Distinguishes between Active Verified Badges (score >= 200, green) and Claimed (score < 200, amber).
  Widget _buildSkillScoresCard({
    required List<LabourSkill> skills,
    required bool isBangla,
    required AppLocalizations l10n,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Row(
                children: [
                  const Icon(Icons.engineering_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.skillsAndBadgesTitle,
                    style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                isBangla ? 'সার্ভার ভেরিফায়েড' : 'Server Verified',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (skills.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                isBangla ? 'কোনো দক্ষতা তালিকাভুক্ত নেই' : 'No skills listed yet',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: skills.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final skill = skills[index];
                final skillName = isBangla
                    ? (skill.skillNameBn ?? skill.skillName ?? 'দক্ষতা')
                    : (skill.skillName ?? 'Skill');
                final score = skill.score;
                final isActive = skill.badgeActive;
                final scoreDisplayValue = score % 1 == 0 ? score.toInt() : score.toStringAsFixed(1);
                final formattedScore = NumberFormatter.formatNumber(
                  scoreDisplayValue,
                  languageCode: isBangla ? 'bn' : 'en',
                );

                // Progress ratio against 200 threshold
                final progressRatio = (score / 200.0).clamp(0.0, 1.0);

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? AppColors.secondary.withValues(alpha: 0.3) : AppColors.outline,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                skillName,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Badge pill with status
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.secondary.withValues(alpha: 0.12)
                                      : AppColors.tertiary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isActive ? Icons.verified_rounded : Icons.pending_outlined,
                                      size: 12,
                                      color: isActive ? AppColors.secondary : AppColors.tertiary,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      isActive ? l10n.activeBadge : l10n.claimedSkill,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        fontSize: 10,
                                        color: isActive ? AppColors.secondary : AppColors.tertiary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Current Score shown beside badge (Mandatory Read-Only)
                          Row(
                            children: [
                              Text(
                                formattedScore,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: isActive ? AppColors.secondary : AppColors.tertiary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' / ${NumberFormatter.formatNumber(200, languageCode: isBangla ? 'bn' : 'en')}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Score Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressRatio,
                          minHeight: 6,
                          backgroundColor: AppColors.surface,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isActive ? AppColors.secondary : AppColors.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard({
    required LabourProfile? labourProfile,
    required bool isBangla,
    required AppLocalizations l10n,
  }) {
    final area = labourProfile?.serviceArea ?? (isBangla ? 'মিরপুর, ঢাকা' : 'Mirpur, Dhaka');
    final schedule = labourProfile?.availability ?? (isBangla ? 'শনি-বৃহস্পতি ০৯:০০-১৮:০০' : 'Sat-Thu 09:00-18:00');
    final experience = labourProfile?.experience ?? (isBangla ? '৮ বছর অভিজ্ঞতা' : '8 years experience');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.location_on_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                l10n.serviceAreaSectionTitle,
                style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            icon: Icons.radar_rounded,
            iconColor: AppColors.primary,
            title: isBangla ? 'কভারেজ এলাকা' : 'Service Coverage Area',
            content: area,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.schedule_rounded,
            iconColor: AppColors.secondary,
            title: l10n.availabilitySectionTitle,
            content: schedule,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.work_history_rounded,
            iconColor: AppColors.tertiary,
            title: l10n.aboutAndExperienceTitle,
            content: experience,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsCard({
    required bool isBangla,
    required AppLocalizations l10n,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Row(
                children: [
                  const Icon(Icons.rate_review_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.reviewsTitle,
                    style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                isBangla ? '১৪২ টি রিভিউ' : '142 Reviews',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Seeded Review 1
          _buildReviewItem(
            author: isBangla ? 'সাজিদুর রহমান' : 'Sajidur Rahman',
            date: isBangla ? '২ দিন আগে' : '2 days ago',
            comment: isBangla
                ? 'খুব দ্রুত কাজ শেষ করেছেন এবং কাজের জায়গা পরিষ্কার রেখেছেন। ওয়্যারিং সমস্যার মূল কারণ নিখুঁতভাবে বের করেছেন।'
                : 'Finished the job very quickly and kept the workspace clean. Diagnosed wiring issue accurately.',
            rating: 5,
            isBangla: isBangla,
          ),
          const SizedBox(height: 10),

          // Seeded Review 2
          _buildReviewItem(
            author: isBangla ? 'ফারহানা কে.' : 'Farhana K.',
            date: isBangla ? '৫ দিন আগে' : '5 days ago',
            comment: isBangla
                ? 'সততা ও অত্যন্ত ভদ্র ব্যবহার। সময়মতো এসেছেন এবং নির্ধারিত বাজেটের বাইরে অতিরিক্ত কোনো ফি দাবি করেননি।'
                : 'Honest and very polite behavior. Arrived on time with no extra demands.',
            rating: 5,
            isBangla: isBangla,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String author,
    required String date,
    required String comment,
    required int rating,
    required bool isBangla,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                author,
                style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(
                  rating,
                  (_) => const Icon(Icons.star_rounded, size: 14, color: AppColors.tertiary),
                ),
              ),
            ],
          ),
          Text(
            date,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10),
          ),
          const SizedBox(height: 6),
          Text(
            comment,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyGuaranteeCard({required AppLocalizations l10n}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_rounded, size: 24, color: AppColors.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.safetyGuaranteeTitle,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.safetyGuaranteeDesc,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
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

  Widget _buildBottomStickyBar({
    required BuildContext context,
    required String formattedRate,
    required bool isOwnProfile,
    required AppLocalizations l10n,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rate display
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedRate,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Row(
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
                  Text(
                    l10n.readyForBooking,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),

          // CTA: Either Edit Profile (for worker) or Book Worker (for customer)
          if (isOwnProfile)
            ElevatedButton.icon(
              key: const Key('edit_profile_cta_button'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LabourProfileSetupScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: Text(l10n.editProfileButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              key: const Key('book_labour_cta_button'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.bookingComingSoon),
                    backgroundColor: AppColors.secondary,
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: Text(l10n.bookLabourButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

