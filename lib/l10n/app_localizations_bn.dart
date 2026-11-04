// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'KaajLagbe';

  @override
  String get verified => 'ভেরিফাইড';

  @override
  String get help => 'হেল্প';

  @override
  String get language => 'ভাষা';

  @override
  String get bangla => 'বাং';

  @override
  String get english => 'EN';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get continueAction => 'এগিয়ে যান';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get cancel => 'বাতিল';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get signOut => 'লগআউট';

  @override
  String get currencySymbol => '৳';

  @override
  String get devModeOtpSkipped => 'DEV MODE: OTP skipped';

  @override
  String get continueWithoutOtp => 'Continue without OTP (dev mode)';

  @override
  String get splashTagline =>
      'দক্ষ ও বিশ্বস্ত শ্রমিকের সবচেয়ে নির্ভরযোগ্য মার্কেটপ্লেস';

  @override
  String get splashActionGetStarted => 'সেবা শুরু করুন';

  @override
  String get splashVerifiedPros => '১০০% ভেরিফাইড কারিগর';

  @override
  String get splashSecurePayments => 'নিরাপদ লেনদেন';

  @override
  String get splashConnecting => 'দক্ষ কারিগর যুক্ত করা হচ্ছে...';

  @override
  String get splashLocationDhaka => 'ঢাকা';

  @override
  String get splashLiveService => 'সরাসরি সেবা';

  @override
  String get splashVerifiedProsTagline => 'বিশ্বস্ত শ্রম ও দক্ষ কর্মী সেবা';

  @override
  String get splashMetricNid => '১০০% এনআইডি';

  @override
  String get splashMetricNidSub => 'পরিচয় যাচাইকৃত';

  @override
  String get splashMetricFast => '১৫ মিনিট';

  @override
  String get splashMetricFastSub => 'দ্রুত সাড়া';

  @override
  String get splashFooterTitle => '১০০% ভেরিফাইড কারিগর • স্বচ্ছ মূল্য';

  @override
  String get splashFooterSubtitle => 'জাতীয় পরিচয়পত্র ও কাজের মান যাচাইকৃত';

  @override
  String get loginWelcome => 'স্বাগতম!';

  @override
  String get loginSubtitle =>
      'লগইন বা রেজিস্ট্রেশন করতে আপনার মোবাইল নম্বর দিন';

  @override
  String get phoneNumberLabel => 'মোবাইল নম্বর *';

  @override
  String get phoneNumberHint => '17XXXXXXXX';

  @override
  String get phoneHelperText => 'আমরা এই নম্বরে একটি ৬-সংখ্যার ওটিপি কোড পাঠাব';

  @override
  String get sendOtp => 'ওটিপি পাঠান';

  @override
  String get workerTogglePromptCustomer => 'দক্ষ কাজের কারিগর বা টেকনিশিয়ান?';

  @override
  String get workerToggleActionWorker => 'শ্রমিক হিসেবে যুক্ত হন';

  @override
  String get workerTogglePromptWorker => 'গ্রাহক হিসেবে সেবা নিতে চান?';

  @override
  String get workerToggleActionCustomer => 'গ্রাহক লগইন';

  @override
  String get phoneErrorEmpty => 'মোবাইল নম্বর লিখুন';

  @override
  String get phoneErrorInvalidPrefix =>
      'বাংলাদেশি নম্বর ১ দিয়ে শুরু হতে হবে (যেমন: 17XXXXXXXX)';

  @override
  String get phoneErrorInvalidLength =>
      'সঠিক ১০-সংখ্যার নম্বর দিন (যেমন: 17XXXXXXXX)';

  @override
  String get otpSendError =>
      'ওটিপি পাঠাতে সমস্যা হয়েছে। ইন্টারনেট সংযোগ ও নম্বর পরীক্ষা করুন।';

  @override
  String get devLoginError =>
      'ডেভ মোড লগইনে সমস্যা হয়েছে। Supabase ইমেইল প্রোভাইডার চেক করুন।';

  @override
  String get trustSecurityTitle => 'সুরক্ষিত ও নির্ভরযোগ্য সেবা';

  @override
  String get trustSecuritySubtitle =>
      'সকল শ্রমিকের জাতীয় পরিচয়পত্র ও কাজের দক্ষতা যাচাইকৃত';

  @override
  String get termsAgreementText =>
      'এগিয়ে যাওয়ার মাধ্যমে আপনি KaajLagbe-এর নিয়ম ও শর্তাবলী এবং গোপনীয়তা নীতি মেনে নিচ্ছেন।';

  @override
  String get phoneSecurityBannerTitle => 'যাচাইকৃত ও নিরাপদ প্ল্যাটফর্ম';

  @override
  String get phoneSecurityBannerSubtitle =>
      '১০০% জাতীয় পরিচয়পত্র (NID) যাচাইকৃত প্ল্যাটফর্ম';

  @override
  String get otpTitle => 'ওটিপি যাচাইকরণ';

  @override
  String otpSubtitle(String phone) {
    return '$phone নম্বরে পাঠানো ৬-সংখ্যার কোডটি প্রবেশ করুন';
  }

  @override
  String otpResendIn(String seconds) {
    return 'পুনরায় কোড পাঠান ($seconds সেকেন্ড)';
  }

  @override
  String get otpResendAction => 'কোড পাননি? পুনরায় পাঠান';

  @override
  String get verifyAndProceed => 'যাচাই করুন ও এগিয়ে যান';

  @override
  String get changeNumber => 'নম্বর পরিবর্তন করুন';

  @override
  String get otpInvalidLength => 'সম্পূর্ণ ৬-সংখ্যার ওটিপি কোড দিন';

  @override
  String get otpVerificationError =>
      'ভুল ওটিপি কোড অথবা কোডের মেয়াদ শেষ হয়েছে।';

  @override
  String get otpResentSuccess => 'নতুন ওটিপি কোড পাঠানো হয়েছে।';

  @override
  String get otpEditNumber => 'এডিট';

  @override
  String get otpInputPrompt => '৬-সংখ্যার ওটিপি লিখুন';

  @override
  String get otpResendCodePrompt => 'ওটিপি পাননি?';

  @override
  String get otpResendActionSms => 'এসএমএস পুনরায় পাঠান';

  @override
  String get otpResendFailed =>
      'ওটিপি পুনরায় পাঠাতে সমস্যা হয়েছে। একটু পর চেষ্টা করুন।';

  @override
  String get otpSecuritySafe => '১০০% নিরাপদ যাচাইকরণ';

  @override
  String get otpSecurityNid => 'NID পরীক্ষিত প্ল্যাটফর্ম';

  @override
  String get roleSelectionTitle => 'আপনার ভূমিকা নির্বাচন করুন';

  @override
  String get roleSelectionSubtitle => 'আপনি কীভাবে KaajLagbe ব্যবহার করতে চান?';

  @override
  String get roleSelectionTrustBadge => 'নিরাপদ ও সহজ শুরু';

  @override
  String get customerRoleTitle => 'আমার সেবা প্রয়োজন';

  @override
  String get customerRoleSubtitle =>
      'বাসা বা অফিসের কাজের জন্য যাচাইকৃত ও বিশ্বস্ত কর্মী খুঁজে নিন ও বুক করুন';

  @override
  String get customerRoleBadge => 'গ্রাহক';

  @override
  String get customerPerk1 => 'যাচাইকৃত দক্ষ কর্মী';

  @override
  String get customerPerk2 => 'স্বচ্ছ রেট ও সরাসরি বুকিং';

  @override
  String get labourRoleTitle => 'আমি কাজ করতে চাই';

  @override
  String get labourRoleSubtitle =>
      'আপনার দক্ষতা যোগ করুন, সরাসরি বুকিং পান এবং আয় বৃদ্ধি করুন';

  @override
  String get labourRoleBadge => 'কর্মী';

  @override
  String get labourPerk1 => 'সরাসরি পেমেন্ট';

  @override
  String get labourPerk2 => 'নতুন কাজের নিয়মিত সুযোগ';

  @override
  String get selectRoleError => 'অনুগ্রহ করে একটি ভূমিকা নির্বাচন করুন';

  @override
  String get roleAdminBlockedError => 'অ্যাডমিন ভূমিকা নির্বাচনযোগ্য নয়';

  @override
  String get roleSaveError =>
      'ভূমিকা সংরক্ষণ করতে সমস্যা হয়েছে। ইন্টারনেট সংযোগ পরীক্ষা করুন।';

  @override
  String get profileSetupTitle => 'আপনার প্রোফাইল সাজান';

  @override
  String get profileSetupSubtitle =>
      'সঠিক তথ্য দিলে সেবা পেতে ও দিতে সুবিধা হবে';

  @override
  String get fullNameLabel => 'আপনার পূর্ণ নাম *';

  @override
  String get fullNameHint => 'জাতীয় পরিচয়পত্র অনুযায়ী নাম';

  @override
  String get fullNameErrorEmpty => 'আপনার পূর্ণ নাম লিখুন';

  @override
  String get fullNameErrorTooShort => 'নাম কমপক্ষে ৩ অক্ষরের হতে হবে';

  @override
  String get uploadPhoto => 'ছবি আপলোড করুন';

  @override
  String get changePhoto => 'ছবি পরিবর্তন';

  @override
  String get avatarSelected => 'অ্যাভাটার যুক্ত করা হয়েছে';

  @override
  String get saveAndContinue => 'সংরক্ষণ করুন ও এগিয়ে যান';

  @override
  String get profileSettingsTitle => 'প্রোফাইল ও সেটিংস';

  @override
  String get accountInfo => 'অ্যাকাউন্টের তথ্য';

  @override
  String get appSettings => 'অ্যাপ সেটিংস';

  @override
  String get editName => 'নাম পরিবর্তন করুন';

  @override
  String get editNameHint => 'পূর্ণ নাম লিখুন';

  @override
  String get nameCannotBeEmpty => 'নাম খালি রাখা যাবে না';

  @override
  String get nidVerifiedBadge => 'জাতীয় পরিচয়পত্র যাচাইকৃত';

  @override
  String get nidVerifiedSub => 'NID Verified Citizen • সর্বোচ্চ নিরাপত্তা স্তর';

  @override
  String get totalBookings => 'মোট বুকিং';

  @override
  String get savedAddresses => 'সেভ করা ঠিকানা';

  @override
  String get balance => 'ব্যালেন্স';

  @override
  String get accountAndPlacesSection => 'অ্যাকাউন্ট ও ঠিকানা';

  @override
  String get savedAddressesTitle => 'সংরক্ষিত ঠিকানাসমূহ';

  @override
  String get savedAddressesSub => 'বাসা: মিরপুর ১০, ঢাকা';

  @override
  String get paymentMethodsTitle => 'পেমেন্ট মেথড ও লেনদেন হিস্ট্রি';

  @override
  String get paymentMethodsSub => 'বিকাশ / নগদ / কার্ড';

  @override
  String get safetyAndPolicySection => 'নিরাপত্তা ও নীতি';

  @override
  String get emergencyContactTitle => 'জরুরি যোগাযোগ ও নিরাপত্তা সেন্টার';

  @override
  String get emergencyContactSub => 'জরুরি হেল্পলাইন ও লাইভ ট্র্যাকিং';

  @override
  String get changeLanguageTitle => 'ভাষা পরিবর্তন';

  @override
  String get changeLanguageSub => 'অ্যাপের ভাষা নির্বাচন করুন';

  @override
  String get privacyAndTermsTitle => 'গোপনীয়তা ও টার্মস অব সার্ভিস';

  @override
  String get privacyAndTermsSub => 'ব্যবহারকারীর তথ্য সুরক্ষা নীতি';

  @override
  String get helpAndSupportSection => 'সহায়তা ও অভিযোগ';

  @override
  String get helpCenterTitle => 'হেল্প সেন্টার ও কাস্টমার কেয়ার';

  @override
  String get helpCenterSub => 'হটলাইন ১৬৪২০ অথবা লাইভ চ্যাট (২৪/৭)';

  @override
  String get disputesTitle => 'আমার বিরোধ ও অভিযোগের স্ট্যাটাস';

  @override
  String get disputesSub => 'সক্রিয় বিরোধসমূহ ট্র্যাকিং';

  @override
  String get profileUpdateSuccess => 'প্রোফাইল সফলভাবে আপডেট হয়েছে';

  @override
  String get profileUpdateError => 'প্রোফাইল সংরক্ষণে সমস্যা হয়েছে';

  @override
  String get statusPendingTitle => 'যাচাইকরণ প্রক্রিয়াধীন';

  @override
  String get statusPendingDescription =>
      'আপনার পরিচয়পত্র ও তথ্যাদি আমাদের অ্যাডমিন টিম যাচাই করছে। সাধারণত ১২-২৪ ঘণ্টার মধ্যে যাচাই সম্পন্ন হয়।';

  @override
  String get statusApprovedTitle => 'অ্যাকাউন্ট অনুমোদিত';

  @override
  String get statusApprovedDescription => 'আপনার অ্যাকাউন্ট সক্রিয় রয়েছে।';

  @override
  String get statusRejectedTitle => 'যাচাইকরণ বাতিল হয়েছে';

  @override
  String get statusRejectedDescription =>
      'আপনার প্রদানকৃত তথ্যে ত্রুটির কারণে আবেদনটি অনুমোদিত হয়নি।';

  @override
  String get statusSuspendedTitle => 'অ্যাকাউন্ট স্থগিত';

  @override
  String get statusSuspendedDescription =>
      'নিয়ম লঙ্ঘনের কারণে আপনার অ্যাকাউন্টটি সাময়িকভাবে স্থগিত করা হয়েছে।';

  @override
  String get statusBannedTitle => 'স্থায়ীভাবে নিষিদ্ধ';

  @override
  String get statusBannedDescription =>
      'গুরুতর নীতিমালা লঙ্ঘনের কারণে এই অ্যাকাউন্টটি স্থায়ীভাবে নিষ্ক্রিয় করা হয়েছে।';

  @override
  String get rejectionReasonLabel => 'বাতিল করার কারণ:';

  @override
  String get resubmitVerification => 'পুনরায় যাচাইয়ের আবেদন করুন';

  @override
  String get contactSupport => 'সাপোর্টে যোগাযোগ করুন';

  @override
  String get refreshStatus => 'রিফ্রেশ';

  @override
  String get refreshingStatus =>
      'অ্যাকাউন্টের সর্বশেষ অবস্থা যাচাই করা হচ্ছে...';

  @override
  String get verificationProgress => 'যাচাইকরণ অগ্রগতি';

  @override
  String get progressStepPhone => 'মোবাইল নম্বর ও ওটিপি যাচাই';

  @override
  String get progressStepPhoneSub => 'সফলভাবে সম্পন্ন হয়েছে';

  @override
  String get progressStepReview => 'প্রশাসনিক পর্যালোচনা ও NID অনুমোদন';

  @override
  String get progressStepReviewSub =>
      'অ্যাডমিন টিম নথিপত্র পরীক্ষা করছে (১২-২৪ ঘণ্টা)';

  @override
  String get progressStepAccess => 'মার্কেটপ্লেস প্রবেশাধিকার';

  @override
  String get progressStepAccessSub => 'অনুমোদনের পর সম্পূর্ণ সেবা উন্মুক্ত হবে';

  @override
  String get marketplaceProtectionTitle => 'মার্কেটপ্লেস সুরক্ষা নীতি';

  @override
  String get marketplaceProtectionSubtitle =>
      'অননুমোদিত বা স্থগিত অ্যাকাউন্ট দ্বারা সেবা অনুসন্ধান, কর্মী বুকিং বা কাজ গ্রহণ সম্পূর্ণ ব্লক রাখা হয়।';

  @override
  String get checkStatusAction => 'স্ট্যাটাস রিফ্রেশ করুন';

  @override
  String get homeTitle => 'হোম';

  @override
  String welcomeUser(String name) {
    return 'স্বাগতম, $name';
  }

  @override
  String get homePlaceholderCustomer =>
      'গ্রাহক মার্কেটপ্লেস ও শ্রমিক খোঁজার পৃষ্ঠা শীঘ্রই আসছে।';

  @override
  String get homePlaceholderLabour =>
      'শ্রমিক ড্যাশবোর্ড ও কাজের তালিকা শীঘ্রই আসছে।';

  @override
  String get profileAndSettings => 'প্রোফাইল ও সেটিংস';
}
