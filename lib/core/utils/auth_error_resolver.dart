import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';

/// Maps Supabase Auth errors and network failures to localized, actionable user-facing messages.
/// In debug mode, logs the underlying status code, error code, and server message via [debugPrint].
class AuthErrorResolver {
  AuthErrorResolver._();

  /// Formats raw error details for selectable display in debug mode.
  static String? getDebugDetails(Object? error) {
    if (error == null) return null;
    if (error is AuthException) {
      final codePart = error.code != null ? '[code: ${error.code}] ' : '';
      final statusPart = error.statusCode != null ? 'HTTP ${error.statusCode}: ' : '';
      return '$statusPart$codePart${error.message}';
    }
    return error.toString();
  }

  /// Resolves an error encountered during auth flows (OTP, sign-in, etc.).
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

    // 1. Network / Offline / Unreachable check
    if (error is SocketException ||
        rawString.contains('socketexception') ||
        rawString.contains('clientexception') ||
        rawString.contains('failed host lookup') ||
        rawString.contains('network is unreachable') ||
        rawString.contains('connection refused') ||
        rawString.contains('connection timed out') ||
        rawString.contains('network error') ||
        rawString.contains('handshakeexception') ||
        rawString.contains('supabase unreachable')) {
      return l10n.authErrorNetworkOffline;
    }

    // 2. AuthException inspection
    final code = error is AuthException ? (error.code?.toLowerCase() ?? '') : '';
    final msg = error is AuthException ? error.message.toLowerCase() : '';
    final statusCode = error is AuthException ? (error.statusCode?.toString() ?? '') : '';

    // Invalid API Key (wrong anon key)
    if (code == 'invalid_api_key' ||
        code == 'invalid_token' ||
        msg.contains('invalid api key') ||
        msg.contains('invalid api_key') ||
        msg.contains('invalid anon key') ||
        msg.contains('api key not found') ||
        rawString.contains('invalid api key')) {
      return l10n.authErrorInvalidApiKey;
    }

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

    // Email Provider Disabled
    if (code == 'email_provider_disabled' ||
        msg.contains('email provider is disabled') ||
        msg.contains('email provider disabled') ||
        rawString.contains('email_provider_disabled')) {
      return l10n.authErrorEmailProviderDisabled;
    }

    // Signup Disabled
    if (code == 'signup_disabled' ||
        msg.contains('signups not allowed') ||
        msg.contains('signups are disabled') ||
        msg.contains('signup disabled') ||
        rawString.contains('signup_disabled')) {
      return l10n.authErrorSignupDisabled;
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

    // Rate Limiting (429 / over_sms_send_rate_limit)
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

    // Invalid Credentials
    if (code == 'invalid_credentials' ||
        code == 'invalid_grant' ||
        msg.contains('invalid login credentials') ||
        msg.contains('invalid credentials') ||
        rawString.contains('invalid_credentials')) {
      return l10n.authErrorInvalidCredentials;
    }

    // Validation Failed
    if (code == 'validation_failed' ||
        msg.contains('validation failed') ||
        rawString.contains('validation_failed')) {
      return l10n.authErrorValidationFailed;
    }

    // Invalid Phone Format
    if (code == 'invalid_phone_number' ||
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
