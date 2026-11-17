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
  String get authErrorPhoneProviderDisabled =>
      'ফোন ওটিপি প্রোভাইডার নিষ্ক্রিয়। Supabase ড্যাশবোর্ডে Phone প্রোভাইডার চালু করুন অথবা টেস্ট নম্বর ব্যবহার করুন।';

  @override
  String get authErrorSmsSendFailed =>
      'এসএমএস গেটওয়ে থেকে ওটিপি কোড পাঠানো যায়নি। এসএমএস প্রোভাইডার সেটিংস বা ব্যালেন্স পরীক্ষা করুন।';

  @override
  String get authErrorRateLimit =>
      'নিরাপত্তার স্বার্থে ওটিপি পাঠানোর সীমা অতিক্রান্ত হয়েছে। অনুগ্রহ করে কিছুক্ষণ অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get authErrorInvalidPhone =>
      'মোবাইল নম্বরটি সঠিক নয়। অনুগ্রহ করে ১০-সংখ্যার সঠিক বাংলাদেশি নম্বর লিখুন (যেমন: 17XXXXXXXX)।';

  @override
  String get authErrorNetworkOffline =>
      'ইন্টারনেট সংযোগ পাওয়া যায়নি। আপনার মোবাইল ডাটা বা ওয়াই-ফাই সংযোগ পরীক্ষা করুন।';

  @override
  String get demoQuickFillTitle => 'ডেমো অ্যাকাউন্ট কুইক-ফিল';

  @override
  String get devLoginError =>
      'ডেভ মোড লগইনে সমস্যা হয়েছে। Supabase ইমেইল প্রোভাইডার চেক করুন।';

  @override
  String get identityVerificationTitle => 'জাতীয় পরিচয়পত্র যাচাই';

  @override
  String get identityVerificationSubtitle =>
      'বুকিং সুবিধা ও বিশ্বস্ততা বৃদ্ধির জন্য জাতীয় পরিচয়পত্র বা পাসপোর্ট যাচাই করুন';

  @override
  String get docTypeLabel => 'ডকুমেন্টের ধরন';

  @override
  String get docTypeNid => 'জাতীয় পরিচয়পত্র';

  @override
  String get docTypePassport => 'পাসপোর্ট';

  @override
  String get docNumberLabel => 'ডকুমেন্ট নম্বর';

  @override
  String get docNumberPlaceholder => '১০ বা ১৭ সংখ্যার নম্বর লিখুন';

  @override
  String get docNumberPassportPlaceholder => 'পাসপোর্ট নম্বর লিখুন';

  @override
  String get uploadPhotosTitle => 'ডকুমেন্টের ছবি আপলোড';

  @override
  String get uploadFrontPhoto => 'সামনের পাতার ছবি';

  @override
  String get uploadFrontPhotoSub => 'নাম, জন্ম তারিখ ও ছবি স্পষ্ট হতে হবে';

  @override
  String get uploadBackPhoto => 'পেছনের পাতার ছবি';

  @override
  String get uploadBackPhotoSub => 'ঠিকানা ও বারকোড পরিষ্কার রাখুন';

  @override
  String get uploadSelfie => 'ডকুমেন্টসহ সেলফি';

  @override
  String get uploadSelfieSub => 'চেহারা ও কার্ডের লেখা স্পষ্ট রাখুন';

  @override
  String get privacyTrustNotice =>
      'আপনার তথ্য সম্পূর্ণ সুরক্ষিত ও এনক্রিপ্টেড। শুধুমাত্র পরিচয় যাচাইকরণের কাজে ব্যবহৃত হয়।';

  @override
  String get submitVerification => 'যাচাইয়ের জন্য জমা দিন';

  @override
  String get verificationStatusNotSubmitted => 'এখনও জমা দেওয়া হয়নি';

  @override
  String get verificationStatusPending => 'যাচাই প্রক্রিয়াধীন (১-৪ ঘণ্টা)';

  @override
  String get verificationStatusApproved => 'পরিচয়পত্র অনুমোদিত';

  @override
  String get verificationStatusRejected => 'যাচাইকরণ প্রত্যাখ্যাত হয়েছে';

  @override
  String get verificationSubmittedSuccess =>
      'পরিচয়পত্র সফলভাবে জমা দেওয়া হয়েছে। পর্যালোচনার পর জানানো হবে।';

  @override
  String get selectFileAction => 'ছবি তুলুন বা ফাইল নির্বাচন করুন';

  @override
  String get fileSelected => 'ছবি নির্বাচিত হয়েছে';

  @override
  String get fileRequiredError => 'সবগুলো প্রয়োজনীয় ছবি আপলোড করুন';

  @override
  String get docNumberRequiredError => 'সঠিক ডকুমেন্ট নম্বর দিন';

  @override
  String get viewOrSubmitVerification => 'পরিচয়পত্র যাচাইকরণে যান';

  @override
  String get identityVerificationNav => 'জাতীয় পরিচয়পত্র যাচাই';

  @override
  String get labourProfileSetupTitle => 'শ্রমিক প্রোফাইল সেটআপ';

  @override
  String get labourProfileSetupSubtitle =>
      'কাজের দক্ষতা, এলাকা ও পারিশ্রমিক নির্ধারণ করুন';

  @override
  String get profilePhotoSectionTitle => 'প্রোফাইল ছবি';

  @override
  String get profilePhotoHelperText => 'পরিষ্কার ও প্রফেশনাল ছবি আপলোড করুন';

  @override
  String get skillsAndBadgesTitle => 'কাজের দক্ষতা ও ব্যাজ';

  @override
  String get claimedSkillLegend => 'দাবিকৃত (যাচাই অপেক্ষমাণ)';

  @override
  String get verifiedSkillLegend => 'যাচাইকৃত ব্যাজ (স্কোর ≥ ২০০)';

  @override
  String get workDetailsTitle => 'কাজের বিবরণ ও পারিশ্রমিক';

  @override
  String get experienceLabel => 'কাজের অভিজ্ঞতা ও দক্ষতা';

  @override
  String get experiencePlaceholder =>
      'যেমন: ৫+ বছর ধরে বাসা-বাড়ির ইলেকট্রিক ওয়্যারিং ও মেরামত...';

  @override
  String get serviceAreaLabel => 'কাজের এলাকা';

  @override
  String get serviceAreaPlaceholder => 'যেমন: মিরপুর, ধানমন্ডি, ঢাকা';

  @override
  String get expectedWageLabel => 'প্রত্যাশিত ঘণ্টাভিত্তিক মজুরি';

  @override
  String get expectedWagePlaceholder => 'যেমন: ৫০০ / ঘণ্টা';

  @override
  String get weeklyAvailabilityTitle => 'সাপ্তাহিক কাজের সময়';

  @override
  String get selectAvailableDays => 'কাজের দিনসমূহ নির্বাচন করুন';

  @override
  String get workingHoursTitle => 'কাজের সময়সূচি';

  @override
  String get startTimeLabel => 'শুরুর সময়';

  @override
  String get endTimeLabel => 'শেষ';

  @override
  String get saveProfile => 'প্রোফাইল সংরক্ষণ করুন';

  @override
  String get profileSavedSuccess => 'প্রোফাইল সফলভাবে সংরক্ষিত হয়েছে';

  @override
  String get selectAtLeastOneSkill => 'অন্তত একটি কাজের দক্ষতা নির্বাচন করুন';

  @override
  String get serviceAreaRequired => 'কাজের এলাকা উল্লেখ করুন';

  @override
  String get wageRequired => 'ঘণ্টাপ্রতি পারিশ্রমিক লিখুন';

  @override
  String get satDay => 'শনি';

  @override
  String get sunDay => 'রবি';

  @override
  String get monDay => 'সোম';

  @override
  String get tueDay => 'মঙ্গল';

  @override
  String get wedDay => 'বুধ';

  @override
  String get thuDay => 'বৃহ';

  @override
  String get friDay => 'শুক্র';

  @override
  String get labourProfileViewTitle => 'শ্রমিক প্রোফাইল';

  @override
  String get activeBadge => 'সক্রিয় ব্যাজ';

  @override
  String get claimedSkill => 'দাবিকৃত';

  @override
  String get scoreLabel => 'স্কোর';

  @override
  String get hourlyRateLabel => 'ঘণ্টাপ্রতি পারিশ্রমিক';

  @override
  String get serviceAreaSectionTitle => 'কাজের এলাকা';

  @override
  String get aboutAndExperienceTitle => 'অভিজ্ঞতা ও বিবরণ';

  @override
  String get availabilitySectionTitle => 'কাজের সময়সূচি';

  @override
  String get editProfileButton => 'প্রোফাইল সম্পাদনা';

  @override
  String get bookLabourButton => 'বুকিং দিন';

  @override
  String get verifiedWorkerBadge => 'যাচাইকৃত শ্রমিক';

  @override
  String get reviewsTitle => 'গ্রাহকদের মূল্যবান মতামত';

  @override
  String get safetyGuaranteeTitle => 'কাজলাগবে নিরাপত্তা ও সুরক্ষা ব্যবস্থা';

  @override
  String get safetyGuaranteeDesc =>
      'আইডেন্টিটি ভেরিফিকেশন কাজের সর্বোচ্চ মান ও নিরাপদ ডিজিটাল লেনদেন নিশ্চিত করে।';

  @override
  String get readyForBooking => 'আজ বুকিংয়ের জন্য প্রস্তুত';

  @override
  String get ratesAndPackagesTitle => 'সেবামূল্য ও চার্জ কাঠামো';

  @override
  String get transparentRatesBadge => 'স্বচ্ছ রেট';

  @override
  String get policeRecordClear => 'পুলিশ রেকর্ড: ক্লিয়ার';

  @override
  String get punctualityScore => '৯৯% সময়ানুবর্তিতা';

  @override
  String get kaajLagbeProBadge => 'কাজলাগবে প্রো';

  @override
  String get bookingComingSoon => 'বুকিং প্রক্রিয়া ফেজ ৫-এ চালু হবে';

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

  @override
  String get locationMirpur => 'মিরপুর ১০, ঢাকা';

  @override
  String goodMorningUser(String name) {
    return 'শুভ সকাল, $name! 👋';
  }

  @override
  String get customerSearchHint => 'আজ কী ধরনের সাহায্য দরকার?';

  @override
  String get nidAssuranceTitle => '১০০% জাতীয় পরিচয়পত্র (NID) যাচাইকৃত';

  @override
  String get nidAssuranceSubtitle =>
      'বিশ্বস্ত ও স্থানীয় কারিগরদের সাথে নিরাপদ সেবা নিশ্চয়তা';

  @override
  String get workerEnRoute => 'কর্মী পথে আছেন (En Route)';

  @override
  String withinMinutes(String minutes) {
    return '⏱ $minutes মিনিটের মধ্যে';
  }

  @override
  String get electricWiringFix => 'ইলেকট্রিক ওয়্যারিং ও শর্ট সার্কিট ফিক্স';

  @override
  String get workerBranchMirpur => 'আইডি: #KL-88219 • মিরপুর শাখা';

  @override
  String get liveTracking => 'লাইভ ট্র্যাকিং';

  @override
  String get callAction => 'কল করুন';

  @override
  String get emergencyDailyServices => 'জরুরি ও দৈনন্দিন সেবা';

  @override
  String get callWorkerInMinutes =>
      'ক্লিক করে কয়েক মিনিটে বিশ্বস্ত কর্মী ডাকুন';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get skillElectrician => 'ইলেকট্রিশিয়ান';

  @override
  String get skillPlumber => 'প্লাম্বিং';

  @override
  String get skillCleaner => 'বাসা পরিষ্কার';

  @override
  String get skillAppliance => 'এসি ও ফ্রিজ';

  @override
  String get skillMoving => 'বাসা বদল';

  @override
  String get skillPainter => 'রং মিস্ত্রি';

  @override
  String get skillCarpenter => 'কাঠমিস্ত্রি';

  @override
  String get skillGeneralHelper => 'দৈনিক সাহায্য';

  @override
  String get promoBannerTitle => 'যেকোনো মেরামতে ৫০৳ ছাড়!';

  @override
  String promoBannerCode(String code) {
    return 'কোড ব্যবহার করুন: $code';
  }

  @override
  String get promoOfferBadge => 'অফার • প্রথম অর্ডার';

  @override
  String get topRatedWorkers => 'জনপ্রিয় কর্মী';

  @override
  String get topRatedWorkersSub =>
      'গ্রাহকদের সর্বোচ্চ রেটিং প্রাপ্ত নির্ভরযোগ্য কর্মী';

  @override
  String get availableIn30Mins => '৩০ মিনিটে এভেইলএবল';

  @override
  String get availableToday => 'আজই সম্ভব';

  @override
  String get perHour => '/ঘণ্টা';

  @override
  String get viewProfileAndBook => 'প্রোফাইল দেখুন ও বুক করুন';

  @override
  String get kaajLagbeSafetyTitle => 'কাজলাগবে সুরক্ষা নিশ্চয়তা';

  @override
  String get safetyNidVerified => 'NID ভেরিফাইড';

  @override
  String get safetyNidVerifiedSub =>
      'প্রত্যেক কর্মীর জাতীয় পরিচয়পত্র ও তথ্য পরীক্ষিত।';

  @override
  String get safetyTransparentRates => 'স্বচ্ছ রেট কার্ড';

  @override
  String get safetyTransparentRatesSub =>
      'কোনো গোপন চার্জ নেই, ন্যায্য মজুরি ও নির্ধারিত রেটে সরাসরি বুকিং।';

  @override
  String get safetyDisputeResolution => 'দ্রুত বিরোধ নিষ্পত্তি';

  @override
  String get safetyDisputeResolutionSub =>
      'সেবায় কোনো অসন্তোষ হলে ২৪/৭ ডেডিকেটেড সাপোর্ট টিম সাথে আছে।';

  @override
  String get safetyEasyRebooking => 'সহজ রি-বুকিং';

  @override
  String get safetyEasyRebookingSub =>
      'পছন্দের কর্মী পুনরায় নির্বাচন করুন মাত্র ১ ট্যাপে।';

  @override
  String get labourPanelTitle => 'শ্রমিক প্যানেল';

  @override
  String get statusOnline => 'অনলাইন';

  @override
  String get statusOffline => 'অফলাইন';

  @override
  String get radarActiveBanner =>
      'বর্তমানে সক্রিয় (Online & Ready for Jobs) • রাডার চালু';

  @override
  String get newJobRequestAlert => 'নতুন কাজের অনুরোধ!';

  @override
  String distanceAway(String distance) {
    return '$distance কিমি দূরে';
  }

  @override
  String get plusTipsOption => '+ টিপস সুবিধা';

  @override
  String get proposedTime => 'প্রস্তাবিত সময়';

  @override
  String get estimatedDuration => 'কাজের সময়সীমা';

  @override
  String get declineAction => 'প্রত্যাখ্যান';

  @override
  String get acceptAction => 'গ্রহণ করুন';

  @override
  String get jobAcceptedMessage =>
      'কাজটি গ্রহণ করা হয়েছে! গ্রাহককে নোটিফিকেশন পাঠানো হয়েছে।';

  @override
  String get todaysEarnings => 'আজকের আয়';

  @override
  String jobsCompletedCount(String count) {
    return '$countটি কাজ সম্পন্ন';
  }

  @override
  String get pendingPayout => 'পেন্ডিং পেআউট';

  @override
  String get payoutProcessing => 'বিকাশ প্রসেসিং';

  @override
  String get weeklyTarget => 'সাপ্তাহিক টার্গেট';

  @override
  String get targetGoal => '৳১০,০০০ লক্ষ্য';

  @override
  String get upcomingSchedule => 'আসন্ন শিডিউল';

  @override
  String get tomorrowSchedule => 'আগামীকাল ১০:০০';

  @override
  String get cashPayment => 'নগদ প্রদান';

  @override
  String get reputationBadgesTitle => 'দক্ষতা ও রেটিং ব্যাজ';

  @override
  String get masterTier => 'মাস্টার টিয়ার';

  @override
  String get wiringSafetyScore => 'ওয়ারিং সেফটি';

  @override
  String get onTimePerformance => 'অন-টাইম সেবা';

  @override
  String get findWorkBannerTitle => 'কাজ খুঁজুন';

  @override
  String get findWorkBannerSub => 'মিরপুর এলাকায় ১২টি নতুন কাজ উপলব্ধ';

  @override
  String get exploreAction => 'দেখুন';

  @override
  String get searchServiceLabel => 'ট্রেড বা সেবা খুঁজুন';

  @override
  String get searchServiceHint => 'ইলেকট্রিশিয়ান, প্লাম্বার ইত্যাদি খুঁজুন';

  @override
  String get radiusPillText => 'মিরপুর ও ধানমণ্ডি (৪.৫ কিমি ব্যাসার্ধ)';

  @override
  String get changeAreaAction => 'পরিবর্তন';

  @override
  String get filterVerifiedOnly => 'যাচাইকৃত শুধু ✓';

  @override
  String get filterRatingHigh => 'রেটিং ৪.৫+ ★';

  @override
  String get filterAvailableToday => 'আজই সম্ভব';

  @override
  String get filterMaxRate => 'সর্বোচ্চ ৳৪০০/ঘণ্টা';

  @override
  String get filterUrgent => 'জরুরি সেবা (Urgent)';

  @override
  String verifiedWorkersFound(String count) {
    return '$count জন যাচাইকৃত কর্মী পাওয়া গেছে';
  }

  @override
  String get onlineBadge => 'অনলাইনে';

  @override
  String get sortPopular => 'সর্ট: জনপ্রিয় ▾';

  @override
  String successRate(String rate) {
    return '$rate% সফল কাজ';
  }

  @override
  String get bookNowAction => 'বুকিং করুন';

  @override
  String get resetFilters => 'ফিল্টার রিসেট';

  @override
  String get noWorkersFoundSub => 'ফিল্টার রিসেট করে আরো ৩২ জন কর্মী দেখুন';

  @override
  String get filterModalTitle => 'স্মার্ট ফিল্টার ও বাজেট';

  @override
  String get maxHourlyRate => 'সর্বোচ্চ ঘণ্টার রেট';

  @override
  String get trustLevelsTitle => 'যাচাইকরণ মাত্রা';

  @override
  String get tradeLicenseCertified => 'ট্রেড লাইসেন্স বা কারিগরি সনদপ্রাপ্ত';

  @override
  String get tradeLicenseCertifiedSub =>
      'ভিটিটিসি বা সরকার অনুমোদিত প্রশিক্ষণ সনদ';

  @override
  String get resetAllAction => 'মুছে ফেলুন (Reset)';

  @override
  String get applyFiltersAction => 'ফলাফল দেখুন';

  @override
  String get previewOnlyMessage =>
      'এই ফিচারটি পরবর্তী ফেজে কার্যকর হবে (প্রিভিউ মোড)';

  @override
  String get navHome => 'হোম';

  @override
  String get navSearch => 'অনুসন্ধান';

  @override
  String get navBookings => 'বুকিং';

  @override
  String get navMessages => 'মেসেজ';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get instantBookingTitle => 'তাৎক্ষণিক বুকিং';

  @override
  String get bookingStepWork => '১. কাজ';

  @override
  String get bookingStepTimeBreak => '২. সময় ও বিরতি';

  @override
  String get bookingStepConfirmation => '৩. নিশ্চিতকরণ';

  @override
  String get selectedServiceLabel => 'নির্বাচিত সেবা';

  @override
  String get serviceAddressLabel => 'কাজের ঠিকানা';

  @override
  String get selectDateTimeTitle => 'তারিখ ও সময় নির্বাচন';

  @override
  String get realtimeSlotBadge => 'রিয়েলটাইম স্লট';

  @override
  String get todayLabel => 'আজ';

  @override
  String get tomorrowLabel => 'আগামীকাল';

  @override
  String get dayAfterLabel => 'পরশু';

  @override
  String workerAvailableFrom(String time) {
    return 'কর্মী উপলব্ধ $time থেকে';
  }

  @override
  String get durationLabel => 'আনুমানিক সময়কাল';

  @override
  String get teaBreakIncluded => '১৫ মিনিট চা বিরতি অন্তর্ভুক্ত';

  @override
  String get teaBreakSub =>
      'কঠোর পরিশ্রমের স্বীকৃতি, পারিশ্রমিক অপরিবর্তিত থাকবে';

  @override
  String get overlapGuardTitle => 'সময়সূচী উপলব্ধ (No Conflict Guard ✓)';

  @override
  String get overlapGuardDesc =>
      'কর্মী দুপুর ২:৩০ পর্যন্ত মিরপুর ২ এ অন্য কাজে ব্যস্ত থাকবেন। আপনি ৩:০০ টায় শিডিউল করায় ৩০ মিনিট নিরাপদ ট্রানজিট বাফার রয়েছে।';

  @override
  String get costBreakdownTitle => 'খরচের বিস্তারিত বিবরণ';

  @override
  String get transparentBilling => 'স্বচ্ছ বিলিং';

  @override
  String get workWageItem => 'কাজের মজুরি (২ ঘণ্টা × ৳৩৫০)';

  @override
  String get platformSafetyFee => 'প্ল্যাটফর্ম সুরক্ষা ও ইন্স্যুরেন্স ফি (৫%)';

  @override
  String get teaBreakFee => 'চা বিরতি ফি';

  @override
  String get freeLabel => 'বিনামূল্যে';

  @override
  String get totalPayable => 'সর্বমোট প্রদেয়';

  @override
  String get payableAfterInspection => 'কাজের পর যাচাই করে পরিশোধযোগ্য';

  @override
  String get kaajlagbeSafetyGuarantee => 'কাজলাগবে সুরক্ষা নিশ্চয়তা';

  @override
  String get safetyGuaranteeBullets =>
      '• কাজ শুরুর ২ ঘণ্টা আগে পর্যন্ত সম্পূর্ণ বিনামূল্যে বাতিল করতে পারবেন।\n• কোনো প্রকার অগ্রিম অর্থ প্রদান করতে হবে না।\n• কাজ সন্তোষজনক না হলে ৭ দিনের ফ্রি রি-ওয়ার্ক সাপোর্ট।';

  @override
  String get bookingTermsAgreement =>
      'আমি কাজলাগবের সেবা নীতি এবং নিরাপত্তা প্রটোকল মেনে কর্মী বুকিং করছি।';

  @override
  String get confirmableBill => 'নিশ্চিতকরণযোগ্য বিল';

  @override
  String get cashOrBkash => 'নগদ/বিকাশ';

  @override
  String get confirmBookingCta => 'বুকিং নিশ্চিত করুন';

  @override
  String get directChatTitle => 'সরাসরি চ্যাট';

  @override
  String bookingCodeLabel(String code) {
    return 'বুকিং #$code';
  }

  @override
  String get confirmedStatus => 'নিশ্চিতকৃত';

  @override
  String totalRateHourly(String rate) {
    return 'মোট (৳$rate/ঘণ্টা)';
  }

  @override
  String get safetyNoticeTitle => 'নিরাপত্তা বার্তা';

  @override
  String get safetyNoticeDesc =>
      'প্ল্যাটফর্মের বাইরে ব্যক্তিগত ফোন নম্বর বা ওটিপি (OTP) শেয়ার করবেন না। সমস্ত লেনদেন কাজলাগবে ডিজিটাল পেমেন্ট সুরক্ষিত।';

  @override
  String get digitalAgreementTitle => 'ডিজিটাল চুক্তিপত্র';

  @override
  String get scopeConfirmationSubtitle => 'কাজের পরিধি ও সময়সূচী নিশ্চিতকরণ';

  @override
  String get agreedBadge => 'সম্মত ✓';

  @override
  String get workDurationLabel => 'কাজের সময়সীমা';

  @override
  String get breakAndPerksLabel => 'বিরতি ও সুবিধা';

  @override
  String get totalRemunerationLabel => 'মোট পারিশ্রমিক';

  @override
  String get noHiddenCharges => 'কোনো গোপন চার্জ নেই';

  @override
  String get securedByKaajlagbe => 'কাজলাগবে ডিজিটাল পেমেন্টে সংরক্ষিত';

  @override
  String get viewFullTerms => 'বিস্তারিত শর্তাবলী';

  @override
  String get quickExtendDuration => 'সময়সীমা বৃদ্ধি';

  @override
  String get quickMaterialsCost => 'অতিরিক্ত মালামাল খরচ';

  @override
  String get quickShareAddress => 'ঠিকানা শেয়ার';

  @override
  String get quickSendPhoto => 'কাজের ছবি পাঠান';

  @override
  String get typeMessagePlaceholder => 'মেসেজ লিখুন...';

  @override
  String get callDirectlyAction => 'সরাসরি কল';

  @override
  String get myBookingsTitle => 'আমার বুকিংসমূহ';

  @override
  String get myBookingsSub => 'বুকিংস ও সেবার ইতিহাস';

  @override
  String totalBookingsCount(String count) {
    return '$countটি মোট';
  }

  @override
  String get tabUpcoming => 'আসন্ন';

  @override
  String get tabInProgress => 'চলমান';

  @override
  String get tabCompleted => 'সম্পন্ন';

  @override
  String get tabCancelled => 'বাতিল ও বিরোধ';

  @override
  String get inProgressBadge => 'কাজ চলছে';

  @override
  String elapsedTimeLabel(String time) {
    return '$time অতিক্রান্ত';
  }

  @override
  String get fixedRateBadge => 'ফিক্সড রেট';

  @override
  String get securePaymentProtected => 'ডিজিটাল পেমেন্ট সুরক্ষিত';

  @override
  String get liveTrackingAction => 'লাইভ ট্র্যাকিং ও টাইমার';

  @override
  String get chatCallAction => 'মেসেজ / সরাসরি কথা';

  @override
  String get nextScheduledWorkTitle => 'পরবর্তী নির্ধারিত কাজ';

  @override
  String viewAllBookings(String count) {
    return 'সবগুলো দেখুন ($count)';
  }

  @override
  String get viewDetailsAction => 'বিস্তারিত দেখুন';

  @override
  String get rescheduleAction => 'রিসিডিউল';

  @override
  String get activeTrackingTitle => 'সরাসরি কাজ ট্র্যাকিং';

  @override
  String get workerOnSiteRibbon => 'কর্মী উপস্থিত';

  @override
  String get onSiteBadge => 'অন-সাইট';

  @override
  String workerArrivedVerified(String name) {
    return '$name উপস্থিত হয়েছেন • ভেরিফাইড';
  }

  @override
  String get workerIdVerification => 'কর্মী পরিচয় যাচাইকরণ';

  @override
  String get verificationComplete => 'যাচাইকৃত ✓';

  @override
  String get fraudPreventionNotice =>
      'কাজ শুরুর পূর্বে বুকিং-নির্দিষ্ট কিউআর ও সিকিউরিটি পিন দ্বারা পরিচয় নিশ্চিত করা হয়।';

  @override
  String get checkInPinTitle => 'চেক-ইন সিকিউরিটি পিন';

  @override
  String get activeCodeLabel => 'অ্যাক্টিভ কোড';

  @override
  String get workerScanLabel => 'কর্মী স্ক্যান';

  @override
  String get liveSessionTracker => 'লাইভ সেশন ট্র্যাকার';

  @override
  String get liveSessionSub => 'কাজের চলমান সময় ও স্থিতি';

  @override
  String get workInProgressBadge => 'কাজ চলমান';

  @override
  String get elapsedTimeHeader => 'অতিক্রান্ত সময়';

  @override
  String get scheduledWindow => 'নির্ধারিত সময়সূচী';

  @override
  String get allocatedDuration => 'বরাদ্দকৃত সময়';

  @override
  String get allocatedDurationValue => '২ ঘণ্টা (১২০ মিনিট)';

  @override
  String get overrunAlertTitle => 'অতিরিক্ত সময়ের নীতি';

  @override
  String get overrunAlertDesc =>
      'বরাদ্দকৃত সময়ের বেশি কাজ হলে প্রতি ৩০ মিনিটে ৳১৭৫ প্রযোজ্য হবে।';

  @override
  String get takeBreakAction => '১৫ মিনিট বিরতি নিন';

  @override
  String get endBreakAction => 'বিরতি শেষ করুন';

  @override
  String get completeJobAction => 'কাজ সম্পন্ন করুন';

  @override
  String get helpDisputeAction => 'অভিযোগ ও সহায়তা';

  @override
  String get liveGeoFenceActive => 'লাইভ জিও-ফেন্স সক্রিয়';

  @override
  String get workerInsideBoundary =>
      'কর্মী কাজের নির্ধারিত এলাকার ভিতরে রয়েছেন';

  @override
  String get securePaymentTitle => 'নিরাপদ পেমেন্ট (স্যান্ডবক্স)';

  @override
  String get securePaymentSub => 'কাজলাগবে সুরক্ষিত ডিজিটাল পেমেন্ট';

  @override
  String get sandboxNotice =>
      'স্যান্ডবক্স মোড: কোন আসল টাকা কাটা হবে না। টেস্ট পেমেন্ট যাচাই করুন।';

  @override
  String get selectPaymentMethod => 'পেমেন্ট মাধ্যম বেছে নিন';

  @override
  String get bkashPayment => 'বিকাশ';

  @override
  String get nagadPayment => 'নগদ';

  @override
  String get cardPayment => 'ক্রেডিট / ডেবিট কার্ড';

  @override
  String get cashOnCompletion => 'কাজ শেষে নগদ';

  @override
  String get paySecurelyCta => 'নিরাপদে পেমেন্ট করুন (স্যান্ডবক্স)';

  @override
  String get disputeTitle => 'অভিযোগ ও বিরোধ নিষ্পত্তি';

  @override
  String get disputeSubtitle => 'সুরক্ষা ডেস্ক ও গ্রাহক সেবা';

  @override
  String get disputeReasonLabel => 'অভিযোগের কারণ';

  @override
  String get selectReasonPlaceholder => 'অভিযোগের ধরণ নির্বাচন করুন';

  @override
  String get reasonQuality => 'কাজের মান সন্তোষজনক নয়';

  @override
  String get reasonOvercharge => 'অতিরিক্ত টাকা দাবি বা অমিল';

  @override
  String get reasonNoShow => 'কর্মী কাজ অসমাপ্ত রেখে চলে গেছেন';

  @override
  String get reasonDamage => 'সম্পদের ক্ষতি বা অসতর্কতা';

  @override
  String get descriptionLabel => 'বিস্তারিত বিবরণ';

  @override
  String get descriptionPlaceholder => 'কী সমস্যা হয়েছে বিস্তারিত লিখুন...';

  @override
  String get uploadEvidenceLabel => 'ছবি বা প্রমাণ সংযুক্ত করুন';

  @override
  String get submitDisputeCta => 'অভিযোগ জমা দিন';

  @override
  String get disputeSubmittedMessage =>
      'অভিযোগ গৃহীত হয়েছে। কাজলাগবে মধ্যস্থতাকারী দল ২ ঘণ্টার মধ্যে পর্যালোচনা করবে।';
}
