import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported application locales
class AppLocales {
  AppLocales._();

  static const Locale bangla = Locale('bn');
  static const Locale english = Locale('en');

  static const List<Locale> supported = [bangla, english];
}

/// SharedPreferences instance provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize sharedPreferencesProvider in main()');
});

/// Riverpod StateNotifier for managing and persisting active App Locale
class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences? _prefs;
  static const String _prefKey = 'app_language_code';

  LocaleNotifier(this._prefs) : super(_resolveInitialLocale(_prefs));

  static Locale _resolveInitialLocale(SharedPreferences? prefs) {
    if (prefs == null) return AppLocales.bangla;
    final savedCode = prefs.getString(_prefKey);
    if (savedCode == 'en') return AppLocales.english;
    return AppLocales.bangla; // Default locale is Bangla
  }

  /// Sets the application locale and persists the user preference
  Future<void> setLocale(Locale newLocale) async {
    if (state == newLocale) return;
    state = newLocale;
    await _prefs?.setString(_prefKey, newLocale.languageCode);
  }

  /// Toggles between Bangla ('bn') and English ('en')
  Future<void> toggleLocale() async {
    final next = state.languageCode == 'bn' ? AppLocales.english : AppLocales.bangla;
    await setLocale(next);
  }
}

/// Active App Locale Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  // Gracefully fallback to null prefs in test environments if not overridden
  SharedPreferences? prefs;
  try {
    prefs = ref.watch(sharedPreferencesProvider);
  } catch (_) {
    prefs = null;
  }
  return LocaleNotifier(prefs);
});

