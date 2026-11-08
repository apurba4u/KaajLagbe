import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget createTestWidget(Widget child, {Locale locale = const Locale('bn')}) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: child,
      ),
    );
  }

  group('PhoneLoginScreen Tests', () {
    testWidgets('Renders phone input, +880 prefix and Send OTP button in Bengali', (tester) async {
      await tester.pumpWidget(createTestWidget(const PhoneLoginScreen(), locale: const Locale('bn')));
      await tester.pumpAndSettle();

      expect(find.text('+880'), findsOneWidget);
      expect(find.text('ওটিপি পাঠান'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Renders in English when English locale is provided', (tester) async {
      await tester.pumpWidget(createTestWidget(const PhoneLoginScreen(), locale: const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('+880'), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);
      expect(find.text('Welcome!'), findsOneWidget);
    });

    testWidgets('Displays error message when invalid phone number is submitted', (tester) async {
      await tester.pumpWidget(createTestWidget(const PhoneLoginScreen()));
      await tester.pumpAndSettle();

      // Enter short/invalid number
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.text('ওটিপি পাঠান'));
      await tester.pumpAndSettle();

      expect(find.textContaining('সঠিক ১০-সংখ্যার নম্বর দিন'), findsOneWidget);
    });

    testWidgets('Accepts Bengali numerals and normalizes to ASCII for sendOtp', (tester) async {
      when(() => mockAuthRepository.signInWithOtp(
            phone: any(named: 'phone'),
            data: any(named: 'data'),
          )).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget(const PhoneLoginScreen()));
      await tester.pumpAndSettle();

      // Enter Bengali numerals: ১৭১২৩৪৫৬৭৮
      await tester.enterText(find.byType(TextField), '১৭১২৩৪৫৬৭৮');
      await tester.tap(find.text('ওটিপি পাঠান'));
      await tester.pumpAndSettle();

      verify(() => mockAuthRepository.signInWithOtp(
            phone: '+8801712345678',
            data: any(named: 'data'),
          )).called(1);

      expect(find.byType(OtpVerificationScreen), findsOneWidget);
      expect(find.text('+8801712345678'), findsOneWidget);
    });

    testWidgets('Triggers sendOtp and navigates to OtpVerificationScreen on valid phone', (tester) async {
      when(() => mockAuthRepository.signInWithOtp(
            phone: any(named: 'phone'),
            data: any(named: 'data'),
          )).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget(const PhoneLoginScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '1712345678');
      await tester.tap(find.text('ওটিপি পাঠান'));
      await tester.pumpAndSettle();

      verify(() => mockAuthRepository.signInWithOtp(
            phone: '+8801712345678',
            data: any(named: 'data'),
          )).called(1);

      expect(find.byType(OtpVerificationScreen), findsOneWidget);
      expect(find.text('+8801712345678'), findsOneWidget);
    });

    testWidgets('Does not overflow at 320x640 with textScaler 1.3 in both customer and worker mode', (tester) async {
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
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('bn'),
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

      // Toggle to worker intent
      final toggleFinder = find.byType(TextButton).last;
      await tester.ensureVisible(toggleFinder);
      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders dev mode banner and triggers signInWithDevPhone when OTP_REQUIRED is false', (tester) async {
      addTearDown(() {
        dotenv.testLoad(fileInput: 'OTP_REQUIRED=true');
      });
      dotenv.testLoad(fileInput: 'OTP_REQUIRED=false');

      when(() => mockAuthRepository.signInWithDevPhone(
            phone: any(named: 'phone'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => AuthResponse(
            session: Session(
              accessToken: 'mock-access-token',
              tokenType: 'bearer',
              user: User(
                id: 'mock-dev-id',
                appMetadata: {},
                userMetadata: {},
                aud: 'authenticated',
                createdAt: '2026-11-04T00:00:00Z',
              ),
            ),
          ));

      await tester.pumpWidget(createTestWidget(const PhoneLoginScreen()));
      await tester.pumpAndSettle();

      expect(find.text('DEV MODE: OTP skipped'), findsOneWidget);
      expect(find.text('Continue without OTP (dev mode)'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '1712345678');
      await tester.tap(find.text('Continue without OTP (dev mode)'));
      await tester.pumpAndSettle();

      verify(() => mockAuthRepository.signInWithDevPhone(
            phone: '+8801712345678',
            data: any(named: 'data'),
          )).called(1);
    });

    testWidgets('Renders quick-fill chips in dev mode and populates phone field when tapped', (tester) async {
      addTearDown(() {
        dotenv.testLoad(fileInput: 'OTP_REQUIRED=true');
      });
      dotenv.testLoad(fileInput: 'OTP_REQUIRED=false');

      await tester.pumpWidget(createTestWidget(const PhoneLoginScreen()));
      await tester.pumpAndSettle();

      expect(find.text('ডেমো অ্যাকাউন্ট কুইক-ফিল'), findsOneWidget);
      expect(find.text('Rahim'), findsOneWidget);
      expect(find.text('Sadia'), findsOneWidget);
      expect(find.text('Karim'), findsOneWidget);
      expect(find.text('Jamal'), findsOneWidget);
      expect(find.text('Nasir'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);

      // Tap Rahim
      final rahimChip = find.widgetWithText(ActionChip, 'Rahim');
      await tester.ensureVisible(rahimChip);
      await tester.tap(rahimChip);
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, '1700000001');

      // Tap Karim (Labour)
      final karimChip = find.widgetWithText(ActionChip, 'Karim');
      await tester.ensureVisible(karimChip);
      await tester.tap(karimChip);
      await tester.pumpAndSettle();

      final textFieldKarim = tester.widget<TextField>(find.byType(TextField));
      expect(textFieldKarim.controller?.text, '1800000001');
    });

    testWidgets('Displays specific localized error when AuthException occurs during OTP send', (tester) async {
      when(() => mockAuthRepository.signInWithOtp(
            phone: any(named: 'phone'),
            data: any(named: 'data'),
          )).thenThrow(
        const AuthException('For security purposes, you can only request this once every 60 seconds',
            statusCode: '429', code: 'over_sms_send_rate_limit'),
      );

      await tester.pumpWidget(createTestWidget(const PhoneLoginScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '1712345678');
      await tester.tap(find.text('ওটিপি পাঠান'));
      await tester.pumpAndSettle();

      expect(find.textContaining('সীমা অতিক্রান্ত হয়েছে'), findsOneWidget);
    });

    testWidgets('Displays phone provider disabled error when Supabase Phone provider is off', (tester) async {
      when(() => mockAuthRepository.signInWithOtp(
            phone: any(named: 'phone'),
            data: any(named: 'data'),
          )).thenThrow(
        const AuthException('Phone provider is disabled for this project', code: 'phone_provider_disabled'),
      );

      await tester.pumpWidget(createTestWidget(const PhoneLoginScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '1712345678');
      await tester.tap(find.text('ওটিপি পাঠান'));
      await tester.pumpAndSettle();

      expect(find.textContaining('ফোন ওটিপি প্রোভাইডার নিষ্ক্রিয়'), findsOneWidget);
    });
  });

  group('OtpVerificationScreen Tests', () {
    testWidgets('Displays phone number, countdown timer and 6 boxes', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const OtpVerificationScreen(phone: '+8801712345678')),
      );
      await tester.pumpAndSettle();

      expect(find.text('+8801712345678'), findsOneWidget);
      expect(find.textContaining('পুনরায় কোড পাঠান'), findsOneWidget);
      expect(find.text('যাচাই করুন ও এগিয়ে যান'), findsOneWidget);
    });

    testWidgets('Submits verifyOtp when 6 digits are entered', (tester) async {
      final mockAuthResponse = AuthResponse(
        session: Session(
          accessToken: 'token-abc',
          tokenType: 'bearer',
          user: User(
            id: 'u-abc',
            appMetadata: {},
            userMetadata: {},
            aud: 'authenticated',
            createdAt: '2026-11-04T00:00:00Z',
          ),
        ),
      );

      when(() => mockAuthRepository.verifyOtp(
            phone: any(named: 'phone'),
            token: any(named: 'token'),
          )).thenAnswer((_) async => mockAuthResponse);

      await tester.pumpWidget(
        createTestWidget(const OtpVerificationScreen(phone: '+8801712345678')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '123456');
      await tester.pumpAndSettle();

      verify(() => mockAuthRepository.verifyOtp(
            phone: '+8801712345678',
            token: '123456',
          )).called(1);
    });
  });
}
