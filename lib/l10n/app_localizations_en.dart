// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'KaajLagbe';

  @override
  String get verified => 'Verified';

  @override
  String get help => 'Help';

  @override
  String get language => 'Language';

  @override
  String get bangla => 'বাং';

  @override
  String get english => 'EN';

  @override
  String get loading => 'Loading...';

  @override
  String get continueAction => 'Continue';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get signOut => 'Sign Out';

  @override
  String get currencySymbol => '৳';

  @override
  String get devModeOtpSkipped => 'DEV MODE: OTP skipped';

  @override
  String get continueWithoutOtp => 'Continue without OTP (dev mode)';

  @override
  String get splashTagline => 'The Most Reliable Verified Labour Marketplace';

  @override
  String get splashActionGetStarted => 'Get Started';

  @override
  String get splashVerifiedPros => '100% Verified Workers';

  @override
  String get splashSecurePayments => 'Secure Payments';

  @override
  String get splashConnecting => 'Connecting verified pros...';

  @override
  String get splashLocationDhaka => 'Dhaka';

  @override
  String get splashLiveService => 'Live Service';

  @override
  String get splashVerifiedProsTagline => 'Verified Labour & Skilled Services';

  @override
  String get splashMetricNid => '100% NID';

  @override
  String get splashMetricNidSub => 'Verified Identity';

  @override
  String get splashMetricFast => '15 Mins';

  @override
  String get splashMetricFastSub => 'Fast Response';

  @override
  String get splashFooterTitle => '100% Verified Workers • Transparent Pricing';

  @override
  String get splashFooterSubtitle =>
      'National ID Checked • Trade Tested Reviews';

  @override
  String get loginWelcome => 'Welcome!';

  @override
  String get loginSubtitle => 'Enter your mobile number to log in or register';

  @override
  String get phoneNumberLabel => 'Phone Number *';

  @override
  String get phoneNumberHint => '17XXXXXXXX';

  @override
  String get phoneHelperText =>
      'We will send a 6-digit OTP code to this number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get workerTogglePromptCustomer =>
      'Skilled tradesperson or technician?';

  @override
  String get workerToggleActionWorker => 'Join as a Worker';

  @override
  String get workerTogglePromptWorker => 'Looking to hire services?';

  @override
  String get workerToggleActionCustomer => 'Customer Login';

  @override
  String get phoneErrorEmpty => 'Please enter phone number';

  @override
  String get phoneErrorInvalidPrefix =>
      'Bangladeshi number must start with 1 (e.g. 17XXXXXXXX)';

  @override
  String get phoneErrorInvalidLength =>
      'Enter a valid 10-digit number (e.g. 17XXXXXXXX)';

  @override
  String get otpSendError =>
      'Failed to send OTP. Please check your network and number.';

  @override
  String get authErrorPhoneProviderDisabled =>
      'Phone OTP provider is disabled. Please enable the Phone provider in the Supabase Dashboard or use test numbers.';

  @override
  String get authErrorSmsSendFailed =>
      'Failed to send SMS OTP. Please check your SMS provider configuration or balance.';

  @override
  String get authErrorRateLimit =>
      'Too many requests. For security purposes, please wait a moment before requesting another code.';

  @override
  String get authErrorInvalidPhone =>
      'Invalid phone number format. Please enter a valid 10-digit Bangladeshi mobile number (e.g. 17XXXXXXXX).';

  @override
  String get authErrorNetworkOffline =>
      'No internet connection detected. Please check your network and try again.';

  @override
  String get demoQuickFillTitle => 'Demo Accounts Quick-Fill';

  @override
  String get devLoginError =>
      'Dev login failed. Check Supabase email provider settings.';

  @override
  String get identityVerificationTitle => 'Identity Verification';

  @override
  String get identityVerificationSubtitle =>
      'Verify your National ID or Passport to unlock bookings and build trust';

  @override
  String get docTypeLabel => 'Document Type';

  @override
  String get docTypeNid => 'National ID (NID)';

  @override
  String get docTypePassport => 'Passport';

  @override
  String get docNumberLabel => 'Document Number';

  @override
  String get docNumberPlaceholder => 'Enter 10 or 17 digit number';

  @override
  String get docNumberPassportPlaceholder => 'Enter Passport number';

  @override
  String get uploadPhotosTitle => 'Upload Document Photos';

  @override
  String get uploadFrontPhoto => 'Front Side Photo';

  @override
  String get uploadFrontPhotoSub =>
      'Name, date of birth, and photo must be clearly visible';

  @override
  String get uploadBackPhoto => 'Back Side Photo';

  @override
  String get uploadBackPhotoSub => 'Address and barcode must be clear';

  @override
  String get uploadSelfie => 'Selfie Holding Document';

  @override
  String get uploadSelfieSub =>
      'Ensure your face and document numbers are clear';

  @override
  String get privacyTrustNotice =>
      'Your documents are private, encrypted, and visible only to verified compliance admins.';

  @override
  String get submitVerification => 'Submit for Verification';

  @override
  String get verificationStatusNotSubmitted => 'Not Submitted';

  @override
  String get verificationStatusPending =>
      'Verification in Progress (1-4 hours)';

  @override
  String get verificationStatusApproved => 'Identity Approved';

  @override
  String get verificationStatusRejected => 'Verification Rejected';

  @override
  String get verificationSubmittedSuccess =>
      'Verification documents submitted successfully. You will be notified once reviewed.';

  @override
  String get selectFileAction => 'Take photo or select file';

  @override
  String get fileSelected => 'Photo selected';

  @override
  String get fileRequiredError => 'Please upload all required photos';

  @override
  String get docNumberRequiredError => 'Please enter a valid document number';

  @override
  String get viewOrSubmitVerification => 'Go to Identity Verification';

  @override
  String get identityVerificationNav => 'Identity Verification';

  @override
  String get labourProfileSetupTitle => 'Labour Profile Setup';

  @override
  String get labourProfileSetupSubtitle =>
      'Manage your trade skills, rates and availability';

  @override
  String get profilePhotoSectionTitle => 'Profile Photo';

  @override
  String get profilePhotoHelperText => 'Upload a clear, professional photo';

  @override
  String get skillsAndBadgesTitle => 'Skills & Badges';

  @override
  String get claimedSkillLegend => 'Claimed (Not Verified)';

  @override
  String get verifiedSkillLegend => 'Verified Badge (Score ≥ 200)';

  @override
  String get workDetailsTitle => 'Work Details & Rates';

  @override
  String get experienceLabel => 'Experience & Background';

  @override
  String get experiencePlaceholder =>
      'e.g. 5+ years in residential wiring and appliance repairs...';

  @override
  String get serviceAreaLabel => 'Service Area';

  @override
  String get serviceAreaPlaceholder => 'e.g. Mirpur, Dhanmondi, Dhaka';

  @override
  String get expectedWageLabel => 'Expected Wage per Hour';

  @override
  String get expectedWagePlaceholder => 'e.g. 500 / hr';

  @override
  String get weeklyAvailabilityTitle => 'Weekly Availability';

  @override
  String get selectAvailableDays => 'Select available days';

  @override
  String get workingHoursTitle => 'Working Hours';

  @override
  String get startTimeLabel => 'Start Time';

  @override
  String get endTimeLabel => 'End';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get profileSavedSuccess => 'Profile saved successfully';

  @override
  String get selectAtLeastOneSkill => 'Please select at least one skill';

  @override
  String get serviceAreaRequired => 'Please enter your service area';

  @override
  String get wageRequired => 'Please enter expected hourly wage';

  @override
  String get satDay => 'Sat';

  @override
  String get sunDay => 'Sun';

  @override
  String get monDay => 'Mon';

  @override
  String get tueDay => 'Tue';

  @override
  String get wedDay => 'Wed';

  @override
  String get thuDay => 'Thu';

  @override
  String get friDay => 'Fri';

  @override
  String get labourProfileViewTitle => 'Worker Profile';

  @override
  String get activeBadge => 'Active Badge';

  @override
  String get claimedSkill => 'Claimed';

  @override
  String get scoreLabel => 'Score';

  @override
  String get hourlyRateLabel => 'Hourly Rate';

  @override
  String get serviceAreaSectionTitle => 'Service Area';

  @override
  String get aboutAndExperienceTitle => 'Experience & About';

  @override
  String get availabilitySectionTitle => 'Availability Schedule';

  @override
  String get editProfileButton => 'Edit Profile';

  @override
  String get bookLabourButton => 'Book Worker';

  @override
  String get verifiedWorkerBadge => 'Verified Worker';

  @override
  String get reviewsTitle => 'Customer Reviews';

  @override
  String get safetyGuaranteeTitle => 'KaajLagbe Safety Protection';

  @override
  String get safetyGuaranteeDesc =>
      'Identity verification ensures work quality and safe payment protection with instant rework support.';

  @override
  String get readyForBooking => 'Ready for booking today';

  @override
  String get ratesAndPackagesTitle => 'Rates & Charges';

  @override
  String get transparentRatesBadge => 'Transparent Rates';

  @override
  String get policeRecordClear => 'Police Record: Clear';

  @override
  String get punctualityScore => '99% On-Time';

  @override
  String get kaajLagbeProBadge => 'KaajLagbe Pro';

  @override
  String get bookingComingSoon => 'Booking workflow starts in Phase 5';

  @override
  String get trustSecurityTitle => 'Secure & Reliable Service';

  @override
  String get trustSecuritySubtitle =>
      'All workers are verified with National ID and proven skills';

  @override
  String get termsAgreementText =>
      'By proceeding, you agree to KaajLagbe\'s Terms & Conditions and Privacy Policy.';

  @override
  String get phoneSecurityBannerTitle => 'Verified & Secure Platform';

  @override
  String get phoneSecurityBannerSubtitle =>
      '100% National ID (NID) Verified Platform';

  @override
  String get otpTitle => 'OTP Verification';

  @override
  String otpSubtitle(String phone) {
    return 'Enter the 6-digit code sent to $phone';
  }

  @override
  String otpResendIn(String seconds) {
    return 'Resend code in (${seconds}s)';
  }

  @override
  String get otpResendAction => 'Didn\'t receive code? Resend';

  @override
  String get verifyAndProceed => 'Verify & Proceed';

  @override
  String get changeNumber => 'Change Number';

  @override
  String get otpInvalidLength => 'Please enter the complete 6-digit OTP code';

  @override
  String get otpVerificationError =>
      'Invalid OTP code or the code has expired.';

  @override
  String get otpResentSuccess => 'A new OTP code has been sent.';

  @override
  String get otpEditNumber => 'Edit';

  @override
  String get otpInputPrompt => 'Enter 6-digit OTP';

  @override
  String get otpResendCodePrompt => 'Didn\'t receive code?';

  @override
  String get otpResendActionSms => 'Resend SMS';

  @override
  String get otpResendFailed => 'Failed to resend OTP. Please try again later.';

  @override
  String get otpSecuritySafe => '100% Secure Verification';

  @override
  String get otpSecurityNid => 'NID Tested Platform';

  @override
  String get roleSelectionTitle => 'Select Your Role';

  @override
  String get roleSelectionSubtitle => 'How would you like to use KaajLagbe?';

  @override
  String get roleSelectionTrustBadge => 'Safe & Simple Start';

  @override
  String get customerRoleTitle => 'I need work done';

  @override
  String get customerRoleSubtitle =>
      'Find and book verified, trusted workers for home or office jobs';

  @override
  String get customerRoleBadge => 'Customer';

  @override
  String get customerPerk1 => 'Verified Skilled Workers';

  @override
  String get customerPerk2 => 'Transparent Rates & Direct Booking';

  @override
  String get labourRoleTitle => 'I want to work';

  @override
  String get labourRoleSubtitle =>
      'Add your skills, get direct bookings, and grow your income';

  @override
  String get labourRoleBadge => 'Labour';

  @override
  String get labourPerk1 => 'Direct Payment';

  @override
  String get labourPerk2 => 'Regular Work Opportunities';

  @override
  String get selectRoleError => 'Please select a role to continue';

  @override
  String get roleAdminBlockedError => 'Admin role cannot be selected';

  @override
  String get roleSaveError =>
      'Failed to save role. Please check your network connection.';

  @override
  String get profileSetupTitle => 'Set Up Your Profile';

  @override
  String get profileSetupSubtitle =>
      'Accurate details help us serve you better';

  @override
  String get fullNameLabel => 'Full Name *';

  @override
  String get fullNameHint => 'Name as per National ID';

  @override
  String get fullNameErrorEmpty => 'Please enter your full name';

  @override
  String get fullNameErrorTooShort => 'Name must be at least 3 characters';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get avatarSelected => 'Avatar selected';

  @override
  String get saveAndContinue => 'Save & Continue';

  @override
  String get profileSettingsTitle => 'Profile & Settings';

  @override
  String get accountInfo => 'Account Information';

  @override
  String get appSettings => 'App Settings';

  @override
  String get editName => 'Edit Name';

  @override
  String get editNameHint => 'Enter full name';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get nidVerifiedBadge => 'National ID Verified';

  @override
  String get nidVerifiedSub => 'NID Verified Citizen • Highest Security Level';

  @override
  String get totalBookings => 'Total Bookings';

  @override
  String get savedAddresses => 'Saved Addresses';

  @override
  String get balance => 'Balance';

  @override
  String get accountAndPlacesSection => 'Account & Places';

  @override
  String get savedAddressesTitle => 'Saved Addresses';

  @override
  String get savedAddressesSub => 'Home: Mirpur 10, Dhaka';

  @override
  String get paymentMethodsTitle => 'Payment Methods & History';

  @override
  String get paymentMethodsSub => 'bKash / Nagad / Card';

  @override
  String get safetyAndPolicySection => 'Safety & Controls';

  @override
  String get emergencyContactTitle => 'Emergency Contact & Safety';

  @override
  String get emergencyContactSub => 'Emergency Helpline & Tracking';

  @override
  String get changeLanguageTitle => 'Change Language';

  @override
  String get changeLanguageSub => 'Select application language';

  @override
  String get privacyAndTermsTitle => 'Privacy & Terms of Service';

  @override
  String get privacyAndTermsSub => 'User data protection policy';

  @override
  String get helpAndSupportSection => 'Help & Support';

  @override
  String get helpCenterTitle => 'Help Center & Support';

  @override
  String get helpCenterSub => 'Hotline 16420 or Live Chat (24/7)';

  @override
  String get disputesTitle => 'Disputes & Complaints Status';

  @override
  String get disputesSub => 'Active disputes tracking';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully';

  @override
  String get profileUpdateError => 'Failed to update profile';

  @override
  String get statusPendingTitle => 'Verification in Progress';

  @override
  String get statusPendingDescription =>
      'Our admin team is reviewing your identity documents. Verification typically takes 12-24 hours.';

  @override
  String get statusApprovedTitle => 'Account Approved';

  @override
  String get statusApprovedDescription =>
      'Your account is active and verified.';

  @override
  String get statusRejectedTitle => 'Verification Rejected';

  @override
  String get statusRejectedDescription =>
      'Your submission was not approved due to document or information discrepancies.';

  @override
  String get statusSuspendedTitle => 'Account Suspended';

  @override
  String get statusSuspendedDescription =>
      'Your account has been temporarily suspended due to a policy violation.';

  @override
  String get statusBannedTitle => 'Permanently Banned';

  @override
  String get statusBannedDescription =>
      'This account has been permanently deactivated due to severe policy violations.';

  @override
  String get rejectionReasonLabel => 'Reason for rejection:';

  @override
  String get resubmitVerification => 'Resubmit Verification';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get refreshStatus => 'Refresh';

  @override
  String get refreshingStatus => 'Checking latest account status...';

  @override
  String get verificationProgress => 'Verification Progress';

  @override
  String get progressStepPhone => 'Mobile Number & OTP Verification';

  @override
  String get progressStepPhoneSub => 'Completed successfully';

  @override
  String get progressStepReview => 'Admin Review & NID Approval';

  @override
  String get progressStepReviewSub => 'Admin team reviewing documents (12-24h)';

  @override
  String get progressStepAccess => 'Marketplace Access';

  @override
  String get progressStepAccessSub => 'Unlocked upon verification approval';

  @override
  String get marketplaceProtectionTitle => 'Marketplace Protection Policy';

  @override
  String get marketplaceProtectionSubtitle =>
      'Unapproved or suspended accounts are restricted from booking or accepting jobs.';

  @override
  String get checkStatusAction => 'Check Status';

  @override
  String get homeTitle => 'Home';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String get homePlaceholderCustomer =>
      'Customer marketplace and worker discovery coming soon.';

  @override
  String get homePlaceholderLabour =>
      'Labour dashboard and job queue coming soon.';

  @override
  String get profileAndSettings => 'Profile & Settings';

  @override
  String get locationMirpur => 'Mirpur 10, Dhaka';

  @override
  String goodMorningUser(String name) {
    return 'Good morning, $name! 👋';
  }

  @override
  String get customerSearchHint => 'What help do you need today?';

  @override
  String get nidAssuranceTitle => '100% National ID (NID) Verified';

  @override
  String get nidAssuranceSubtitle =>
      'Safe service experience with verified local workers';

  @override
  String get workerEnRoute => 'Worker is en route';

  @override
  String withinMinutes(String minutes) {
    return '⏱ Within $minutes mins';
  }

  @override
  String get electricWiringFix => 'Electrical wiring & short circuit fix';

  @override
  String get workerBranchMirpur => 'ID: #KL-88219 • Mirpur Branch';

  @override
  String get liveTracking => 'Live Tracking';

  @override
  String get callAction => 'Call';

  @override
  String get emergencyDailyServices => 'Emergency & Daily Services';

  @override
  String get callWorkerInMinutes => 'Call trusted workers in minutes';

  @override
  String get viewAll => 'View All';

  @override
  String get skillElectrician => 'Electrician';

  @override
  String get skillPlumber => 'Plumbing';

  @override
  String get skillCleaner => 'House Cleaning';

  @override
  String get skillAppliance => 'Appliance Repair';

  @override
  String get skillMoving => 'Moving & Lifting';

  @override
  String get skillPainter => 'Painting';

  @override
  String get skillCarpenter => 'Carpenter';

  @override
  String get skillGeneralHelper => 'General Helper';

  @override
  String get promoBannerTitle => '৳50 off on any repair!';

  @override
  String promoBannerCode(String code) {
    return 'Use code: $code';
  }

  @override
  String get promoOfferBadge => 'Offer • First Booking';

  @override
  String get topRatedWorkers => 'Popular Workers';

  @override
  String get topRatedWorkersSub => 'Highest customer-rated dependable workers';

  @override
  String get availableIn30Mins => 'Available in 30 mins';

  @override
  String get availableToday => 'Available Today';

  @override
  String get perHour => '/hr';

  @override
  String get viewProfileAndBook => 'View Profile & Book';

  @override
  String get kaajLagbeSafetyTitle => 'KaajLagbe Safety Protection';

  @override
  String get safetyNidVerified => 'NID Verified';

  @override
  String get safetyNidVerifiedSub =>
      'Identity and credentials checked for every worker';

  @override
  String get safetyTransparentRates => 'Transparent Rates';

  @override
  String get safetyTransparentRatesSub =>
      'No hidden charges, fair wages with fixed transparent pricing';

  @override
  String get safetyDisputeResolution => 'Quick Dispute Resolution';

  @override
  String get safetyDisputeResolutionSub =>
      '24/7 dedicated support team to resolve issues';

  @override
  String get safetyEasyRebooking => 'Easy Re-booking';

  @override
  String get safetyEasyRebookingSub =>
      'Re-book your favorite worker in just 1 tap';

  @override
  String get labourPanelTitle => 'Worker Panel';

  @override
  String get statusOnline => 'Online';

  @override
  String get statusOffline => 'Offline';

  @override
  String get radarActiveBanner => 'Online & Ready for Jobs • Radar Active';

  @override
  String get newJobRequestAlert => 'New Job Request!';

  @override
  String distanceAway(String distance) {
    return '$distance km away';
  }

  @override
  String get plusTipsOption => '+ Tips Available';

  @override
  String get proposedTime => 'Proposed Time';

  @override
  String get estimatedDuration => 'Estimated Duration';

  @override
  String get declineAction => 'Decline';

  @override
  String get acceptAction => 'Accept';

  @override
  String get jobAcceptedMessage => 'Job accepted! Customer has been notified.';

  @override
  String get todaysEarnings => 'Today\'s Earnings';

  @override
  String jobsCompletedCount(String count) {
    return '$count jobs completed';
  }

  @override
  String get pendingPayout => 'Pending Payout';

  @override
  String get payoutProcessing => 'bKash Processing';

  @override
  String get weeklyTarget => 'Weekly Target';

  @override
  String get targetGoal => '৳10,000 Goal';

  @override
  String get upcomingSchedule => 'Upcoming Schedule';

  @override
  String get tomorrowSchedule => 'Tomorrow 10:00 AM';

  @override
  String get cashPayment => 'Cash Payment';

  @override
  String get reputationBadgesTitle => 'Skill & Rating Badges';

  @override
  String get masterTier => 'Master Tier';

  @override
  String get wiringSafetyScore => 'Wiring Safety';

  @override
  String get onTimePerformance => 'On-time Service';

  @override
  String get findWorkBannerTitle => 'Find Nearby Jobs';

  @override
  String get findWorkBannerSub => '12 new jobs available around Mirpur';

  @override
  String get exploreAction => 'Explore';

  @override
  String get searchServiceLabel => 'Search Service';

  @override
  String get searchServiceHint => 'Search electrician, plumber, etc.';

  @override
  String get radiusPillText => 'Mirpur & Dhanmondi (4.5 km radius)';

  @override
  String get changeAreaAction => 'Change';

  @override
  String get filterVerifiedOnly => 'Verified Only ✓';

  @override
  String get filterRatingHigh => 'Rating 4.5+ ★';

  @override
  String get filterAvailableToday => 'Available Today';

  @override
  String get filterMaxRate => 'Max ৳400/hr';

  @override
  String get filterUrgent => 'Urgent Service';

  @override
  String verifiedWorkersFound(String count) {
    return '$count verified workers found';
  }

  @override
  String get onlineBadge => 'Online';

  @override
  String get sortPopular => 'Sort: Popular ▾';

  @override
  String successRate(String rate) {
    return '$rate% job success';
  }

  @override
  String get bookNowAction => 'Book Now';

  @override
  String get resetFilters => 'Reset Filters';

  @override
  String get noWorkersFoundSub =>
      'Reset filters to see all 38 available workers';

  @override
  String get filterModalTitle => 'Smart Filters & Budget';

  @override
  String get maxHourlyRate => 'Max Hourly Rate';

  @override
  String get trustLevelsTitle => 'Trust Levels';

  @override
  String get tradeLicenseCertified => 'Trade License / Certified';

  @override
  String get tradeLicenseCertifiedSub =>
      'Govt/TTC certified technical credentials';

  @override
  String get resetAllAction => 'Reset';

  @override
  String get applyFiltersAction => 'Apply Filters';

  @override
  String get previewOnlyMessage =>
      'This feature will be available in future phases (Preview Only)';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String get instantBookingTitle => 'Instant Booking Flow';

  @override
  String get bookingStepWork => '1. Work';

  @override
  String get bookingStepTimeBreak => '2. Time & Break';

  @override
  String get bookingStepConfirmation => '3. Confirmation';

  @override
  String get selectedServiceLabel => 'Selected Service';

  @override
  String get serviceAddressLabel => 'Work Address';

  @override
  String get selectDateTimeTitle => 'Select Date & Time';

  @override
  String get realtimeSlotBadge => 'Realtime Slot';

  @override
  String get todayLabel => 'Today';

  @override
  String get tomorrowLabel => 'Tomorrow';

  @override
  String get dayAfterLabel => 'Day After';

  @override
  String workerAvailableFrom(String time) {
    return 'Worker available from $time';
  }

  @override
  String get durationLabel => 'Estimated Duration';

  @override
  String get teaBreakIncluded => '15 min Tea Break included';

  @override
  String get teaBreakSub => 'Recognition of hard work, wage remains unchanged';

  @override
  String get overlapGuardTitle => 'Schedule Available (No Conflict Guard ✓)';

  @override
  String get overlapGuardDesc =>
      'Worker is busy in Mirpur 2 until 2:30 PM. Scheduling at 3:00 PM provides a safe 30-minute transit buffer.';

  @override
  String get costBreakdownTitle => 'Cost Breakdown';

  @override
  String get transparentBilling => 'Transparent Billing';

  @override
  String get workWageItem => 'Labour Wage (2 hrs × ৳350)';

  @override
  String get platformSafetyFee => 'Platform Safety & Insurance (5%)';

  @override
  String get teaBreakFee => 'Tea Break Fee';

  @override
  String get freeLabel => 'FREE';

  @override
  String get totalPayable => 'Total Payable';

  @override
  String get payableAfterInspection => 'Payable after work inspection';

  @override
  String get kaajlagbeSafetyGuarantee => 'KaajLagbe Safety Protection';

  @override
  String get safetyGuaranteeBullets =>
      '• 100% free cancellation up to 2 hrs before work.\n• No advance payment required.\n• 7-day free re-work support if unsatisfied.';

  @override
  String get bookingTermsAgreement =>
      'I agree to KaajLagbe service policy and safety protocols when booking workers.';

  @override
  String get confirmableBill => 'Payable Bill';

  @override
  String get cashOrBkash => 'Cash / bKash';

  @override
  String get confirmBookingCta => 'Confirm Booking';

  @override
  String get directChatTitle => 'Direct Chat';

  @override
  String bookingCodeLabel(String code) {
    return 'Booking #$code';
  }

  @override
  String get confirmedStatus => 'Confirmed';

  @override
  String totalRateHourly(String rate) {
    return 'Total (৳$rate/hr)';
  }

  @override
  String get safetyNoticeTitle => 'Security Notice';

  @override
  String get safetyNoticeDesc =>
      'Do not share personal phone numbers or OTP outside the platform. All transactions are protected by KaajLagbe Secure Payment.';

  @override
  String get digitalAgreementTitle => 'Digital Agreement';

  @override
  String get scopeConfirmationSubtitle => 'Scope & Schedule Confirmation';

  @override
  String get agreedBadge => 'Agreed ✓';

  @override
  String get workDurationLabel => 'Work Duration';

  @override
  String get breakAndPerksLabel => 'Break & Facilities';

  @override
  String get totalRemunerationLabel => 'Total Remuneration';

  @override
  String get noHiddenCharges => 'No hidden charges';

  @override
  String get securedByKaajlagbe => 'Protected by KaajLagbe Secure Payment';

  @override
  String get viewFullTerms => 'View Detailed Terms';

  @override
  String get quickExtendDuration => 'Extend Duration';

  @override
  String get quickMaterialsCost => 'Materials Cost';

  @override
  String get quickShareAddress => 'Share Address';

  @override
  String get quickSendPhoto => 'Send Work Photo';

  @override
  String get typeMessagePlaceholder => 'Type a message...';

  @override
  String get callDirectlyAction => 'Call Directly';

  @override
  String get myBookingsTitle => 'My Bookings';

  @override
  String get myBookingsSub => 'My Bookings & Service History';

  @override
  String totalBookingsCount(String count) {
    return '$count Total';
  }

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabInProgress => 'In Progress';

  @override
  String get tabCompleted => 'Completed';

  @override
  String get tabCancelled => 'Cancelled & Disputes';

  @override
  String get inProgressBadge => 'In Progress';

  @override
  String elapsedTimeLabel(String time) {
    return '$time elapsed';
  }

  @override
  String get fixedRateBadge => 'Fixed Rate';

  @override
  String get securePaymentProtected => 'Secure Payment Protected';

  @override
  String get liveTrackingAction => 'Live Tracking & Timer';

  @override
  String get chatCallAction => 'Message / Call';

  @override
  String get nextScheduledWorkTitle => 'Next Scheduled Service';

  @override
  String viewAllBookings(String count) {
    return 'View All ($count)';
  }

  @override
  String get viewDetailsAction => 'View Details';

  @override
  String get rescheduleAction => 'Reschedule';

  @override
  String get activeTrackingTitle => 'Active Service Tracking';

  @override
  String get workerOnSiteRibbon => 'Worker On-Site';

  @override
  String get onSiteBadge => 'On-Site';

  @override
  String workerArrivedVerified(String name) {
    return '$name has arrived • Verified';
  }

  @override
  String get workerIdVerification => 'Worker Identity Verification';

  @override
  String get verificationComplete => 'Verified ✓';

  @override
  String get fraudPreventionNotice =>
      'Identity confirmed via booking-specific QR and security PIN before service start.';

  @override
  String get checkInPinTitle => 'Check-In Security PIN';

  @override
  String get activeCodeLabel => 'Active Code';

  @override
  String get workerScanLabel => 'Worker Scan';

  @override
  String get liveSessionTracker => 'Live Session Tracker';

  @override
  String get liveSessionSub => 'Live Session Tracker';

  @override
  String get workInProgressBadge => 'In Progress';

  @override
  String get elapsedTimeHeader => 'Elapsed Time';

  @override
  String get scheduledWindow => 'Scheduled Window';

  @override
  String get allocatedDuration => 'Allocated Duration';

  @override
  String get allocatedDurationValue => '2 Hours (120 min)';

  @override
  String get overrunAlertTitle => 'Overrun Policy Notice';

  @override
  String get overrunAlertDesc =>
      'Extra work beyond session will be billed at ৳175 per 30 minutes.';

  @override
  String get takeBreakAction => 'Take 15m Break';

  @override
  String get endBreakAction => 'End Break';

  @override
  String get completeJobAction => 'Complete Job';

  @override
  String get helpDisputeAction => 'Help & Complaint';

  @override
  String get liveGeoFenceActive => 'Live Geo-fence Active';

  @override
  String get workerInsideBoundary => 'Worker is within the service boundary';

  @override
  String get securePaymentTitle => 'Secure Payment (Sandbox)';

  @override
  String get securePaymentSub => 'Protected by KaajLagbe Secure Payment';

  @override
  String get sandboxNotice =>
      'Sandbox Mode: No real money is charged. Use test credentials to simulate payment.';

  @override
  String get selectPaymentMethod => 'Select Payment Method';

  @override
  String get bkashPayment => 'bKash';

  @override
  String get nagadPayment => 'Nagad';

  @override
  String get cardPayment => 'Credit / Debit Card';

  @override
  String get cashOnCompletion => 'Cash on Completion';

  @override
  String get paySecurelyCta => 'Pay Securely (Sandbox)';

  @override
  String get disputeTitle => 'Complaint & Dispute Submission';

  @override
  String get disputeSubtitle => 'Resolution Desk & Protection';

  @override
  String get disputeReasonLabel => 'Dispute Reason';

  @override
  String get selectReasonPlaceholder => 'Select a dispute category';

  @override
  String get reasonQuality => 'Unsatisfactory Work Quality';

  @override
  String get reasonOvercharge => 'Overcharging / Price Mismatch';

  @override
  String get reasonNoShow => 'Worker Left Early / Incomplete';

  @override
  String get reasonDamage => 'Property Damage / Carelessness';

  @override
  String get descriptionLabel => 'Detailed Description';

  @override
  String get descriptionPlaceholder => 'Explain what went wrong in detail...';

  @override
  String get uploadEvidenceLabel => 'Attach Photos / Evidence';

  @override
  String get submitDisputeCta => 'Submit Complaint';

  @override
  String get disputeSubmittedMessage =>
      'Complaint received. Admin mediation team will review within 2 hours.';
}
