import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/utils/auth_error_resolver.dart';
import 'package:kaajlagbe/l10n/app_localizations_bn.dart';
import 'package:kaajlagbe/l10n/app_localizations_en.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final l10nBn = AppLocalizationsBn();
  final l10nEn = AppLocalizationsEn();

  group('AuthErrorResolver Unit Tests', () {
    test('Maps phone provider disabled AuthException correctly', () {
      final errorByCode = AuthException('Provider error', code: 'phone_provider_disabled');
      final errorByMsg = AuthException('Phone provider is disabled for this project');

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nBn), l10nBn.authErrorPhoneProviderDisabled);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nEn), l10nEn.authErrorPhoneProviderDisabled);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nBn), l10nBn.authErrorPhoneProviderDisabled);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nEn), l10nEn.authErrorPhoneProviderDisabled);
    });

    test('Maps SMS send failure AuthException correctly', () {
      final errorByCode = AuthException('Gateway error', code: 'sms_send_failed');
      final errorByMsg = AuthException('Error sending SMS to carrier');

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nBn), l10nBn.authErrorSmsSendFailed);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nEn), l10nEn.authErrorSmsSendFailed);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nBn), l10nBn.authErrorSmsSendFailed);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nEn), l10nEn.authErrorSmsSendFailed);
    });

    test('Maps Rate Limit (429 / over_sms_send_rate_limit) correctly', () {
      final errorByStatus = AuthException('Too many requests', statusCode: '429');
      final errorByCode = AuthException('Rate exceeded', code: 'over_sms_send_rate_limit');
      final errorByMsg = AuthException('For security purposes, you can only request this once every 60 seconds');

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByStatus, l10nBn), l10nBn.authErrorRateLimit);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByStatus, l10nEn), l10nEn.authErrorRateLimit);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nBn), l10nBn.authErrorRateLimit);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nEn), l10nEn.authErrorRateLimit);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nBn), l10nBn.authErrorRateLimit);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nEn), l10nEn.authErrorRateLimit);
    });

    test('Maps invalid phone number AuthException correctly', () {
      final errorByCode = AuthException('Invalid format', code: 'invalid_phone_number');
      final errorByMsg = AuthException('Invalid phone number format provided');

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nBn), l10nBn.authErrorInvalidPhone);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nEn), l10nEn.authErrorInvalidPhone);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nBn), l10nBn.authErrorInvalidPhone);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nEn), l10nEn.authErrorInvalidPhone);
    });

    test('Maps validation_failed AuthException correctly', () {
      final errorByCode = AuthException('Input invalid', code: 'validation_failed');
      final errorByMsg = AuthException('Validation failed for phone');

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nBn), l10nBn.authErrorValidationFailed);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nEn), l10nEn.authErrorValidationFailed);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nBn), l10nBn.authErrorValidationFailed);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nEn), l10nEn.authErrorValidationFailed);
    });

    test('Maps invalid_credentials AuthException correctly', () {
      final errorByCode = AuthException('Bad login', code: 'invalid_credentials');
      final errorByMsg = AuthException('Invalid login credentials');

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nBn), l10nBn.authErrorInvalidCredentials);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nEn), l10nEn.authErrorInvalidCredentials);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nBn), l10nBn.authErrorInvalidCredentials);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nEn), l10nEn.authErrorInvalidCredentials);
    });

    test('Maps email_provider_disabled AuthException correctly', () {
      final errorByCode = AuthException('Disabled', code: 'email_provider_disabled');
      final errorByMsg = AuthException('Email provider is disabled');

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nBn), l10nBn.authErrorEmailProviderDisabled);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nEn), l10nEn.authErrorEmailProviderDisabled);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nBn), l10nBn.authErrorEmailProviderDisabled);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nEn), l10nEn.authErrorEmailProviderDisabled);
    });

    test('Maps signup_disabled AuthException correctly', () {
      final errorByCode = AuthException('Signups disabled', code: 'signup_disabled');
      final errorByMsg = AuthException('Signups are disabled for this project');

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nBn), l10nBn.authErrorSignupDisabled);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nEn), l10nEn.authErrorSignupDisabled);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nBn), l10nBn.authErrorSignupDisabled);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nEn), l10nEn.authErrorSignupDisabled);
    });

    test('Maps Invalid API key (wrong anon key) correctly', () {
      final errorByCode = AuthException('Key error', code: 'invalid_api_key');
      final errorByMsg = AuthException('Invalid API key');

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nBn), l10nBn.authErrorInvalidApiKey);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByCode, l10nEn), l10nEn.authErrorInvalidApiKey);

      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nBn), l10nBn.authErrorInvalidApiKey);
      expect(AuthErrorResolver.resolveOtpErrorMessage(errorByMsg, l10nEn), l10nEn.authErrorInvalidApiKey);
    });

    test('Maps Network Offline / SocketException / Supabase Unreachable correctly', () {
      const socketError = SocketException('Failed host lookup: api.supabase.co');
      final clientError = Exception('ClientException: Connection refused (network is unreachable)');
      final unreachableError = Exception('Supabase unreachable');

      expect(AuthErrorResolver.resolveOtpErrorMessage(socketError, l10nBn), l10nBn.authErrorNetworkOffline);
      expect(AuthErrorResolver.resolveOtpErrorMessage(socketError, l10nEn), l10nEn.authErrorNetworkOffline);

      expect(AuthErrorResolver.resolveOtpErrorMessage(clientError, l10nBn), l10nBn.authErrorNetworkOffline);
      expect(AuthErrorResolver.resolveOtpErrorMessage(clientError, l10nEn), l10nEn.authErrorNetworkOffline);

      expect(AuthErrorResolver.resolveOtpErrorMessage(unreachableError, l10nBn), l10nBn.authErrorNetworkOffline);
      expect(AuthErrorResolver.resolveOtpErrorMessage(unreachableError, l10nEn), l10nEn.authErrorNetworkOffline);
    });

    test('getDebugDetails formats error correctly', () {
      expect(AuthErrorResolver.getDebugDetails(null), isNull);

      final authError = AuthException('Detailed error message', statusCode: '400', code: 'custom_code');
      expect(AuthErrorResolver.getDebugDetails(authError), 'HTTP 400: [code: custom_code] Detailed error message');

      final simpleError = Exception('Simple socket fail');
      expect(AuthErrorResolver.getDebugDetails(simpleError), contains('Simple socket fail'));
    });

    test('Falls back to generic otpSendError for unclassified errors', () {
      final genericError = Exception('An unknown server error occurred');

      expect(AuthErrorResolver.resolveOtpErrorMessage(genericError, l10nBn), l10nBn.otpSendError);
      expect(AuthErrorResolver.resolveOtpErrorMessage(genericError, l10nEn), l10nEn.otpSendError);
    });
  });
}
