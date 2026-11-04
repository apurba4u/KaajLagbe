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

  /// Supabase project URL
  static String get supabaseUrl {
    return dotenv.env['SUPABASE_URL'] ??
        const String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://placeholder.supabase.co',
        );
  }

  /// Supabase Anon / Public Key (Safe for client apps)
  static String get supabaseAnonKey {
    return dotenv.env['SUPABASE_ANON_KEY'] ??
        const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'placeholder-anon-key',
        );
  }

  /// App Environment name (development, staging, production)
  static String get appEnv {
    return dotenv.env['APP_ENV'] ??
        const String.fromEnvironment(
          'APP_ENV',
          defaultValue: 'development',
        );
  }

  /// Returns true if valid Supabase credentials have been configured
  static bool get hasValidSupabaseCredentials {
    return supabaseUrl.isNotEmpty &&
        !supabaseUrl.contains('placeholder') &&
        supabaseAnonKey.isNotEmpty &&
        !supabaseAnonKey.contains('placeholder');
  }
}
