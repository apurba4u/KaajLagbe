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
  String get startTimeLabel => 'Start';

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
}
