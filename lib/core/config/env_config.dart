import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application Environment Configuration
/// Safely manages environment variables without hardcoded secrets.
class EnvConfig {
  EnvConfig._();

  static bool _isLoaded = false;

  /// Loads environment variables from `.env` asset file.
  /// Gracefully succeeds if already loaded or in test environment.
  static Future<void> init() async {
    if (_isLoaded) return;
    try {
      await dotenv.load(fileName: '.env');
      _isLoaded = true;
    } catch (_) {
      // In test or CI environments where .env is absent, fallback to system/dart-define
      _isLoaded = true;
    }
  }

  static String? _getEnvVar(String key) {
    if (!dotenv.isInitialized) return null;
    return dotenv.maybeGet(key);
  }

  /// Supabase project URL
  static String get supabaseUrl {
    return _getEnvVar('SUPABASE_URL') ??
        const String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://placeholder.supabase.co',
        );
  }

  /// Supabase Anon / Public Key (Safe for client apps)
  static String get supabaseAnonKey {
    return _getEnvVar('SUPABASE_ANON_KEY') ??
        const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'placeholder-anon-key',
        );
  }

  /// App Environment name (development, staging, production)
  static String get appEnv {
    return _getEnvVar('APP_ENV') ??
        const String.fromEnvironment(
          'APP_ENV',
          defaultValue: 'development',
        );
  }

  /// Returns whether SMS OTP is required for authentication.
  /// Hard-locked to `true` in release mode (`kReleaseMode == true`).
  /// In debug/profile mode, can be set to `false` via OTP_REQUIRED=false in `.env`.
  static bool get otpRequired {
    if (kReleaseMode) return true;
    final val = _getEnvVar('OTP_REQUIRED') ??
        const String.fromEnvironment('OTP_REQUIRED', defaultValue: 'true');
    return val.toLowerCase() != 'false';
  }

  /// Returns true if valid Supabase credentials have been configured
  static bool get hasValidSupabaseCredentials {
    return supabaseUrl.isNotEmpty &&
        !supabaseUrl.contains('placeholder') &&
        supabaseAnonKey.isNotEmpty &&
        !supabaseAnonKey.contains('placeholder');
  }
}
