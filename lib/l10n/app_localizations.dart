import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In bn, this message translates to:
  /// **'KaajLagbe'**
  String get appName;

  /// No description provided for @verified.
  ///
  /// In bn, this message translates to:
  /// **'ভেরিফাইড'**
  String get verified;

  /// No description provided for @help.
  ///
  /// In bn, this message translates to:
  /// **'হেল্প'**
  String get help;

  /// No description provided for @language.
  ///
  /// In bn, this message translates to:
  /// **'ভাষা'**
  String get language;

  /// No description provided for @bangla.
  ///
  /// In bn, this message translates to:
  /// **'বাং'**
  String get bangla;

  /// No description provided for @english.
  ///
  /// In bn, this message translates to:
  /// **'EN'**
  String get english;

  /// No description provided for @loading.
  ///
  /// In bn, this message translates to:
  /// **'লোড হচ্ছে...'**
  String get loading;

  /// No description provided for @continueAction.
  ///
  /// In bn, this message translates to:
  /// **'এগিয়ে যান'**
  String get continueAction;

  /// No description provided for @save.
  ///
  /// In bn, this message translates to:
  /// **'সংরক্ষণ করুন'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In bn, this message translates to:
  /// **'আবার চেষ্টা করুন'**
  String get retry;

  /// No description provided for @signOut.
  ///
  /// In bn, this message translates to:
  /// **'লগআউট'**
  String get signOut;

  /// No description provided for @currencySymbol.
  ///
  /// In bn, this message translates to:
  /// **'৳'**
  String get currencySymbol;

  /// No description provided for @devModeOtpSkipped.
  ///
  /// In bn, this message translates to:
  /// **'DEV MODE: OTP skipped'**
  String get devModeOtpSkipped;

  /// No description provided for @continueWithoutOtp.
  ///
  /// In bn, this message translates to:
  /// **'Continue without OTP (dev mode)'**
  String get continueWithoutOtp;

  /// No description provided for @splashTagline.
  ///
  /// In bn, this message translates to:
  /// **'দক্ষ ও বিশ্বস্ত শ্রমিকের সবচেয়ে নির্ভরযোগ্য মার্কেটপ্লেস'**
  String get splashTagline;

  /// No description provided for @splashActionGetStarted.
  ///
  /// In bn, this message translates to:
  /// **'সেবা শুরু করুন'**
  String get splashActionGetStarted;

  /// No description provided for @splashVerifiedPros.
  ///
  /// In bn, this message translates to:
  /// **'১০০% ভেরিফাইড কারিগর'**
  String get splashVerifiedPros;

  /// No description provided for @splashSecurePayments.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ লেনদেন'**
  String get splashSecurePayments;

  /// No description provided for @splashConnecting.
  ///
  /// In bn, this message translates to:
  /// **'দক্ষ কারিগর যুক্ত করা হচ্ছে...'**
  String get splashConnecting;

  /// No description provided for @splashLocationDhaka.
  ///
  /// In bn, this message translates to:
  /// **'ঢাকা'**
  String get splashLocationDhaka;

  /// No description provided for @splashLiveService.
  ///
  /// In bn, this message translates to:
  /// **'সরাসরি সেবা'**
  String get splashLiveService;

  /// No description provided for @splashVerifiedProsTagline.
  ///
  /// In bn, this message translates to:
  /// **'বিশ্বস্ত শ্রম ও দক্ষ কর্মী সেবা'**
  String get splashVerifiedProsTagline;

  /// No description provided for @splashMetricNid.
  ///
  /// In bn, this message translates to:
  /// **'১০০% এনআইডি'**
  String get splashMetricNid;

  /// No description provided for @splashMetricNidSub.
  ///
  /// In bn, this message translates to:
  /// **'পরিচয় যাচাইকৃত'**
  String get splashMetricNidSub;

  /// No description provided for @splashMetricFast.
  ///
  /// In bn, this message translates to:
  /// **'১৫ মিনিট'**
  String get splashMetricFast;

  /// No description provided for @splashMetricFastSub.
  ///
  /// In bn, this message translates to:
  /// **'দ্রুত সাড়া'**
  String get splashMetricFastSub;

  /// No description provided for @splashFooterTitle.
  ///
  /// In bn, this message translates to:
  /// **'১০০% ভেরিফাইড কারিগর • স্বচ্ছ মূল্য'**
  String get splashFooterTitle;

  /// No description provided for @splashFooterSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'জাতীয় পরিচয়পত্র ও কাজের মান যাচাইকৃত'**
  String get splashFooterSubtitle;

  /// No description provided for @loginWelcome.
  ///
  /// In bn, this message translates to:
  /// **'স্বাগতম!'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'লগইন বা রেজিস্ট্রেশন করতে আপনার মোবাইল নম্বর দিন'**
  String get loginSubtitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর *'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In bn, this message translates to:
  /// **'17XXXXXXXX'**
  String get phoneNumberHint;

  /// No description provided for @phoneHelperText.
  ///
  /// In bn, this message translates to:
  /// **'আমরা এই নম্বরে একটি ৬-সংখ্যার ওটিপি কোড পাঠাব'**
  String get phoneHelperText;

  /// No description provided for @sendOtp.
  ///
  /// In bn, this message translates to:
  /// **'ওটিপি পাঠান'**
  String get sendOtp;

  /// No description provided for @workerTogglePromptCustomer.
  ///
  /// In bn, this message translates to:
  /// **'দক্ষ কাজের কারিগর বা টেকনিশিয়ান?'**
  String get workerTogglePromptCustomer;

  /// No description provided for @workerToggleActionWorker.
  ///
  /// In bn, this message translates to:
  /// **'শ্রমিক হিসেবে যুক্ত হন'**
  String get workerToggleActionWorker;

  /// No description provided for @workerTogglePromptWorker.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহক হিসেবে সেবা নিতে চান?'**
  String get workerTogglePromptWorker;

  /// No description provided for @workerToggleActionCustomer.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহক লগইন'**
  String get workerToggleActionCustomer;

  /// No description provided for @phoneErrorEmpty.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর লিখুন'**
  String get phoneErrorEmpty;

  /// No description provided for @phoneErrorInvalidPrefix.
  ///
  /// In bn, this message translates to:
  /// **'বাংলাদেশি নম্বর ১ দিয়ে শুরু হতে হবে (যেমন: 17XXXXXXXX)'**
  String get phoneErrorInvalidPrefix;

  /// No description provided for @phoneErrorInvalidLength.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক ১০-সংখ্যার নম্বর দিন (যেমন: 17XXXXXXXX)'**
  String get phoneErrorInvalidLength;

  /// No description provided for @otpSendError.
  ///
  /// In bn, this message translates to:
  /// **'ওটিপি পাঠাতে সমস্যা হয়েছে। ইন্টারনেট সংযোগ ও নম্বর পরীক্ষা করুন।'**
  String get otpSendError;

  /// No description provided for @authErrorPhoneProviderDisabled.
  ///
  /// In bn, this message translates to:
  /// **'ফোন ওটিপি প্রোভাইডার নিষ্ক্রিয়। Supabase ড্যাশবোর্ডে Phone প্রোভাইডার চালু করুন অথবা টেস্ট নম্বর ব্যবহার করুন।'**
  String get authErrorPhoneProviderDisabled;

  /// No description provided for @authErrorSmsSendFailed.
  ///
  /// In bn, this message translates to:
  /// **'এসএমএস গেটওয়ে থেকে ওটিপি কোড পাঠানো যায়নি। এসএমএস প্রোভাইডার সেটিংস বা ব্যালেন্স পরীক্ষা করুন।'**
  String get authErrorSmsSendFailed;

  /// No description provided for @authErrorRateLimit.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপত্তার স্বার্থে ওটিপি পাঠানোর সীমা অতিক্রান্ত হয়েছে। অনুগ্রহ করে কিছুক্ষণ অপেক্ষা করে আবার চেষ্টা করুন।'**
  String get authErrorRateLimit;

  /// No description provided for @authErrorInvalidPhone.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বরটি সঠিক নয়। অনুগ্রহ করে ১০-সংখ্যার সঠিক বাংলাদেশি নম্বর লিখুন (যেমন: 17XXXXXXXX)।'**
  String get authErrorInvalidPhone;

  /// No description provided for @authErrorNetworkOffline.
  ///
  /// In bn, this message translates to:
  /// **'ইন্টারনেট সংযোগ পাওয়া যায়নি। আপনার মোবাইল ডাটা বা ওয়াই-ফাই সংযোগ পরীক্ষা করুন।'**
  String get authErrorNetworkOffline;

  /// No description provided for @demoQuickFillTitle.
  ///
  /// In bn, this message translates to:
  /// **'ডেমো অ্যাকাউন্ট কুইক-ফিল'**
  String get demoQuickFillTitle;

  /// No description provided for @devLoginError.
  ///
  /// In bn, this message translates to:
  /// **'ডেভ মোড লগইনে সমস্যা হয়েছে। Supabase ইমেইল প্রোভাইডার চেক করুন।'**
  String get devLoginError;

  /// No description provided for @identityVerificationTitle.
  ///
  /// In bn, this message translates to:
  /// **'জাতীয় পরিচয়পত্র যাচাই'**
  String get identityVerificationTitle;

  /// No description provided for @identityVerificationSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'বুকিং সুবিধা ও বিশ্বস্ততা বৃদ্ধির জন্য জাতীয় পরিচয়পত্র বা পাসপোর্ট যাচাই করুন'**
  String get identityVerificationSubtitle;

  /// No description provided for @docTypeLabel.
  ///
  /// In bn, this message translates to:
  /// **'ডকুমেন্টের ধরন'**
  String get docTypeLabel;

  /// No description provided for @docTypeNid.
  ///
  /// In bn, this message translates to:
  /// **'জাতীয় পরিচয়পত্র'**
  String get docTypeNid;

  /// No description provided for @docTypePassport.
  ///
  /// In bn, this message translates to:
  /// **'পাসপোর্ট'**
  String get docTypePassport;

  /// No description provided for @docNumberLabel.
  ///
  /// In bn, this message translates to:
  /// **'ডকুমেন্ট নম্বর'**
  String get docNumberLabel;

  /// No description provided for @docNumberPlaceholder.
  ///
  /// In bn, this message translates to:
  /// **'১০ বা ১৭ সংখ্যার নম্বর লিখুন'**
  String get docNumberPlaceholder;

  /// No description provided for @docNumberPassportPlaceholder.
  ///
  /// In bn, this message translates to:
  /// **'পাসপোর্ট নম্বর লিখুন'**
  String get docNumberPassportPlaceholder;

  /// No description provided for @uploadPhotosTitle.
  ///
  /// In bn, this message translates to:
  /// **'ডকুমেন্টের ছবি আপলোড'**
  String get uploadPhotosTitle;

  /// No description provided for @uploadFrontPhoto.
  ///
  /// In bn, this message translates to:
  /// **'সামনের পাতার ছবি'**
  String get uploadFrontPhoto;

  /// No description provided for @uploadFrontPhotoSub.
  ///
  /// In bn, this message translates to:
  /// **'নাম, জন্ম তারিখ ও ছবি স্পষ্ট হতে হবে'**
  String get uploadFrontPhotoSub;

  /// No description provided for @uploadBackPhoto.
  ///
  /// In bn, this message translates to:
  /// **'পেছনের পাতার ছবি'**
  String get uploadBackPhoto;

  /// No description provided for @uploadBackPhotoSub.
  ///
  /// In bn, this message translates to:
  /// **'ঠিকানা ও বারকোড পরিষ্কার রাখুন'**
  String get uploadBackPhotoSub;

  /// No description provided for @uploadSelfie.
  ///
  /// In bn, this message translates to:
  /// **'ডকুমেন্টসহ সেলফি'**
  String get uploadSelfie;

  /// No description provided for @uploadSelfieSub.
  ///
  /// In bn, this message translates to:
  /// **'চেহারা ও কার্ডের লেখা স্পষ্ট রাখুন'**
  String get uploadSelfieSub;

  /// No description provided for @privacyTrustNotice.
  ///
  /// In bn, this message translates to:
  /// **'আপনার তথ্য সম্পূর্ণ সুরক্ষিত ও এনক্রিপ্টেড। শুধুমাত্র পরিচয় যাচাইকরণের কাজে ব্যবহৃত হয়।'**
  String get privacyTrustNotice;

  /// No description provided for @submitVerification.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইয়ের জন্য জমা দিন'**
  String get submitVerification;

  /// No description provided for @verificationStatusNotSubmitted.
  ///
  /// In bn, this message translates to:
  /// **'এখনও জমা দেওয়া হয়নি'**
  String get verificationStatusNotSubmitted;

  /// No description provided for @verificationStatusPending.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই প্রক্রিয়াধীন (১-৪ ঘণ্টা)'**
  String get verificationStatusPending;

  /// No description provided for @verificationStatusApproved.
  ///
  /// In bn, this message translates to:
  /// **'পরিচয়পত্র অনুমোদিত'**
  String get verificationStatusApproved;

  /// No description provided for @verificationStatusRejected.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকরণ প্রত্যাখ্যাত হয়েছে'**
  String get verificationStatusRejected;

  /// No description provided for @verificationSubmittedSuccess.
  ///
  /// In bn, this message translates to:
  /// **'পরিচয়পত্র সফলভাবে জমা দেওয়া হয়েছে। পর্যালোচনার পর জানানো হবে।'**
  String get verificationSubmittedSuccess;

  /// No description provided for @selectFileAction.
  ///
  /// In bn, this message translates to:
  /// **'ছবি তুলুন বা ফাইল নির্বাচন করুন'**
  String get selectFileAction;

  /// No description provided for @fileSelected.
  ///
  /// In bn, this message translates to:
  /// **'ছবি নির্বাচিত হয়েছে'**
  String get fileSelected;

  /// No description provided for @fileRequiredError.
  ///
  /// In bn, this message translates to:
  /// **'সবগুলো প্রয়োজনীয় ছবি আপলোড করুন'**
  String get fileRequiredError;

  /// No description provided for @docNumberRequiredError.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক ডকুমেন্ট নম্বর দিন'**
  String get docNumberRequiredError;

  /// No description provided for @viewOrSubmitVerification.
  ///
  /// In bn, this message translates to:
  /// **'পরিচয়পত্র যাচাইকরণে যান'**
  String get viewOrSubmitVerification;

  /// No description provided for @identityVerificationNav.
  ///
  /// In bn, this message translates to:
  /// **'জাতীয় পরিচয়পত্র যাচাই'**
  String get identityVerificationNav;

  /// No description provided for @labourProfileSetupTitle.
  ///
  /// In bn, this message translates to:
  /// **'শ্রমিক প্রোফাইল সেটআপ'**
  String get labourProfileSetupTitle;

  /// No description provided for @labourProfileSetupSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজের দক্ষতা, এলাকা ও পারিশ্রমিক নির্ধারণ করুন'**
  String get labourProfileSetupSubtitle;

  /// No description provided for @profilePhotoSectionTitle.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল ছবি'**
  String get profilePhotoSectionTitle;

  /// No description provided for @profilePhotoHelperText.
  ///
  /// In bn, this message translates to:
  /// **'পরিষ্কার ও প্রফেশনাল ছবি আপলোড করুন'**
  String get profilePhotoHelperText;

  /// No description provided for @skillsAndBadgesTitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজের দক্ষতা ও ব্যাজ'**
  String get skillsAndBadgesTitle;

  /// No description provided for @claimedSkillLegend.
  ///
  /// In bn, this message translates to:
  /// **'দাবিকৃত (যাচাই অপেক্ষমাণ)'**
  String get claimedSkillLegend;

  /// No description provided for @verifiedSkillLegend.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত ব্যাজ (স্কোর ≥ ২০০)'**
  String get verifiedSkillLegend;

  /// No description provided for @workDetailsTitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজের বিবরণ ও পারিশ্রমিক'**
  String get workDetailsTitle;

  /// No description provided for @experienceLabel.
  ///
  /// In bn, this message translates to:
  /// **'কাজের অভিজ্ঞতা ও দক্ষতা'**
  String get experienceLabel;

  /// No description provided for @experiencePlaceholder.
  ///
  /// In bn, this message translates to:
  /// **'যেমন: ৫+ বছর ধরে বাসা-বাড়ির ইলেকট্রিক ওয়্যারিং ও মেরামত...'**
  String get experiencePlaceholder;

  /// No description provided for @serviceAreaLabel.
  ///
  /// In bn, this message translates to:
  /// **'কাজের এলাকা'**
  String get serviceAreaLabel;

  /// No description provided for @serviceAreaPlaceholder.
  ///
  /// In bn, this message translates to:
  /// **'যেমন: মিরপুর, ধানমন্ডি, ঢাকা'**
  String get serviceAreaPlaceholder;

  /// No description provided for @expectedWageLabel.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাশিত ঘণ্টাভিত্তিক মজুরি'**
  String get expectedWageLabel;

  /// No description provided for @expectedWagePlaceholder.
  ///
  /// In bn, this message translates to:
  /// **'যেমন: ৫০০ / ঘণ্টা'**
  String get expectedWagePlaceholder;

  /// No description provided for @weeklyAvailabilityTitle.
  ///
  /// In bn, this message translates to:
  /// **'সাপ্তাহিক কাজের সময়'**
  String get weeklyAvailabilityTitle;

  /// No description provided for @selectAvailableDays.
  ///
  /// In bn, this message translates to:
  /// **'কাজের দিনসমূহ নির্বাচন করুন'**
  String get selectAvailableDays;

  /// No description provided for @workingHoursTitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজের সময়সূচি'**
  String get workingHoursTitle;

  /// No description provided for @startTimeLabel.
  ///
  /// In bn, this message translates to:
  /// **'শুরুর সময়'**
  String get startTimeLabel;

  /// No description provided for @endTimeLabel.
  ///
  /// In bn, this message translates to:
  /// **'শেষ'**
  String get endTimeLabel;

  /// No description provided for @saveProfile.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল সংরক্ষণ করুন'**
  String get saveProfile;

  /// No description provided for @profileSavedSuccess.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল সফলভাবে সংরক্ষিত হয়েছে'**
  String get profileSavedSuccess;

  /// No description provided for @selectAtLeastOneSkill.
  ///
  /// In bn, this message translates to:
  /// **'অন্তত একটি কাজের দক্ষতা নির্বাচন করুন'**
  String get selectAtLeastOneSkill;

  /// No description provided for @serviceAreaRequired.
  ///
  /// In bn, this message translates to:
  /// **'কাজের এলাকা উল্লেখ করুন'**
  String get serviceAreaRequired;

  /// No description provided for @wageRequired.
  ///
  /// In bn, this message translates to:
  /// **'ঘণ্টাপ্রতি পারিশ্রমিক লিখুন'**
  String get wageRequired;

  /// No description provided for @satDay.
  ///
  /// In bn, this message translates to:
  /// **'শনি'**
  String get satDay;

  /// No description provided for @sunDay.
  ///
  /// In bn, this message translates to:
  /// **'রবি'**
  String get sunDay;

  /// No description provided for @monDay.
  ///
  /// In bn, this message translates to:
  /// **'সোম'**
  String get monDay;

  /// No description provided for @tueDay.
  ///
  /// In bn, this message translates to:
  /// **'মঙ্গল'**
  String get tueDay;

  /// No description provided for @wedDay.
  ///
  /// In bn, this message translates to:
  /// **'বুধ'**
  String get wedDay;

  /// No description provided for @thuDay.
  ///
  /// In bn, this message translates to:
  /// **'বৃহ'**
  String get thuDay;

  /// No description provided for @friDay.
  ///
  /// In bn, this message translates to:
  /// **'শুক্র'**
  String get friDay;

  /// No description provided for @labourProfileViewTitle.
  ///
  /// In bn, this message translates to:
  /// **'শ্রমিক প্রোফাইল'**
  String get labourProfileViewTitle;

  /// No description provided for @activeBadge.
  ///
  /// In bn, this message translates to:
  /// **'সক্রিয় ব্যাজ'**
  String get activeBadge;

  /// No description provided for @claimedSkill.
  ///
  /// In bn, this message translates to:
  /// **'দাবিকৃত'**
  String get claimedSkill;

  /// No description provided for @scoreLabel.
  ///
  /// In bn, this message translates to:
  /// **'স্কোর'**
  String get scoreLabel;

  /// No description provided for @hourlyRateLabel.
  ///
  /// In bn, this message translates to:
  /// **'ঘণ্টাপ্রতি পারিশ্রমিক'**
  String get hourlyRateLabel;

  /// No description provided for @serviceAreaSectionTitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজের এলাকা'**
  String get serviceAreaSectionTitle;

  /// No description provided for @aboutAndExperienceTitle.
  ///
  /// In bn, this message translates to:
  /// **'অভিজ্ঞতা ও বিবরণ'**
  String get aboutAndExperienceTitle;

  /// No description provided for @availabilitySectionTitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজের সময়সূচি'**
  String get availabilitySectionTitle;

  /// No description provided for @editProfileButton.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল সম্পাদনা'**
  String get editProfileButton;

  /// No description provided for @bookLabourButton.
  ///
  /// In bn, this message translates to:
  /// **'বুকিং দিন'**
  String get bookLabourButton;

  /// No description provided for @verifiedWorkerBadge.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত শ্রমিক'**
  String get verifiedWorkerBadge;

  /// No description provided for @reviewsTitle.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহকদের মূল্যবান মতামত'**
  String get reviewsTitle;

  /// No description provided for @safetyGuaranteeTitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজলাগবে শতভাগ নিরাপত্তা গ্যারান্টি'**
  String get safetyGuaranteeTitle;

  /// No description provided for @safetyGuaranteeDesc.
  ///
  /// In bn, this message translates to:
  /// **'আইডেন্টিটি ভেরিফিকেশন কাজের সর্বোচ্চ মান ও নিরাপদ ডিজিটাল লেনদেন নিশ্চিত করে।'**
  String get safetyGuaranteeDesc;

  /// No description provided for @readyForBooking.
  ///
  /// In bn, this message translates to:
  /// **'আজ বুকিংয়ের জন্য প্রস্তুত'**
  String get readyForBooking;

  /// No description provided for @ratesAndPackagesTitle.
  ///
  /// In bn, this message translates to:
  /// **'সেবামূল্য ও চার্জ কাঠামো'**
  String get ratesAndPackagesTitle;

  /// No description provided for @transparentRatesBadge.
  ///
  /// In bn, this message translates to:
  /// **'স্বচ্ছ রেট'**
  String get transparentRatesBadge;

  /// No description provided for @policeRecordClear.
  ///
  /// In bn, this message translates to:
  /// **'পুলিশ রেকর্ড: ক্লিয়ার'**
  String get policeRecordClear;

  /// No description provided for @punctualityScore.
  ///
  /// In bn, this message translates to:
  /// **'৯৯% সময়ানুবর্তিতা'**
  String get punctualityScore;

  /// No description provided for @kaajLagbeProBadge.
  ///
  /// In bn, this message translates to:
  /// **'কাজলাগবে প্রো'**
  String get kaajLagbeProBadge;

  /// No description provided for @bookingComingSoon.
  ///
  /// In bn, this message translates to:
  /// **'বুকিং প্রক্রিয়া ফেজ ৫-এ চালু হবে'**
  String get bookingComingSoon;

  /// No description provided for @trustSecurityTitle.
  ///
  /// In bn, this message translates to:
  /// **'সুরক্ষিত ও নির্ভরযোগ্য সেবা'**
  String get trustSecurityTitle;

  /// No description provided for @trustSecuritySubtitle.
  ///
  /// In bn, this message translates to:
  /// **'সকল শ্রমিকের জাতীয় পরিচয়পত্র ও কাজের দক্ষতা যাচাইকৃত'**
  String get trustSecuritySubtitle;

  /// No description provided for @termsAgreementText.
  ///
  /// In bn, this message translates to:
  /// **'এগিয়ে যাওয়ার মাধ্যমে আপনি KaajLagbe-এর নিয়ম ও শর্তাবলী এবং গোপনীয়তা নীতি মেনে নিচ্ছেন।'**
  String get termsAgreementText;

  /// No description provided for @phoneSecurityBannerTitle.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত ও নিরাপদ প্ল্যাটফর্ম'**
  String get phoneSecurityBannerTitle;

  /// No description provided for @phoneSecurityBannerSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'১০০% জাতীয় পরিচয়পত্র (NID) যাচাইকৃত প্ল্যাটফর্ম'**
  String get phoneSecurityBannerSubtitle;

  /// No description provided for @otpTitle.
  ///
  /// In bn, this message translates to:
  /// **'ওটিপি যাচাইকরণ'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'{phone} নম্বরে পাঠানো ৬-সংখ্যার কোডটি প্রবেশ করুন'**
  String otpSubtitle(String phone);

  /// No description provided for @otpResendIn.
  ///
  /// In bn, this message translates to:
  /// **'পুনরায় কোড পাঠান ({seconds} সেকেন্ড)'**
  String otpResendIn(String seconds);

  /// No description provided for @otpResendAction.
  ///
  /// In bn, this message translates to:
  /// **'কোড পাননি? পুনরায় পাঠান'**
  String get otpResendAction;

  /// No description provided for @verifyAndProceed.
  ///
  /// In bn, this message translates to:
  /// **'যাচাই করুন ও এগিয়ে যান'**
  String get verifyAndProceed;

  /// No description provided for @changeNumber.
  ///
  /// In bn, this message translates to:
  /// **'নম্বর পরিবর্তন করুন'**
  String get changeNumber;

  /// No description provided for @otpInvalidLength.
  ///
  /// In bn, this message translates to:
  /// **'সম্পূর্ণ ৬-সংখ্যার ওটিপি কোড দিন'**
  String get otpInvalidLength;

  /// No description provided for @otpVerificationError.
  ///
  /// In bn, this message translates to:
  /// **'ভুল ওটিপি কোড অথবা কোডের মেয়াদ শেষ হয়েছে।'**
  String get otpVerificationError;

  /// No description provided for @otpResentSuccess.
  ///
  /// In bn, this message translates to:
  /// **'নতুন ওটিপি কোড পাঠানো হয়েছে।'**
  String get otpResentSuccess;

  /// No description provided for @otpEditNumber.
  ///
  /// In bn, this message translates to:
  /// **'এডিট'**
  String get otpEditNumber;

  /// No description provided for @otpInputPrompt.
  ///
  /// In bn, this message translates to:
  /// **'৬-সংখ্যার ওটিপি লিখুন'**
  String get otpInputPrompt;

  /// No description provided for @otpResendCodePrompt.
  ///
  /// In bn, this message translates to:
  /// **'ওটিপি পাননি?'**
  String get otpResendCodePrompt;

  /// No description provided for @otpResendActionSms.
  ///
  /// In bn, this message translates to:
  /// **'এসএমএস পুনরায় পাঠান'**
  String get otpResendActionSms;

  /// No description provided for @otpResendFailed.
  ///
  /// In bn, this message translates to:
  /// **'ওটিপি পুনরায় পাঠাতে সমস্যা হয়েছে। একটু পর চেষ্টা করুন।'**
  String get otpResendFailed;

  /// No description provided for @otpSecuritySafe.
  ///
  /// In bn, this message translates to:
  /// **'১০০% নিরাপদ যাচাইকরণ'**
  String get otpSecuritySafe;

  /// No description provided for @otpSecurityNid.
  ///
  /// In bn, this message translates to:
  /// **'NID পরীক্ষিত প্ল্যাটফর্ম'**
  String get otpSecurityNid;

  /// No description provided for @roleSelectionTitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার ভূমিকা নির্বাচন করুন'**
  String get roleSelectionTitle;

  /// No description provided for @roleSelectionSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনি কীভাবে KaajLagbe ব্যবহার করতে চান?'**
  String get roleSelectionSubtitle;

  /// No description provided for @roleSelectionTrustBadge.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপদ ও সহজ শুরু'**
  String get roleSelectionTrustBadge;

  /// No description provided for @customerRoleTitle.
  ///
  /// In bn, this message translates to:
  /// **'আমার সেবা প্রয়োজন'**
  String get customerRoleTitle;

  /// No description provided for @customerRoleSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'বাসা বা অফিসের কাজের জন্য যাচাইকৃত ও বিশ্বস্ত কর্মী খুঁজে নিন ও বুক করুন'**
  String get customerRoleSubtitle;

  /// No description provided for @customerRoleBadge.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহক'**
  String get customerRoleBadge;

  /// No description provided for @customerPerk1.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত দক্ষ কর্মী'**
  String get customerPerk1;

  /// No description provided for @customerPerk2.
  ///
  /// In bn, this message translates to:
  /// **'স্বচ্ছ রেট ও সরাসরি বুকিং'**
  String get customerPerk2;

  /// No description provided for @labourRoleTitle.
  ///
  /// In bn, this message translates to:
  /// **'আমি কাজ করতে চাই'**
  String get labourRoleTitle;

  /// No description provided for @labourRoleSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার দক্ষতা যোগ করুন, সরাসরি বুকিং পান এবং আয় বৃদ্ধি করুন'**
  String get labourRoleSubtitle;

  /// No description provided for @labourRoleBadge.
  ///
  /// In bn, this message translates to:
  /// **'কর্মী'**
  String get labourRoleBadge;

  /// No description provided for @labourPerk1.
  ///
  /// In bn, this message translates to:
  /// **'সরাসরি পেমেন্ট'**
  String get labourPerk1;

  /// No description provided for @labourPerk2.
  ///
  /// In bn, this message translates to:
  /// **'নতুন কাজের নিয়মিত সুযোগ'**
  String get labourPerk2;

  /// No description provided for @selectRoleError.
  ///
  /// In bn, this message translates to:
  /// **'অনুগ্রহ করে একটি ভূমিকা নির্বাচন করুন'**
  String get selectRoleError;

  /// No description provided for @roleAdminBlockedError.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাডমিন ভূমিকা নির্বাচনযোগ্য নয়'**
  String get roleAdminBlockedError;

  /// No description provided for @roleSaveError.
  ///
  /// In bn, this message translates to:
  /// **'ভূমিকা সংরক্ষণ করতে সমস্যা হয়েছে। ইন্টারনেট সংযোগ পরীক্ষা করুন।'**
  String get roleSaveError;

  /// No description provided for @profileSetupTitle.
  ///
  /// In bn, this message translates to:
  /// **'আপনার প্রোফাইল সাজান'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'সঠিক তথ্য দিলে সেবা পেতে ও দিতে সুবিধা হবে'**
  String get profileSetupSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In bn, this message translates to:
  /// **'আপনার পূর্ণ নাম *'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In bn, this message translates to:
  /// **'জাতীয় পরিচয়পত্র অনুযায়ী নাম'**
  String get fullNameHint;

  /// No description provided for @fullNameErrorEmpty.
  ///
  /// In bn, this message translates to:
  /// **'আপনার পূর্ণ নাম লিখুন'**
  String get fullNameErrorEmpty;

  /// No description provided for @fullNameErrorTooShort.
  ///
  /// In bn, this message translates to:
  /// **'নাম কমপক্ষে ৩ অক্ষরের হতে হবে'**
  String get fullNameErrorTooShort;

  /// No description provided for @uploadPhoto.
  ///
  /// In bn, this message translates to:
  /// **'ছবি আপলোড করুন'**
  String get uploadPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In bn, this message translates to:
  /// **'ছবি পরিবর্তন'**
  String get changePhoto;

  /// No description provided for @avatarSelected.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাভাটার যুক্ত করা হয়েছে'**
  String get avatarSelected;

  /// No description provided for @saveAndContinue.
  ///
  /// In bn, this message translates to:
  /// **'সংরক্ষণ করুন ও এগিয়ে যান'**
  String get saveAndContinue;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল ও সেটিংস'**
  String get profileSettingsTitle;

  /// No description provided for @accountInfo.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্টের তথ্য'**
  String get accountInfo;

  /// No description provided for @appSettings.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাপ সেটিংস'**
  String get appSettings;

  /// No description provided for @editName.
  ///
  /// In bn, this message translates to:
  /// **'নাম পরিবর্তন করুন'**
  String get editName;

  /// No description provided for @editNameHint.
  ///
  /// In bn, this message translates to:
  /// **'পূর্ণ নাম লিখুন'**
  String get editNameHint;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In bn, this message translates to:
  /// **'নাম খালি রাখা যাবে না'**
  String get nameCannotBeEmpty;

  /// No description provided for @nidVerifiedBadge.
  ///
  /// In bn, this message translates to:
  /// **'জাতীয় পরিচয়পত্র যাচাইকৃত'**
  String get nidVerifiedBadge;

  /// No description provided for @nidVerifiedSub.
  ///
  /// In bn, this message translates to:
  /// **'NID Verified Citizen • সর্বোচ্চ নিরাপত্তা স্তর'**
  String get nidVerifiedSub;

  /// No description provided for @totalBookings.
  ///
  /// In bn, this message translates to:
  /// **'মোট বুকিং'**
  String get totalBookings;

  /// No description provided for @savedAddresses.
  ///
  /// In bn, this message translates to:
  /// **'সেভ করা ঠিকানা'**
  String get savedAddresses;

  /// No description provided for @balance.
  ///
  /// In bn, this message translates to:
  /// **'ব্যালেন্স'**
  String get balance;

  /// No description provided for @accountAndPlacesSection.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্ট ও ঠিকানা'**
  String get accountAndPlacesSection;

  /// No description provided for @savedAddressesTitle.
  ///
  /// In bn, this message translates to:
  /// **'সংরক্ষিত ঠিকানাসমূহ'**
  String get savedAddressesTitle;

  /// No description provided for @savedAddressesSub.
  ///
  /// In bn, this message translates to:
  /// **'বাসা: মিরপুর ১০, ঢাকা'**
  String get savedAddressesSub;

  /// No description provided for @paymentMethodsTitle.
  ///
  /// In bn, this message translates to:
  /// **'পেমেন্ট মেথড ও লেনদেন হিস্ট্রি'**
  String get paymentMethodsTitle;

  /// No description provided for @paymentMethodsSub.
  ///
  /// In bn, this message translates to:
  /// **'বিকাশ / নগদ / কার্ড'**
  String get paymentMethodsSub;

  /// No description provided for @safetyAndPolicySection.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপত্তা ও নীতি'**
  String get safetyAndPolicySection;

  /// No description provided for @emergencyContactTitle.
  ///
  /// In bn, this message translates to:
  /// **'জরুরি যোগাযোগ ও নিরাপত্তা সেন্টার'**
  String get emergencyContactTitle;

  /// No description provided for @emergencyContactSub.
  ///
  /// In bn, this message translates to:
  /// **'জরুরি হেল্পলাইন ও লাইভ ট্র্যাকিং'**
  String get emergencyContactSub;

  /// No description provided for @changeLanguageTitle.
  ///
  /// In bn, this message translates to:
  /// **'ভাষা পরিবর্তন'**
  String get changeLanguageTitle;

  /// No description provided for @changeLanguageSub.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাপের ভাষা নির্বাচন করুন'**
  String get changeLanguageSub;

  /// No description provided for @privacyAndTermsTitle.
  ///
  /// In bn, this message translates to:
  /// **'গোপনীয়তা ও টার্মস অব সার্ভিস'**
  String get privacyAndTermsTitle;

  /// No description provided for @privacyAndTermsSub.
  ///
  /// In bn, this message translates to:
  /// **'ব্যবহারকারীর তথ্য সুরক্ষা নীতি'**
  String get privacyAndTermsSub;

  /// No description provided for @helpAndSupportSection.
  ///
  /// In bn, this message translates to:
  /// **'সহায়তা ও অভিযোগ'**
  String get helpAndSupportSection;

  /// No description provided for @helpCenterTitle.
  ///
  /// In bn, this message translates to:
  /// **'হেল্প সেন্টার ও কাস্টমার কেয়ার'**
  String get helpCenterTitle;

  /// No description provided for @helpCenterSub.
  ///
  /// In bn, this message translates to:
  /// **'হটলাইন ১৬৪২০ অথবা লাইভ চ্যাট (২৪/৭)'**
  String get helpCenterSub;

  /// No description provided for @disputesTitle.
  ///
  /// In bn, this message translates to:
  /// **'আমার বিরোধ ও অভিযোগের স্ট্যাটাস'**
  String get disputesTitle;

  /// No description provided for @disputesSub.
  ///
  /// In bn, this message translates to:
  /// **'সক্রিয় বিরোধসমূহ ট্র্যাকিং'**
  String get disputesSub;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল সফলভাবে আপডেট হয়েছে'**
  String get profileUpdateSuccess;

  /// No description provided for @profileUpdateError.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল সংরক্ষণে সমস্যা হয়েছে'**
  String get profileUpdateError;

  /// No description provided for @statusPendingTitle.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকরণ প্রক্রিয়াধীন'**
  String get statusPendingTitle;

  /// No description provided for @statusPendingDescription.
  ///
  /// In bn, this message translates to:
  /// **'আপনার পরিচয়পত্র ও তথ্যাদি আমাদের অ্যাডমিন টিম যাচাই করছে। সাধারণত ১২-২৪ ঘণ্টার মধ্যে যাচাই সম্পন্ন হয়।'**
  String get statusPendingDescription;

  /// No description provided for @statusApprovedTitle.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্ট অনুমোদিত'**
  String get statusApprovedTitle;

  /// No description provided for @statusApprovedDescription.
  ///
  /// In bn, this message translates to:
  /// **'আপনার অ্যাকাউন্ট সক্রিয় রয়েছে।'**
  String get statusApprovedDescription;

  /// No description provided for @statusRejectedTitle.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকরণ বাতিল হয়েছে'**
  String get statusRejectedTitle;

  /// No description provided for @statusRejectedDescription.
  ///
  /// In bn, this message translates to:
  /// **'আপনার প্রদানকৃত তথ্যে ত্রুটির কারণে আবেদনটি অনুমোদিত হয়নি।'**
  String get statusRejectedDescription;

  /// No description provided for @statusSuspendedTitle.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্ট স্থগিত'**
  String get statusSuspendedTitle;

  /// No description provided for @statusSuspendedDescription.
  ///
  /// In bn, this message translates to:
  /// **'নিয়ম লঙ্ঘনের কারণে আপনার অ্যাকাউন্টটি সাময়িকভাবে স্থগিত করা হয়েছে।'**
  String get statusSuspendedDescription;

  /// No description provided for @statusBannedTitle.
  ///
  /// In bn, this message translates to:
  /// **'স্থায়ীভাবে নিষিদ্ধ'**
  String get statusBannedTitle;

  /// No description provided for @statusBannedDescription.
  ///
  /// In bn, this message translates to:
  /// **'গুরুতর নীতিমালা লঙ্ঘনের কারণে এই অ্যাকাউন্টটি স্থায়ীভাবে নিষ্ক্রিয় করা হয়েছে।'**
  String get statusBannedDescription;

  /// No description provided for @rejectionReasonLabel.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল করার কারণ:'**
  String get rejectionReasonLabel;

  /// No description provided for @resubmitVerification.
  ///
  /// In bn, this message translates to:
  /// **'পুনরায় যাচাইয়ের আবেদন করুন'**
  String get resubmitVerification;

  /// No description provided for @contactSupport.
  ///
  /// In bn, this message translates to:
  /// **'সাপোর্টে যোগাযোগ করুন'**
  String get contactSupport;

  /// No description provided for @refreshStatus.
  ///
  /// In bn, this message translates to:
  /// **'রিফ্রেশ'**
  String get refreshStatus;

  /// No description provided for @refreshingStatus.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাকাউন্টের সর্বশেষ অবস্থা যাচাই করা হচ্ছে...'**
  String get refreshingStatus;

  /// No description provided for @verificationProgress.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকরণ অগ্রগতি'**
  String get verificationProgress;

  /// No description provided for @progressStepPhone.
  ///
  /// In bn, this message translates to:
  /// **'মোবাইল নম্বর ও ওটিপি যাচাই'**
  String get progressStepPhone;

  /// No description provided for @progressStepPhoneSub.
  ///
  /// In bn, this message translates to:
  /// **'সফলভাবে সম্পন্ন হয়েছে'**
  String get progressStepPhoneSub;

  /// No description provided for @progressStepReview.
  ///
  /// In bn, this message translates to:
  /// **'প্রশাসনিক পর্যালোচনা ও NID অনুমোদন'**
  String get progressStepReview;

  /// No description provided for @progressStepReviewSub.
  ///
  /// In bn, this message translates to:
  /// **'অ্যাডমিন টিম নথিপত্র পরীক্ষা করছে (১২-২৪ ঘণ্টা)'**
  String get progressStepReviewSub;

  /// No description provided for @progressStepAccess.
  ///
  /// In bn, this message translates to:
  /// **'মার্কেটপ্লেস প্রবেশাধিকার'**
  String get progressStepAccess;

  /// No description provided for @progressStepAccessSub.
  ///
  /// In bn, this message translates to:
  /// **'অনুমোদনের পর সম্পূর্ণ সেবা উন্মুক্ত হবে'**
  String get progressStepAccessSub;

  /// No description provided for @marketplaceProtectionTitle.
  ///
  /// In bn, this message translates to:
  /// **'মার্কেটপ্লেস সুরক্ষা নীতি'**
  String get marketplaceProtectionTitle;

  /// No description provided for @marketplaceProtectionSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'অননুমোদিত বা স্থগিত অ্যাকাউন্ট দ্বারা সেবা অনুসন্ধান, কর্মী বুকিং বা কাজ গ্রহণ সম্পূর্ণ ব্লক রাখা হয়।'**
  String get marketplaceProtectionSubtitle;

  /// No description provided for @checkStatusAction.
  ///
  /// In bn, this message translates to:
  /// **'স্ট্যাটাস রিফ্রেশ করুন'**
  String get checkStatusAction;

  /// No description provided for @homeTitle.
  ///
  /// In bn, this message translates to:
  /// **'হোম'**
  String get homeTitle;

  /// No description provided for @welcomeUser.
  ///
  /// In bn, this message translates to:
  /// **'স্বাগতম, {name}'**
  String welcomeUser(String name);

  /// No description provided for @homePlaceholderCustomer.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহক মার্কেটপ্লেস ও শ্রমিক খোঁজার পৃষ্ঠা শীঘ্রই আসছে।'**
  String get homePlaceholderCustomer;

  /// No description provided for @homePlaceholderLabour.
  ///
  /// In bn, this message translates to:
  /// **'শ্রমিক ড্যাশবোর্ড ও কাজের তালিকা শীঘ্রই আসছে।'**
  String get homePlaceholderLabour;

  /// No description provided for @profileAndSettings.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল ও সেটিংস'**
  String get profileAndSettings;

  /// No description provided for @locationMirpur.
  ///
  /// In bn, this message translates to:
  /// **'মিরপুর ১০, ঢাকা'**
  String get locationMirpur;

  /// No description provided for @goodMorningUser.
  ///
  /// In bn, this message translates to:
  /// **'শুভ সকাল, {name}! 👋'**
  String goodMorningUser(String name);

  /// No description provided for @customerSearchHint.
  ///
  /// In bn, this message translates to:
  /// **'আজ কী ধরনের সাহায্য দরকার?'**
  String get customerSearchHint;

  /// No description provided for @nidAssuranceTitle.
  ///
  /// In bn, this message translates to:
  /// **'১০০% জাতীয় পরিচয়পত্র (NID) যাচাইকৃত'**
  String get nidAssuranceTitle;

  /// No description provided for @nidAssuranceSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'বিশ্বস্ত ও স্থানীয় কারিগরদের সাথে নিরাপদ সেবা নিশ্চয়তা'**
  String get nidAssuranceSubtitle;

  /// No description provided for @workerEnRoute.
  ///
  /// In bn, this message translates to:
  /// **'কর্মী পথে আছেন (En Route)'**
  String get workerEnRoute;

  /// No description provided for @withinMinutes.
  ///
  /// In bn, this message translates to:
  /// **'⏱ {minutes} মিনিটের মধ্যে'**
  String withinMinutes(String minutes);

  /// No description provided for @electricWiringFix.
  ///
  /// In bn, this message translates to:
  /// **'ইলেকট্রিক ওয়্যারিং ও শর্ট সার্কিট ফিক্স'**
  String get electricWiringFix;

  /// No description provided for @workerBranchMirpur.
  ///
  /// In bn, this message translates to:
  /// **'আইডি: #KL-88219 • মিরপুর শাখা'**
  String get workerBranchMirpur;

  /// No description provided for @liveTracking.
  ///
  /// In bn, this message translates to:
  /// **'লাইভ ট্র্যাকিং'**
  String get liveTracking;

  /// No description provided for @callAction.
  ///
  /// In bn, this message translates to:
  /// **'কল করুন'**
  String get callAction;

  /// No description provided for @emergencyDailyServices.
  ///
  /// In bn, this message translates to:
  /// **'জরুরি ও দৈনন্দিন সেবা'**
  String get emergencyDailyServices;

  /// No description provided for @callWorkerInMinutes.
  ///
  /// In bn, this message translates to:
  /// **'ক্লিক করে কয়েক মিনিটে বিশ্বস্ত কর্মী ডাকুন'**
  String get callWorkerInMinutes;

  /// No description provided for @viewAll.
  ///
  /// In bn, this message translates to:
  /// **'সব দেখুন'**
  String get viewAll;

  /// No description provided for @skillElectrician.
  ///
  /// In bn, this message translates to:
  /// **'ইলেকট্রিশিয়ান'**
  String get skillElectrician;

  /// No description provided for @skillPlumber.
  ///
  /// In bn, this message translates to:
  /// **'প্লাম্বিং'**
  String get skillPlumber;

  /// No description provided for @skillCleaner.
  ///
  /// In bn, this message translates to:
  /// **'বাসা পরিষ্কার'**
  String get skillCleaner;

  /// No description provided for @skillAppliance.
  ///
  /// In bn, this message translates to:
  /// **'এসি ও ফ্রিজ'**
  String get skillAppliance;

  /// No description provided for @skillMoving.
  ///
  /// In bn, this message translates to:
  /// **'বাসা বদল'**
  String get skillMoving;

  /// No description provided for @skillPainter.
  ///
  /// In bn, this message translates to:
  /// **'রং মিস্ত্রি'**
  String get skillPainter;

  /// No description provided for @skillCarpenter.
  ///
  /// In bn, this message translates to:
  /// **'কাঠমিস্ত্রি'**
  String get skillCarpenter;

  /// No description provided for @skillGeneralHelper.
  ///
  /// In bn, this message translates to:
  /// **'দৈনিক সাহায্য'**
  String get skillGeneralHelper;

  /// No description provided for @promoBannerTitle.
  ///
  /// In bn, this message translates to:
  /// **'যেকোনো মেরামতে ৫০৳ ছাড়!'**
  String get promoBannerTitle;

  /// No description provided for @promoBannerCode.
  ///
  /// In bn, this message translates to:
  /// **'কোড ব্যবহার করুন: {code}'**
  String promoBannerCode(String code);

  /// No description provided for @promoOfferBadge.
  ///
  /// In bn, this message translates to:
  /// **'অফার • প্রথম অর্ডার'**
  String get promoOfferBadge;

  /// No description provided for @topRatedWorkers.
  ///
  /// In bn, this message translates to:
  /// **'জনপ্রিয় কর্মী'**
  String get topRatedWorkers;

  /// No description provided for @topRatedWorkersSub.
  ///
  /// In bn, this message translates to:
  /// **'গ্রাহকদের সর্বোচ্চ রেটিং প্রাপ্ত নির্ভরযোগ্য কর্মী'**
  String get topRatedWorkersSub;

  /// No description provided for @availableIn30Mins.
  ///
  /// In bn, this message translates to:
  /// **'৩০ মিনিটে এভেইলএবল'**
  String get availableIn30Mins;

  /// No description provided for @availableToday.
  ///
  /// In bn, this message translates to:
  /// **'আজই সম্ভব'**
  String get availableToday;

  /// No description provided for @perHour.
  ///
  /// In bn, this message translates to:
  /// **'/ঘণ্টা'**
  String get perHour;

  /// No description provided for @viewProfileAndBook.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল দেখুন ও বুক করুন'**
  String get viewProfileAndBook;

  /// No description provided for @kaajLagbeSafetyTitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজলাগবে সুরক্ষা নিশ্চয়তা'**
  String get kaajLagbeSafetyTitle;

  /// No description provided for @safetyNidVerified.
  ///
  /// In bn, this message translates to:
  /// **'NID ভেরিফাইড'**
  String get safetyNidVerified;

  /// No description provided for @safetyNidVerifiedSub.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যেক কর্মীর আসল বায়োমেট্রিক ও জাতীয় পরিচয়পত্র পরীক্ষিত।'**
  String get safetyNidVerifiedSub;

  /// No description provided for @safetyTransparentRates.
  ///
  /// In bn, this message translates to:
  /// **'স্বচ্ছ রেট কার্ড'**
  String get safetyTransparentRates;

  /// No description provided for @safetyTransparentRatesSub.
  ///
  /// In bn, this message translates to:
  /// **'কোনো গোপন চার্জ নেই, ন্যায্য মজুরি ও নির্ধারিত রেটে সরাসরি বুকিং।'**
  String get safetyTransparentRatesSub;

  /// No description provided for @safetyDisputeResolution.
  ///
  /// In bn, this message translates to:
  /// **'দ্রুত বিরোধ নিষ্পত্তি'**
  String get safetyDisputeResolution;

  /// No description provided for @safetyDisputeResolutionSub.
  ///
  /// In bn, this message translates to:
  /// **'সেবায় কোনো অসন্তোষ হলে ২৪/৭ ডেডিকেটেড সাপোর্ট টিম সাথে আছে।'**
  String get safetyDisputeResolutionSub;

  /// No description provided for @safetyEasyRebooking.
  ///
  /// In bn, this message translates to:
  /// **'সহজ রি-বুকিং'**
  String get safetyEasyRebooking;

  /// No description provided for @safetyEasyRebookingSub.
  ///
  /// In bn, this message translates to:
  /// **'পছন্দের কর্মী পুনরায় নির্বাচন করুন মাত্র ১ ট্যাপে।'**
  String get safetyEasyRebookingSub;

  /// No description provided for @labourPanelTitle.
  ///
  /// In bn, this message translates to:
  /// **'শ্রমিক প্যানেল'**
  String get labourPanelTitle;

  /// No description provided for @statusOnline.
  ///
  /// In bn, this message translates to:
  /// **'অনলাইন'**
  String get statusOnline;

  /// No description provided for @statusOffline.
  ///
  /// In bn, this message translates to:
  /// **'অফলাইন'**
  String get statusOffline;

  /// No description provided for @radarActiveBanner.
  ///
  /// In bn, this message translates to:
  /// **'বর্তমানে সক্রিয় (Online & Ready for Jobs) • রাডার চালু'**
  String get radarActiveBanner;

  /// No description provided for @newJobRequestAlert.
  ///
  /// In bn, this message translates to:
  /// **'নতুন কাজের অনুরোধ!'**
  String get newJobRequestAlert;

  /// No description provided for @distanceAway.
  ///
  /// In bn, this message translates to:
  /// **'{distance} কিমি দূরে'**
  String distanceAway(String distance);

  /// No description provided for @plusTipsOption.
  ///
  /// In bn, this message translates to:
  /// **'+ টিপস সুবিধা'**
  String get plusTipsOption;

  /// No description provided for @proposedTime.
  ///
  /// In bn, this message translates to:
  /// **'প্রস্তাবিত সময়'**
  String get proposedTime;

  /// No description provided for @estimatedDuration.
  ///
  /// In bn, this message translates to:
  /// **'কাজের সময়সীমা'**
  String get estimatedDuration;

  /// No description provided for @declineAction.
  ///
  /// In bn, this message translates to:
  /// **'প্রত্যাখ্যান'**
  String get declineAction;

  /// No description provided for @acceptAction.
  ///
  /// In bn, this message translates to:
  /// **'গ্রহণ করুন'**
  String get acceptAction;

  /// No description provided for @jobAcceptedMessage.
  ///
  /// In bn, this message translates to:
  /// **'কাজটি গ্রহণ করা হয়েছে! গ্রাহককে নোটিফিকেশন পাঠানো হয়েছে।'**
  String get jobAcceptedMessage;

  /// No description provided for @todaysEarnings.
  ///
  /// In bn, this message translates to:
  /// **'আজকের আয়'**
  String get todaysEarnings;

  /// No description provided for @jobsCompletedCount.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি কাজ সম্পন্ন'**
  String jobsCompletedCount(String count);

  /// No description provided for @pendingPayout.
  ///
  /// In bn, this message translates to:
  /// **'পেন্ডিং পেআউট'**
  String get pendingPayout;

  /// No description provided for @payoutProcessing.
  ///
  /// In bn, this message translates to:
  /// **'বিকাশ প্রসেসিং'**
  String get payoutProcessing;

  /// No description provided for @weeklyTarget.
  ///
  /// In bn, this message translates to:
  /// **'সাপ্তাহিক টার্গেট'**
  String get weeklyTarget;

  /// No description provided for @targetGoal.
  ///
  /// In bn, this message translates to:
  /// **'৳১০,০০০ লক্ষ্য'**
  String get targetGoal;

  /// No description provided for @upcomingSchedule.
  ///
  /// In bn, this message translates to:
  /// **'আসন্ন শিডিউল'**
  String get upcomingSchedule;

  /// No description provided for @tomorrowSchedule.
  ///
  /// In bn, this message translates to:
  /// **'আগামীকাল ১০:০০'**
  String get tomorrowSchedule;

  /// No description provided for @cashPayment.
  ///
  /// In bn, this message translates to:
  /// **'নগদ প্রদান'**
  String get cashPayment;

  /// No description provided for @reputationBadgesTitle.
  ///
  /// In bn, this message translates to:
  /// **'দক্ষতা ও রেটিং ব্যাজ'**
  String get reputationBadgesTitle;

  /// No description provided for @masterTier.
  ///
  /// In bn, this message translates to:
  /// **'মাস্টার টিয়ার'**
  String get masterTier;

  /// No description provided for @wiringSafetyScore.
  ///
  /// In bn, this message translates to:
  /// **'ওয়ারিং সেফটি'**
  String get wiringSafetyScore;

  /// No description provided for @onTimePerformance.
  ///
  /// In bn, this message translates to:
  /// **'অন-টাইম সেবা'**
  String get onTimePerformance;

  /// No description provided for @findWorkBannerTitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজ খুঁজুন'**
  String get findWorkBannerTitle;

  /// No description provided for @findWorkBannerSub.
  ///
  /// In bn, this message translates to:
  /// **'মিরপুর এলাকায় ১২টি নতুন কাজ উপলব্ধ'**
  String get findWorkBannerSub;

  /// No description provided for @exploreAction.
  ///
  /// In bn, this message translates to:
  /// **'দেখুন'**
  String get exploreAction;

  /// No description provided for @searchServiceLabel.
  ///
  /// In bn, this message translates to:
  /// **'ট্রেড বা সেবা খুঁজুন'**
  String get searchServiceLabel;

  /// No description provided for @searchServiceHint.
  ///
  /// In bn, this message translates to:
  /// **'ইলেকট্রিশিয়ান, প্লাম্বার ইত্যাদি খুঁজুন'**
  String get searchServiceHint;

  /// No description provided for @radiusPillText.
  ///
  /// In bn, this message translates to:
  /// **'মিরপুর ও ধানমণ্ডি (৪.৫ কিমি ব্যাসার্ধ)'**
  String get radiusPillText;

  /// No description provided for @changeAreaAction.
  ///
  /// In bn, this message translates to:
  /// **'পরিবর্তন'**
  String get changeAreaAction;

  /// No description provided for @filterVerifiedOnly.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকৃত শুধু ✓'**
  String get filterVerifiedOnly;

  /// No description provided for @filterRatingHigh.
  ///
  /// In bn, this message translates to:
  /// **'রেটিং ৪.৫+ ★'**
  String get filterRatingHigh;

  /// No description provided for @filterAvailableToday.
  ///
  /// In bn, this message translates to:
  /// **'আজই সম্ভব'**
  String get filterAvailableToday;

  /// No description provided for @filterMaxRate.
  ///
  /// In bn, this message translates to:
  /// **'সর্বোচ্চ ৳৪০০/ঘণ্টা'**
  String get filterMaxRate;

  /// No description provided for @filterUrgent.
  ///
  /// In bn, this message translates to:
  /// **'জরুরি সেবা (Urgent)'**
  String get filterUrgent;

  /// No description provided for @verifiedWorkersFound.
  ///
  /// In bn, this message translates to:
  /// **'{count} জন যাচাইকৃত কর্মী পাওয়া গেছে'**
  String verifiedWorkersFound(String count);

  /// No description provided for @onlineBadge.
  ///
  /// In bn, this message translates to:
  /// **'অনলাইনে'**
  String get onlineBadge;

  /// No description provided for @sortPopular.
  ///
  /// In bn, this message translates to:
  /// **'সর্ট: জনপ্রিয় ▾'**
  String get sortPopular;

  /// No description provided for @successRate.
  ///
  /// In bn, this message translates to:
  /// **'{rate}% সফল কাজ'**
  String successRate(String rate);

  /// No description provided for @bookNowAction.
  ///
  /// In bn, this message translates to:
  /// **'বুকিং করুন'**
  String get bookNowAction;

  /// No description provided for @resetFilters.
  ///
  /// In bn, this message translates to:
  /// **'ফিল্টার রিসেট'**
  String get resetFilters;

  /// No description provided for @noWorkersFoundSub.
  ///
  /// In bn, this message translates to:
  /// **'ফিল্টার রিসেট করে আরো ৩২ জন কর্মী দেখুন'**
  String get noWorkersFoundSub;

  /// No description provided for @filterModalTitle.
  ///
  /// In bn, this message translates to:
  /// **'স্মার্ট ফিল্টার ও বাজেট'**
  String get filterModalTitle;

  /// No description provided for @maxHourlyRate.
  ///
  /// In bn, this message translates to:
  /// **'সর্বোচ্চ ঘণ্টার রেট'**
  String get maxHourlyRate;

  /// No description provided for @trustLevelsTitle.
  ///
  /// In bn, this message translates to:
  /// **'যাচাইকরণ মাত্রা'**
  String get trustLevelsTitle;

  /// No description provided for @tradeLicenseCertified.
  ///
  /// In bn, this message translates to:
  /// **'ট্রেড লাইসেন্স বা কারিগরি সনদপ্রাপ্ত'**
  String get tradeLicenseCertified;

  /// No description provided for @tradeLicenseCertifiedSub.
  ///
  /// In bn, this message translates to:
  /// **'ভিটিটিসি বা সরকার অনুমোদিত প্রশিক্ষণ সনদ'**
  String get tradeLicenseCertifiedSub;

  /// No description provided for @resetAllAction.
  ///
  /// In bn, this message translates to:
  /// **'মুছে ফেলুন (Reset)'**
  String get resetAllAction;

  /// No description provided for @applyFiltersAction.
  ///
  /// In bn, this message translates to:
  /// **'ফলাফল দেখুন'**
  String get applyFiltersAction;

  /// No description provided for @previewOnlyMessage.
  ///
  /// In bn, this message translates to:
  /// **'এই ফিচারটি পরবর্তী ফেজে কার্যকর হবে (প্রিভিউ মোড)'**
  String get previewOnlyMessage;

  /// No description provided for @navHome.
  ///
  /// In bn, this message translates to:
  /// **'হোম'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In bn, this message translates to:
  /// **'অনুসন্ধান'**
  String get navSearch;

  /// No description provided for @navBookings.
  ///
  /// In bn, this message translates to:
  /// **'বুকিং'**
  String get navBookings;

  /// No description provided for @navMessages.
  ///
  /// In bn, this message translates to:
  /// **'মেসেজ'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In bn, this message translates to:
  /// **'প্রোফাইল'**
  String get navProfile;

  /// No description provided for @instantBookingTitle.
  ///
  /// In bn, this message translates to:
  /// **'তাৎক্ষণিক বুকিং'**
  String get instantBookingTitle;

  /// No description provided for @bookingStepWork.
  ///
  /// In bn, this message translates to:
  /// **'১. কাজ'**
  String get bookingStepWork;

  /// No description provided for @bookingStepTimeBreak.
  ///
  /// In bn, this message translates to:
  /// **'২. সময় ও বিরতি'**
  String get bookingStepTimeBreak;

  /// No description provided for @bookingStepConfirmation.
  ///
  /// In bn, this message translates to:
  /// **'৩. নিশ্চিতকরণ'**
  String get bookingStepConfirmation;

  /// No description provided for @selectedServiceLabel.
  ///
  /// In bn, this message translates to:
  /// **'নির্বাচিত সেবা'**
  String get selectedServiceLabel;

  /// No description provided for @serviceAddressLabel.
  ///
  /// In bn, this message translates to:
  /// **'কাজের ঠিকানা'**
  String get serviceAddressLabel;

  /// No description provided for @selectDateTimeTitle.
  ///
  /// In bn, this message translates to:
  /// **'তারিখ ও সময় নির্বাচন'**
  String get selectDateTimeTitle;

  /// No description provided for @realtimeSlotBadge.
  ///
  /// In bn, this message translates to:
  /// **'রিয়েলটাইম স্লট'**
  String get realtimeSlotBadge;

  /// No description provided for @todayLabel.
  ///
  /// In bn, this message translates to:
  /// **'আজ'**
  String get todayLabel;

  /// No description provided for @tomorrowLabel.
  ///
  /// In bn, this message translates to:
  /// **'আগামীকাল'**
  String get tomorrowLabel;

  /// No description provided for @dayAfterLabel.
  ///
  /// In bn, this message translates to:
  /// **'পরশু'**
  String get dayAfterLabel;

  /// No description provided for @workerAvailableFrom.
  ///
  /// In bn, this message translates to:
  /// **'কর্মী উপলব্ধ {time} থেকে'**
  String workerAvailableFrom(String time);

  /// No description provided for @durationLabel.
  ///
  /// In bn, this message translates to:
  /// **'আনুমানিক সময়কাল'**
  String get durationLabel;

  /// No description provided for @teaBreakIncluded.
  ///
  /// In bn, this message translates to:
  /// **'১৫ মিনিট চা বিরতি অন্তর্ভুক্ত'**
  String get teaBreakIncluded;

  /// No description provided for @teaBreakSub.
  ///
  /// In bn, this message translates to:
  /// **'কঠোর পরিশ্রমের স্বীকৃতি, পারিশ্রমিক অপরিবর্তিত থাকবে'**
  String get teaBreakSub;

  /// No description provided for @overlapGuardTitle.
  ///
  /// In bn, this message translates to:
  /// **'সময়সূচী উপলব্ধ (No Conflict Guard ✓)'**
  String get overlapGuardTitle;

  /// No description provided for @overlapGuardDesc.
  ///
  /// In bn, this message translates to:
  /// **'কর্মী দুপুর ২:৩০ পর্যন্ত মিরপুর ২ এ অন্য কাজে ব্যস্ত থাকবেন। আপনি ৩:০০ টায় শিডিউল করায় ৩০ মিনিট নিরাপদ ট্রানজিট বাফার রয়েছে।'**
  String get overlapGuardDesc;

  /// No description provided for @costBreakdownTitle.
  ///
  /// In bn, this message translates to:
  /// **'খরচের বিস্তারিত বিবরণ'**
  String get costBreakdownTitle;

  /// No description provided for @transparentBilling.
  ///
  /// In bn, this message translates to:
  /// **'স্বচ্ছ বিলিং'**
  String get transparentBilling;

  /// No description provided for @workWageItem.
  ///
  /// In bn, this message translates to:
  /// **'কাজের মজুরি (২ ঘণ্টা × ৳৩৫০)'**
  String get workWageItem;

  /// No description provided for @platformSafetyFee.
  ///
  /// In bn, this message translates to:
  /// **'প্ল্যাটফর্ম সুরক্ষা ও ইন্স্যুরেন্স ফি (৫%)'**
  String get platformSafetyFee;

  /// No description provided for @teaBreakFee.
  ///
  /// In bn, this message translates to:
  /// **'চা বিরতি ফি'**
  String get teaBreakFee;

  /// No description provided for @freeLabel.
  ///
  /// In bn, this message translates to:
  /// **'বিনামূল্যে'**
  String get freeLabel;

  /// No description provided for @totalPayable.
  ///
  /// In bn, this message translates to:
  /// **'সর্বমোট প্রদেয়'**
  String get totalPayable;

  /// No description provided for @payableAfterInspection.
  ///
  /// In bn, this message translates to:
  /// **'কাজের পর যাচাই করে পরিশোধযোগ্য'**
  String get payableAfterInspection;

  /// No description provided for @kaajlagbeSafetyGuarantee.
  ///
  /// In bn, this message translates to:
  /// **'কাজলাগবে সুরক্ষা নিশ্চয়তা'**
  String get kaajlagbeSafetyGuarantee;

  /// No description provided for @safetyGuaranteeBullets.
  ///
  /// In bn, this message translates to:
  /// **'• কাজ শুরুর ২ ঘণ্টা আগে পর্যন্ত সম্পূর্ণ বিনামূল্যে বাতিল করতে পারবেন।\n• কোনো প্রকার অগ্রিম অর্থ প্রদান করতে হবে না।\n• কাজ সন্তোষজনক না হলে ৭ দিনের ফ্রি রি-ওয়ার্ক গ্যারান্টি।'**
  String get safetyGuaranteeBullets;

  /// No description provided for @bookingTermsAgreement.
  ///
  /// In bn, this message translates to:
  /// **'আমি কাজলাগবের সেবা নীতি এবং নিরাপত্তা প্রটোকল মেনে কর্মী বুকিং করছি।'**
  String get bookingTermsAgreement;

  /// No description provided for @confirmableBill.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিতকরণযোগ্য বিল'**
  String get confirmableBill;

  /// No description provided for @cashOrBkash.
  ///
  /// In bn, this message translates to:
  /// **'নগদ/বিকাশ'**
  String get cashOrBkash;

  /// No description provided for @confirmBookingCta.
  ///
  /// In bn, this message translates to:
  /// **'বুকিং নিশ্চিত করুন'**
  String get confirmBookingCta;

  /// No description provided for @directChatTitle.
  ///
  /// In bn, this message translates to:
  /// **'সরাসরি চ্যাট'**
  String get directChatTitle;

  /// No description provided for @bookingCodeLabel.
  ///
  /// In bn, this message translates to:
  /// **'বুকিং #{code}'**
  String bookingCodeLabel(String code);

  /// No description provided for @confirmedStatus.
  ///
  /// In bn, this message translates to:
  /// **'নিশ্চিতকৃত'**
  String get confirmedStatus;

  /// No description provided for @totalRateHourly.
  ///
  /// In bn, this message translates to:
  /// **'মোট (৳{rate}/ঘণ্টা)'**
  String totalRateHourly(String rate);

  /// No description provided for @safetyNoticeTitle.
  ///
  /// In bn, this message translates to:
  /// **'নিরাপত্তা বার্তা'**
  String get safetyNoticeTitle;

  /// No description provided for @safetyNoticeDesc.
  ///
  /// In bn, this message translates to:
  /// **'প্ল্যাটফর্মের বাইরে ব্যক্তিগত ফোন নম্বর বা ওটিপি (OTP) শেয়ার করবেন না। সমস্ত লেনদেন কাজলাগবে ডিজিটাল পেমেন্ট সুরক্ষিত।'**
  String get safetyNoticeDesc;

  /// No description provided for @digitalAgreementTitle.
  ///
  /// In bn, this message translates to:
  /// **'ডিজিটাল চুক্তিপত্র'**
  String get digitalAgreementTitle;

  /// No description provided for @scopeConfirmationSubtitle.
  ///
  /// In bn, this message translates to:
  /// **'কাজের পরিধি ও সময়সূচী নিশ্চিতকরণ'**
  String get scopeConfirmationSubtitle;

  /// No description provided for @agreedBadge.
  ///
  /// In bn, this message translates to:
  /// **'সম্মত ✓'**
  String get agreedBadge;

  /// No description provided for @workDurationLabel.
  ///
  /// In bn, this message translates to:
  /// **'কাজের সময়সীমা'**
  String get workDurationLabel;

  /// No description provided for @breakAndPerksLabel.
  ///
  /// In bn, this message translates to:
  /// **'বিরতি ও সুবিধা'**
  String get breakAndPerksLabel;

  /// No description provided for @totalRemunerationLabel.
  ///
  /// In bn, this message translates to:
  /// **'মোট পারিশ্রমিক'**
  String get totalRemunerationLabel;

  /// No description provided for @noHiddenCharges.
  ///
  /// In bn, this message translates to:
  /// **'কোনো গোপন চার্জ নেই'**
  String get noHiddenCharges;

  /// No description provided for @securedByKaajlagbe.
  ///
  /// In bn, this message translates to:
  /// **'কাজলাগবে ডিজিটাল পেমেন্টে সংরক্ষিত'**
  String get securedByKaajlagbe;

  /// No description provided for @viewFullTerms.
  ///
  /// In bn, this message translates to:
  /// **'বিস্তারিত শর্তাবলী'**
  String get viewFullTerms;

  /// No description provided for @quickExtendDuration.
  ///
  /// In bn, this message translates to:
  /// **'সময়সীমা বৃদ্ধি'**
  String get quickExtendDuration;

  /// No description provided for @quickMaterialsCost.
  ///
  /// In bn, this message translates to:
  /// **'অতিরিক্ত মালামাল খরচ'**
  String get quickMaterialsCost;

  /// No description provided for @quickShareAddress.
  ///
  /// In bn, this message translates to:
  /// **'ঠিকানা শেয়ার'**
  String get quickShareAddress;

  /// No description provided for @quickSendPhoto.
  ///
  /// In bn, this message translates to:
  /// **'কাজের ছবি পাঠান'**
  String get quickSendPhoto;

  /// No description provided for @typeMessagePlaceholder.
  ///
  /// In bn, this message translates to:
  /// **'মেসেজ লিখুন...'**
  String get typeMessagePlaceholder;

  /// No description provided for @callDirectlyAction.
  ///
  /// In bn, this message translates to:
  /// **'সরাসরি কল'**
  String get callDirectlyAction;

  /// No description provided for @myBookingsTitle.
  ///
  /// In bn, this message translates to:
  /// **'আমার বুকিংসমূহ'**
  String get myBookingsTitle;

  /// No description provided for @myBookingsSub.
  ///
  /// In bn, this message translates to:
  /// **'বুকিংস ও সেবার ইতিহাস'**
  String get myBookingsSub;

  /// No description provided for @totalBookingsCount.
  ///
  /// In bn, this message translates to:
  /// **'{count}টি মোট'**
  String totalBookingsCount(String count);

  /// No description provided for @tabUpcoming.
  ///
  /// In bn, this message translates to:
  /// **'আসন্ন'**
  String get tabUpcoming;

  /// No description provided for @tabInProgress.
  ///
  /// In bn, this message translates to:
  /// **'চলমান'**
  String get tabInProgress;

  /// No description provided for @tabCompleted.
  ///
  /// In bn, this message translates to:
  /// **'সম্পন্ন'**
  String get tabCompleted;

  /// No description provided for @tabCancelled.
  ///
  /// In bn, this message translates to:
  /// **'বাতিল ও বিরোধ'**
  String get tabCancelled;

  /// No description provided for @inProgressBadge.
  ///
  /// In bn, this message translates to:
  /// **'কাজ চলছে'**
  String get inProgressBadge;

  /// No description provided for @elapsedTimeLabel.
  ///
  /// In bn, this message translates to:
  /// **'{time} অতিক্রান্ত'**
  String elapsedTimeLabel(String time);

  /// No description provided for @fixedRateBadge.
  ///
  /// In bn, this message translates to:
  /// **'ফিক্সড রেট'**
  String get fixedRateBadge;

  /// No description provided for @securePaymentProtected.
  ///
  /// In bn, this message translates to:
  /// **'ডিজিটাল পেমেন্ট সুরক্ষিত'**
  String get securePaymentProtected;

  /// No description provided for @liveTrackingAction.
  ///
  /// In bn, this message translates to:
  /// **'লাইভ ট্র্যাকিং ও টাইমার'**
  String get liveTrackingAction;

  /// No description provided for @chatCallAction.
  ///
  /// In bn, this message translates to:
  /// **'মেসেজ / সরাসরি কথা'**
  String get chatCallAction;

  /// No description provided for @nextScheduledWorkTitle.
  ///
  /// In bn, this message translates to:
  /// **'পরবর্তী নির্ধারিত কাজ'**
  String get nextScheduledWorkTitle;

  /// No description provided for @viewAllBookings.
  ///
  /// In bn, this message translates to:
  /// **'সবগুলো দেখুন ({count})'**
  String viewAllBookings(String count);

  /// No description provided for @viewDetailsAction.
  ///
  /// In bn, this message translates to:
  /// **'বিস্তারিত দেখুন'**
  String get viewDetailsAction;

  /// No description provided for @rescheduleAction.
  ///
  /// In bn, this message translates to:
  /// **'রিসিডিউল'**
  String get rescheduleAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
