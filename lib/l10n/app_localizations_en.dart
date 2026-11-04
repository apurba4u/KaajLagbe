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
  String get devLoginError =>
      'Dev login failed. Check Supabase email provider settings.';

  @override
  String get trustSecurityTitle => 'Secure & Reliable Service';

  @override
  String get trustSecuritySubtitle =>
      'All workers are verified with National ID and proven skills';

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
  String get roleSelectionTitle => 'How would you like to use KaajLagbe?';

  @override
  String get roleSelectionSubtitle => 'Select your primary role to continue';

  @override
  String get customerRoleTitle => 'I need work done';

  @override
  String get customerRoleSubtitle =>
      'Find and book verified electricians, plumbers, painters and more';

  @override
  String get customerRoleBadge => 'Customer';

  @override
  String get labourRoleTitle => 'I want to work';

  @override
  String get labourRoleSubtitle =>
      'Receive booking requests matching your skills and grow your earnings';

  @override
  String get labourRoleBadge => 'Labour';

  @override
  String get selectRoleError => 'Please select a role to continue';

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
  String get profileSettingsTitle => 'Profile & Settings';

  @override
  String get accountInfo => 'Account Information';

  @override
  String get appSettings => 'App Settings';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

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
}
