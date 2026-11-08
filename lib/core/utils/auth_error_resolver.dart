import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';

/// Maps Supabase Auth errors and network failures to localized, actionable user-facing messages.
/// In debug mode, logs the underlying status code, error code, and server message via [debugPrint].
class AuthErrorResolver {
  AuthErrorResolver._();

  /// Resolves an error encountered during the OTP send flow.
  static String resolveOtpErrorMessage(Object error, AppLocalizations l10n) {
    if (kDebugMode) {
      if (error is AuthException) {
        debugPrint(
          '[Supabase OTP Error] statusCode: ${error.statusCode}, '
          'code: ${error.code}, message: ${error.message}',
        );
      } else {
        debugPrint('[Supabase OTP Error] $error');
      }
    }

    final rawString = error.toString().toLowerCase();

    // 1. Network / Offline check
    if (error is SocketException ||
        rawString.contains('socketexception') ||
        rawString.contains('clientexception') ||
        rawString.contains('failed host lookup') ||
        rawString.contains('network is unreachable') ||
        rawString.contains('connection refused') ||
        rawString.contains('connection timed out') ||
        rawString.contains('network error') ||
        rawString.contains('handshakeexception')) {
      return l10n.authErrorNetworkOffline;
    }

    // 2. AuthException / AuthApiException or message inspection
    final code = error is AuthException ? (error.code?.toLowerCase() ?? '') : '';
    final msg = error is AuthException ? error.message.toLowerCase() : '';
    final statusCode = error is AuthException ? (error.statusCode?.toString() ?? '') : '';

    // Phone Provider Disabled
    if (code == 'phone_provider_disabled' ||
        msg.contains('phone provider is disabled') ||
        msg.contains('provider is not enabled') ||
        msg.contains('unsupported phone provider') ||
        msg.contains('phone provider disabled') ||
        rawString.contains('phone_provider_disabled') ||
        rawString.contains('phone provider is disabled')) {
      return l10n.authErrorPhoneProviderDisabled;
    }

    // SMS Send Failure
    if (code == 'sms_send_failed' ||
        msg.contains('error sending sms') ||
        msg.contains('failed to send sms') ||
        msg.contains('sms provider error') ||
        msg.contains('sms provider') ||
        rawString.contains('sms_send_failed') ||
        rawString.contains('error sending sms')) {
      return l10n.authErrorSmsSendFailed;
    }

    // Rate Limiting
    if (statusCode == '429' ||
        code == 'over_sms_send_rate_limit' ||
        code == 'over_email_send_rate_limit' ||
        code == 'rate_limit_exceeded' ||
        msg.contains('rate limit') ||
        msg.contains('too many requests') ||
        msg.contains('for security purposes') ||
        msg.contains('once every') ||
        rawString.contains('429') ||
        rawString.contains('rate limit') ||
        rawString.contains('over_sms_send_rate_limit')) {
      return l10n.authErrorRateLimit;
    }

    // Invalid Phone Format
    if (code == 'invalid_phone_number' ||
        code == 'validation_failed' ||
        msg.contains('invalid phone') ||
        msg.contains('phone number format') ||
        msg.contains('unsupported phone') ||
        rawString.contains('invalid_phone_number') ||
        rawString.contains('invalid phone')) {
      return l10n.authErrorInvalidPhone;
    }

    // Default fallback
    return l10n.otpSendError;
  }
}

