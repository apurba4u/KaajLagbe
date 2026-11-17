import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../admin/presentation/screens/admin_overview_screen.dart';
import '../../../admin/presentation/screens/admin_verification_desk_screen.dart';
import '../../../auth/domain/user_profile.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../../auth/presentation/screens/account_status_screen.dart';
import '../../../auth/presentation/screens/otp_verification_screen.dart';
import '../../../auth/presentation/screens/phone_login_screen.dart';
import '../../../auth/presentation/screens/profile_settings_screen.dart';
import '../../../auth/presentation/screens/profile_setup_screen.dart';
import '../../../auth/presentation/screens/role_selection_screen.dart';
import '../../../auth/presentation/screens/splash_screen.dart';
import '../../../booking/presentation/screens/booking_request_screen.dart';
import '../../../chat/presentation/screens/chat_agreement_screen.dart';
import '../../../customer/presentation/screens/customer_bookings_screen.dart';
import '../../../customer/presentation/screens/customer_home_screen.dart';
import '../../../customer/presentation/screens/worker_search_screen.dart';
import '../../../dispute/presentation/screens/dispute_submission_screen.dart';
import '../../../job/presentation/screens/on_site_checkin_timer_screen.dart';
import '../../../payment/presentation/screens/secure_payment_screen.dart';
import '../../../labour/presentation/labour_providers.dart';
import '../../../labour/presentation/screens/labour_home_screen.dart';
import '../../../labour/presentation/screens/labour_profile_setup_screen.dart';
import '../../../labour/presentation/screens/labour_profile_view_screen.dart';
import '../../../verification/presentation/screens/identity_verification_screen.dart';
import '../../../verification/presentation/verification_providers.dart';
import '../../domain/preview_data.dart';
import '../preview_providers.dart';
import '../widgets/design_preview_banner.dart';
import '../widgets/design_preview_floating_hub_button.dart';

/// Design Preview Hub Screen for rapid, auth-free inspection of all app screens.
class DesignPreviewHubScreen extends ConsumerWidget {
  const DesignPreviewHubScreen({super.key});

