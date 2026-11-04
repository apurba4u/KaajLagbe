import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/localization/locale_provider.dart';
import 'package:kaajlagbe/core/presentation/widgets/language_toggle_button.dart';
import 'package:kaajlagbe/core/utils/number_formatter.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/splash_screen.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('ARB Dictionary Parity Tests', () {
    test('Both app_bn.arb and app_en.arb contain identical keys', () {
      final bnFile = File('lib/l10n/app_bn.arb');
      final enFile = File('lib/l10n/app_en.arb');

      expect(bnFile.existsSync(), isTrue, reason: 'app_bn.arb must exist');
      expect(enFile.existsSync(), isTrue, reason: 'app_en.arb must exist');

      final Map<String, dynamic> bnJson = json.decode(bnFile.readAsStringSync());
      final Map<String, dynamic> enJson = json.decode(enFile.readAsStringSync());

      // Filter out internal metadata keys starting with @
      final bnKeys = bnJson.keys.where((k) => !k.startsWith('@')).toSet();
      final enKeys = enJson.keys.where((k) => !k.startsWith('@')).toSet();

      final missingInBn = enKeys.difference(bnKeys);
      final missingInEn = bnKeys.difference(enKeys);

      expect(missingInBn, isEmpty, reason: 'Keys in en missing in bn: $missingInBn');
      expect(missingInEn, isEmpty, reason: 'Keys in bn missing in en: $missingInEn');
      expect(bnKeys.length, enKeys.length);
    });
  });

  group('NumberFormatter & Bengali Numeral Tests', () {
    test('Converts ASCII numbers to Bengali digits', () {
      expect(NumberFormatter.toBengaliDigits('1234567890'), '১২৩৪৫৬৭৮৯০');
      expect(NumberFormatter.toBengaliDigits(600), '৬০০');
    });

    test('Converts Bengali digits to ASCII for submission to backend', () {
      expect(NumberFormatter.toAsciiDigits('১২৩৪৫৬৭৮৯০'), '1234567890');
      expect(NumberFormatter.toAsciiDigits('+880১৭১২৩৪৫৬৭৮'), '+8801712345678');
    });

    test('Formats currency with ৳ symbol and localized digits', () {
      expect(NumberFormatter.formatCurrency(600, languageCode: 'bn'), '৳ ৬০০');
      expect(NumberFormatter.formatCurrency(600, languageCode: 'en'), '৳ 600');
      expect(NumberFormatter.formatCurrency(245.5, languageCode: 'bn'), '৳ ২৪৫.৫');
    });

    test('Formats countdown timers and scores', () {
      expect(NumberFormatter.formatNumber(60, languageCode: 'bn'), '৬০');
      expect(NumberFormatter.formatNumber(60, languageCode: 'en'), '60');
    });
  });

  group('Live Language Switch Widget Tests', () {
    testWidgets('Tapping LanguageTogglePill immediately updates UI text across the entire tree', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ],
          child: Consumer(
            builder: (context, ref, child) {
              final currentLocale = ref.watch(localeProvider);
              return MaterialApp(
                locale: currentLocale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: const Scaffold(
                  body: Column(
                    children: [
                      LanguageTogglePill(),
                      Expanded(child: PhoneLoginScreen()),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Default locale is Bangla
      expect(find.text('স্বাগতম!'), findsOneWidget);
      expect(find.text('ওটিপি পাঠান'), findsOneWidget);

      // Tap the LanguageTogglePill
      final togglePill = find.byType(LanguageTogglePill).first;
      await tester.tap(togglePill);
      await tester.pumpAndSettle();

      // Immediately switches to English!
      expect(find.text('Welcome!'), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);

      // Tap again to switch back to Bangla
      await tester.tap(togglePill);
      await tester.pumpAndSettle();

      expect(find.text('স্বাগতম!'), findsOneWidget);
      expect(find.text('ওটিপি পাঠান'), findsOneWidget);
    });
  });

  group('Small Screen (320x640) with Text Scaler 1.3 in Bangla Tests', () {
    testWidgets('SplashScreen does not overflow at 320x640 with textScaler 1.3 in Bangla', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale: Locale('bn'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(320, 640),
                textScaler: TextScaler.linear(1.3),
              ),
              child: SplashScreen(showProgress: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('PhoneLoginScreen does not overflow at 320x640 with textScaler 1.3 in Bangla', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ],
          child: const MaterialApp(
            locale: Locale('bn'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(320, 640),
                textScaler: TextScaler.linear(1.3),
              ),
              child: PhoneLoginScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
