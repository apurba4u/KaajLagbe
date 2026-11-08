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

    test('Maps Network Offline / SocketException correctly', () {
      const socketError = SocketException('Failed host lookup: api.supabase.co');
      final clientError = Exception('ClientException: Connection refused (network is unreachable)');

      expect(AuthErrorResolver.resolveOtpErrorMessage(socketError, l10nBn), l10nBn.authErrorNetworkOffline);
      expect(AuthErrorResolver.resolveOtpErrorMessage(socketError, l10nEn), l10nEn.authErrorNetworkOffline);

      expect(AuthErrorResolver.resolveOtpErrorMessage(clientError, l10nBn), l10nBn.authErrorNetworkOffline);
      expect(AuthErrorResolver.resolveOtpErrorMessage(clientError, l10nEn), l10nEn.authErrorNetworkOffline);
    });

    test('Falls back to generic otpSendError for unclassified errors', () {
      final genericError = Exception('An unknown server error occurred');

      expect(AuthErrorResolver.resolveOtpErrorMessage(genericError, l10nBn), l10nBn.otpSendError);
      expect(AuthErrorResolver.resolveOtpErrorMessage(genericError, l10nEn), l10nEn.otpSendError);
    });
  });
}