  void _openScreen(BuildContext context, Widget screen, {List<dynamic>? overrides}) {
    final previewScreen = Stack(
      children: [
        screen,
        const Positioned(
          bottom: 24,
          right: 16,
          child: DesignPreviewFloatingHubButton(),
        ),
      ],
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          if (overrides != null && overrides.isNotEmpty) {
            return ProviderScope(
              overrides: overrides.cast(),
              child: previewScreen,
            );
          }
          return previewScreen;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    final activePersona = ref.watch(previewPersonaProvider);
    final activeRole = ref.watch(previewRoleFilterProvider);

    final fakeAuthRepo = ref.watch(fakeAuthRepositoryProvider);
    final fakeLabourRepo = ref.watch(fakeLabourRepositoryProvider);
    final fakeVerificationRepo = ref.watch(fakeVerificationRepositoryProvider);

    // Common in-memory overrides for preview navigation
    final commonOverrides = [
      currentAuthUserProvider.overrideWithValue(fakeAuthRepo.currentUser),
      currentUserProfileProvider.overrideWith((_) => Stream.value(activePersona)),
      userProfileProvider(activePersona.id).overrideWith((_) => Stream.value(activePersona)),
      userProfileProvider(PreviewData.labour1Id).overrideWith((_) => Stream.value(PreviewData.karimLabour)),
      authRepositoryProvider.overrideWithValue(fakeAuthRepo),
      labourRepositoryProvider.overrideWithValue(fakeLabourRepo),
      verificationRepositoryProvider.overrideWithValue(fakeVerificationRepo),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.dashboard_customize_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isBangla ? 'ডিজাইন প্রিভিউ হাব' : 'Design Preview Hub',
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Prominent Warning Banner
              DesignPreviewBanner(isBangla: isBangla),

              const SizedBox(height: 16),

              // 2. Active Role & Persona Switcher Card
              _buildPersonaSelectorCard(
                context: context,
                ref: ref,
                activePersona: activePersona,
                activeRole: activeRole,
                isBangla: isBangla,
              ),

              const SizedBox(height: 20),

              // 3. Section: Onboarding & Authentication
              _buildSectionTitle(
                title: isBangla ? 'অনবোর্ডিং ও অথেন্টিকেশন' : 'Onboarding & Auth',
                icon: Icons.login_rounded,
              ),
              const SizedBox(height: 8),
              _buildCardsGrid([
                _PreviewCardItem(
                  title: isBangla ? 'স্প্ল্যাশ স্ক্রিন' : 'Splash Screen',
                  subtitle: isBangla ? 'ব্র্যান্ডিং ও লোডার' : 'Branding & Initial Loader',
                  icon: Icons.flash_on_rounded,
                  iconColor: AppColors.primary,
                  onTap: () => _openScreen(
                    context,
                    const SplashScreen(statusText: 'Previewing Splash Screen...'),
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'ফোন লগইন' : 'Phone Login',
                  subtitle: isBangla ? 'নম্বর ইনপুট ও ডেভ চিপস' : 'Phone input & quick dev fill',
                  icon: Icons.phone_android_rounded,
                  iconColor: AppColors.primary,
                  onTap: () => _openScreen(
                    context,
                    const PhoneLoginScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'ওটিপি ভেরিফিকেশন' : 'OTP Verification',
                  subtitle: isBangla ? '৬ ডিজিট বক্স ও টাইমার' : '6 digit code input & timer',
                  icon: Icons.pin_rounded,
                  iconColor: AppColors.secondary,
                  onTap: () => _openScreen(
                    context,
                    OtpVerificationScreen(
                      phone: activePersona.phone ?? '+8801800000001',
                    ),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'রোল নির্বাচন' : 'Role Selection',
                  subtitle: isBangla ? 'কাস্টমার বনাম শ্রমিক' : 'Customer vs Labour choice',
                  icon: Icons.how_to_reg_rounded,
                  iconColor: AppColors.tertiary,
                  onTap: () => _openScreen(
                    context,
                    const RoleSelectionScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'প্রোফাইল সেটআপ' : 'Profile Setup',
                  subtitle: isBangla ? 'নাম ও ছবি আপলোড' : 'Full name & profile photo',
                  icon: Icons.person_outline_rounded,
                  iconColor: AppColors.primary,
                  onTap: () => _openScreen(
                    context,
                    ProfileSetupScreen(selectedRole: activePersona.role),
                    overrides: commonOverrides,
                  ),
                ),
              ]),

              const SizedBox(height: 22),

              // 4. Section: Customer Screens
              _buildSectionTitle(
                title: isBangla ? 'কাস্টমার এক্সপেরিয়েন্স' : 'Customer Experience',
                icon: Icons.person_rounded,
              ),
              const SizedBox(height: 8),
              _buildCardsGrid([
                _PreviewCardItem(
                  title: isBangla ? 'কাস্টমার হোম' : 'Customer Home',
                  subtitle: isBangla ? 'সেবা ও কর্মী খোঁজার হোম' : 'Marketplace & Worker Discovery',
                  icon: Icons.home_rounded,
                  iconColor: AppColors.primary,
                  onTap: () => _openScreen(
                    context,
                    CustomerHomeScreen(profile: activePersona),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'কর্মী ও ট্রেড সার্চ' : 'Worker Search & Filter',
                  subtitle: isBangla ? 'ফিল্টার, রেট ও কর্মী তালিকা' : 'Smart filters, rates & results',
                  icon: Icons.search_rounded,
                  iconColor: AppColors.primary,
                  onTap: () => _openScreen(
                    context,
                    const WorkerSearchScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'আমার বুকিংস ও ট্র্যাকিং' : 'Customer Bookings & Tracking',
                  subtitle: isBangla ? 'লাইভ বুকিং ট্র্যাকার ও হিস্ট্রি' : 'Live tracking, tabs & history',
                  icon: Icons.receipt_long_rounded,
                  iconColor: AppColors.secondary,
                  onTap: () => _openScreen(
                    context,
                    const CustomerBookingsScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'প্রোফাইল ও সেটিংস' : 'Profile & Settings',
                  subtitle: isBangla ? 'বেন্টো স্ট্যাটস ও ভাষা বদল' : 'Bento stats, settings & language',
                  icon: Icons.settings_rounded,
                  iconColor: AppColors.secondary,
                  onTap: () => _openScreen(
                    context,
                    ProfileSettingsScreen(profile: activePersona),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'শ্রমিক প্রোফাইল ভিউ' : 'Labour Profile View',
                  subtitle: isBangla ? 'করিম মিঞা (যাচাইকৃত স্কোর ও ব্যাজ)' : 'Karim Mia (Verified Badges & Rates)',
                  icon: Icons.badge_rounded,
                  iconColor: AppColors.tertiary,
                  onTap: () => _openScreen(
                    context,
                    const LabourProfileViewScreen(workerId: PreviewData.labour1Id),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'এনআইডি: জমা দেওয়া হয়নি' : 'NID: Unsubmitted',
                  subtitle: isBangla ? 'নতুন নথি আপলোড ফর্ম' : 'Fresh document upload form',
                  icon: Icons.file_upload_outlined,
                  iconColor: AppColors.textMuted,
                  onTap: () => _openScreen(
                    context,
                    const IdentityVerificationScreen(),
                    overrides: [
                      ...commonOverrides,
                      currentVerificationStreamProvider.overrideWith((_) => Stream.value(null)),
                    ],
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'এনআইডি: অপেক্ষমাণ' : 'NID: Pending Review',
                  subtitle: isBangla ? 'পর্যালোচনাধীন ব্যানার' : 'Under admin review banner',
                  icon: Icons.hourglass_top_rounded,
                  iconColor: AppColors.tertiary,
                  onTap: () => _openScreen(
                    context,
                    const IdentityVerificationScreen(),
                    overrides: [
                      ...commonOverrides,
                      currentVerificationStreamProvider.overrideWith(
                        (_) => Stream.value(PreviewData.pendingVerification),
                      ),
                    ],
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'এনআইডি: অনুমোদিত' : 'NID: Approved',
                  subtitle: isBangla ? 'সবুজ ভেরিফায়েড ব্যাজ' : 'Green verified badge active',
                  icon: Icons.verified_rounded,
                  iconColor: AppColors.secondary,
                  onTap: () => _openScreen(
                    context,
                    const IdentityVerificationScreen(),
                    overrides: [
                      ...commonOverrides,
                      currentVerificationStreamProvider.overrideWith(
                        (_) => Stream.value(PreviewData.approvedVerification),
                      ),
                    ],
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'এনআইডি: প্রত্যাখ্যাত' : 'NID: Rejected',
                  subtitle: isBangla ? 'কারণ ও পুনরায় জমা বোতাম' : 'Reason & Resubmit CTA',
                  icon: Icons.cancel_outlined,
                  iconColor: AppColors.error,
                  onTap: () => _openScreen(
                    context,
                    const IdentityVerificationScreen(),
                    overrides: [
                      ...commonOverrides,
                      currentVerificationStreamProvider.overrideWith(
                        (_) => Stream.value(PreviewData.rejectedVerification),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 22),

              // 5. Section: Labour Screens
              _buildSectionTitle(
                title: isBangla ? 'শ্রমিক এক্সপেরিয়েন্স' : 'Labour Experience',
                icon: Icons.handyman_rounded,
              ),
              const SizedBox(height: 8),
              _buildCardsGrid([
                _PreviewCardItem(
                  title: isBangla ? 'শ্রমিক হোম' : 'Labour Home',
                  subtitle: isBangla ? 'কাজের ড্যাশবোর্ড' : 'Labour Service Dashboard',
                  icon: Icons.work_history_rounded,
                  iconColor: AppColors.primary,
                  onTap: () => _openScreen(
                    context,
                    LabourHomeScreen(
                      profile: activePersona.role == UserRole.labour
                          ? activePersona
                          : PreviewData.karimLabour,
                    ),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'শ্রমিক প্রোফাইল সেটআপ' : 'Labour Profile Setup/Edit',
                  subtitle: isBangla ? 'দক্ষতা, রেট ও সময়সূচি' : 'Skills multi-select, wage & schedule',
                  icon: Icons.edit_note_rounded,
                  iconColor: AppColors.secondary,
                  onTap: () => _openScreen(
                    context,
                    const LabourProfileSetupScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'শ্রমিক প্রোফাইল (নিজের)' : 'Labour Profile (Own View)',
                  subtitle: isBangla ? 'সম্পাদনা বোতামসহ প্রোফাইল' : 'Profile with Edit Profile CTA',
                  icon: Icons.badge_rounded,
                  iconColor: AppColors.tertiary,
                  onTap: () => _openScreen(
                    context,
                    LabourProfileViewScreen(
                      workerId: activePersona.role == UserRole.labour
                          ? activePersona.id
                          : PreviewData.karimLabour.id,
                    ),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'স্ট্যাটাস: পেন্ডিং' : 'Status: Pending',
                  subtitle: isBangla ? 'যাচাই প্রক্রিয়াধীন পর্দা' : 'Verification pending screen',
                  icon: Icons.pending_actions_rounded,
                  iconColor: AppColors.tertiary,
                  onTap: () => _openScreen(
                    context,
                    const AccountStatusScreen(status: AccountStatus.pendingVerification),
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'স্ট্যাটাস: প্রত্যাখ্যাত' : 'Status: Rejected',
                  subtitle: isBangla ? 'পুনরায় চেষ্টা করার অপশন' : 'Rejected account screen',
                  icon: Icons.error_outline_rounded,
                  iconColor: AppColors.error,
                  onTap: () => _openScreen(
                    context,
                    const AccountStatusScreen(status: AccountStatus.rejected),
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'স্ট্যাটাস: সাময়িক স্থগিত' : 'Status: Suspended',
                  subtitle: isBangla ? 'সাসপেন্ডেড একাউন্ট' : 'Suspended account screen',
                  icon: Icons.pause_circle_outline_rounded,
                  iconColor: AppColors.tertiary,
                  onTap: () => _openScreen(
                    context,
                    const AccountStatusScreen(status: AccountStatus.suspended),
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'স্ট্যাটাস: নিষিদ্ধ' : 'Status: Banned',
                  subtitle: isBangla ? 'স্থায়ী নিষিদ্ধ একাউন্ট' : 'Banned account screen',
                  icon: Icons.block_rounded,
                  iconColor: AppColors.error,
                  onTap: () => _openScreen(
                    context,
                    const AccountStatusScreen(status: AccountStatus.permanentlyBanned),
                  ),
                ),
              ]),

              const SizedBox(height: 22),

              // 6. Section: Admin Screens
              _buildSectionTitle(
                title: isBangla ? 'অ্যাডমিন ডেস্ক' : 'Admin Operations',
                icon: Icons.admin_panel_settings_rounded,
              ),
              const SizedBox(height: 8),
              _buildCardsGrid([
                _PreviewCardItem(
                  title: isBangla ? 'অ্যাডমিন ওভারভিউ' : 'Admin Overview',
                  subtitle: isBangla ? 'প্ল্যাটফর্ম নিয়ন্ত্রণ ও কেপিআই' : 'Platform control & live metrics',
                  icon: Icons.analytics_outlined,
                  iconColor: AppColors.primary,
                  onTap: () => _openScreen(
                    context,
                    const AdminOverviewScreen(),
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'ভেরিফিকেশন ডেস্ক' : 'Verification Desk',
                  subtitle: isBangla ? 'এনআইডি অনুমোদন ও প্রত্যাখ্যান' : 'Approve/Reject NID documents',
                  icon: Icons.fact_check_rounded,
                  iconColor: AppColors.secondary,
                  onTap: () => _openScreen(
                    context,
                    const AdminVerificationDeskScreen(),
                  ),
                ),
              ]),

              const SizedBox(height: 22),

              // 7. Section: Coming in Future Phases (Greyed Placeholders)
              _buildSectionTitle(
                title: isBangla ? 'পরবর্তী ফেজসমূহ' : 'Future Phases Roadmap',
                icon: Icons.schedule_rounded,
              ),
              const SizedBox(height: 8),
              _buildCardsGrid([
                _PreviewCardItem(
                  title: isBangla ? 'সার্চ ও ফিল্টার' : 'Search & Filter',
                  subtitle: isBangla ? 'কর্মী খোঁজা ও ফিল্টারিং' : 'Worker discovery & filters UI',
                  icon: Icons.search_rounded,
                  iconColor: AppColors.primary,
                  isComingSoon: false,
                  onTap: () => _openScreen(
                    context,
                    const WorkerSearchScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'বুকিং ওয়ার্কফ্লো' : 'Booking Workflow',
                  subtitle: isBangla ? 'তাৎক্ষণিক বুকিং ও ওভারল্যাপ চেক' : 'Instant booking & overlap check',
                  icon: Icons.calendar_month_rounded,
                  iconColor: AppColors.primary,
                  isComingSoon: false,
                  onTap: () => _openScreen(
                    context,
                    const BookingRequestScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'লাইভ চ্যাট' : 'Direct Labour Chat',
                  subtitle: isBangla ? 'সরাসরি চ্যাট ও কাজের চুক্তিপত্র' : 'Direct chat & scope agreement',
                  icon: Icons.chat_rounded,
                  iconColor: AppColors.secondary,
                  isComingSoon: false,
                  onTap: () => _openScreen(
                    context,
                    const ChatAgreementScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'চেক-ইন ও কিউআর' : 'QR / GPS Check-in',
                  subtitle: isBangla ? 'রিয়েলটাইম প্রিভিউ' : 'Live design preview',
                  icon: Icons.qr_code_scanner_rounded,
                  iconColor: AppColors.secondary,
                  onTap: () => _openScreen(
                    context,
                    const OnSiteCheckinTimerScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'ডিজিটাল পেমেন্ট সুরক্ষা' : 'Secure Payment (Sandbox)',
                  subtitle: isBangla ? 'রিয়েলটাইম প্রিভিউ' : 'Live design preview',
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: AppColors.secondary,
                  onTap: () => _openScreen(
                    context,
                    const SecurePaymentScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'অভিযোগ ও নিষ্পত্তি' : 'Dispute & Complaint',
                  subtitle: isBangla ? 'রিয়েলটাইম প্রিভিউ' : 'Live design preview',
                  icon: Icons.gavel_rounded,
                  iconColor: AppColors.primary,
                  onTap: () => _openScreen(
                    context,
                    const DisputeSubmissionScreen(),
                    overrides: commonOverrides,
                  ),
                ),
                _PreviewCardItem(
                  title: isBangla ? 'রিয়েলটাইম নোটিফিকেশন' : 'Push Notifications',
                  subtitle: isBangla ? 'ফেজ ৬-এ আসছে' : 'Coming in Phase 6',
                  icon: Icons.notifications_active_rounded,
                  iconColor: AppColors.textMuted,
                  isComingSoon: true,
                  onTap: () => _showComingSoonSnackBar(context, 'Push Notifications (Phase 6)'),
                ),
              ]),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be implemented in subsequent phases.'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.textMuted,
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCardsGrid(List<_PreviewCardItem> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 580;
        final crossAxisCount = isWide ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: isWide ? 1.4 : 1.25,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];
            final isInactive = card.isComingSoon;

            return InkWell(
              onTap: card.onTap,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isInactive ? AppColors.surface.withValues(alpha: 0.6) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isInactive ? AppColors.outline.withValues(alpha: 0.5) : AppColors.outline,
                  ),
                  boxShadow: isInactive
                      ? null
                      : [
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
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: card.iconColor.withValues(alpha: isInactive ? 0.08 : 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(card.icon, size: 20, color: card.iconColor),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isInactive ? AppColors.textMuted : AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          card.subtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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

  Widget _buildPersonaSelectorCard({
    required BuildContext context,
    required WidgetRef ref,
    required UserProfile activePersona,
    required UserRole activeRole,
    required bool isBangla,
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
              Text(
                isBangla ? 'সক্রিয় প্রিভিউ রোল' : 'Active Preview Role',
                style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  activePersona.role.name.toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Role Segmented Buttons
          Row(
            children: [
              Expanded(
                child: _buildRoleChip(
                  label: isBangla ? 'কাস্টমার' : 'Customer',
                  role: UserRole.customer,
                  isSelected: activeRole == UserRole.customer,
                  onTap: () {
                    ref.read(previewRoleFilterProvider.notifier).state = UserRole.customer;
                    ref.read(previewPersonaProvider.notifier).state = PreviewData.rahimCustomer;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRoleChip(
                  label: isBangla ? 'শ্রমিক' : 'Labour',
                  role: UserRole.labour,
                  isSelected: activeRole == UserRole.labour,
                  onTap: () {
                    ref.read(previewRoleFilterProvider.notifier).state = UserRole.labour;
                    ref.read(previewPersonaProvider.notifier).state = PreviewData.karimLabour;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRoleChip(
                  label: isBangla ? 'অ্যাডমিন' : 'Admin',
                  role: UserRole.admin,
                  isSelected: activeRole == UserRole.admin,
                  onTap: () {
                    ref.read(previewRoleFilterProvider.notifier).state = UserRole.admin;
                    ref.read(previewPersonaProvider.notifier).state = PreviewData.superAdmin;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Persona Chips
          Text(
            isBangla ? 'ডেমো পার্সোনা বেছে নিন:' : 'Select Demo Persona:',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PreviewData.allPersonas.map((persona) {
              final isSelected = persona.id == activePersona.id;
              return ChoiceChip(
                label: Text(persona.fullName ?? persona.phone ?? 'User'),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.background,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.onSurface,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.outline,
                  ),
                ),
                onSelected: (val) {
                  if (val) {
                    ref.read(previewPersonaProvider.notifier).state = persona;
                    ref.read(previewRoleFilterProvider.notifier).state = persona.role;
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip({
    required String label,
    required UserRole role,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? Colors.white : AppColors.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewCardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isComingSoon;

  _PreviewCardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.isComingSoon = false,
  });
}

