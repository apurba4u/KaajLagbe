import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kaajlagbe/core/config/env_config.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/auth_gate.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:kaajlagbe/features/preview/domain/preview_data.dart';
import 'package:kaajlagbe/features/preview/presentation/preview_providers.dart';
import 'package:kaajlagbe/features/preview/presentation/screens/design_preview_hub_screen.dart';
import 'package:kaajlagbe/features/preview/presentation/widgets/design_preview_banner.dart';
import 'package:kaajlagbe/features/preview/presentation/widgets/design_preview_floating_hub_button.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  tearDown(() {
    EnvConfig.testDesignPreviewOverride = null;
  });

  Widget buildTestApp({required Widget home}) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        currentSessionProvider.overrideWithValue(null),
        currentAuthUserProvider.overrideWithValue(null),
        currentUserProfileProvider.overrideWith((ref) => Stream.value(null)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: home,
      ),
    );
  }

  group('Design Preview Mode Flag Controls', () {
    testWidgets('Flag OFF (DESIGN_PREVIEW=false): AuthGate renders PhoneLoginScreen', (tester) async {
      EnvConfig.testDesignPreviewOverride = false;

      await tester.pumpWidget(buildTestApp(home: const AuthGate()));
      await tester.pumpAndSettle();

      expect(find.byType(DesignPreviewHubScreen), findsNothing);
      expect(find.byType(PhoneLoginScreen), findsOneWidget);
    });

    testWidgets('Flag ON (DESIGN_PREVIEW=true): AuthGate renders DesignPreviewHubScreen with banner', (tester) async {
      EnvConfig.testDesignPreviewOverride = true;

      await tester.pumpWidget(buildTestApp(home: const AuthGate()));
      await tester.pumpAndSettle();

      expect(find.byType(PhoneLoginScreen), findsNothing);
      expect(find.byType(DesignPreviewHubScreen), findsOneWidget);
      expect(find.byType(DesignPreviewBanner), findsOneWidget);
      expect(find.text('DESIGN PREVIEW: Login Disabled'), findsOneWidget);
    });

    testWidgets('DesignPreviewHubScreen displays sections and allows switching demo personas', (tester) async {
      EnvConfig.testDesignPreviewOverride = true;

      await tester.pumpWidget(buildTestApp(home: const DesignPreviewHubScreen()));
      await tester.pumpAndSettle();

      // Verify sections are visible
      expect(find.text('Active Preview Role'), findsOneWidget);
      expect(find.text('Onboarding & Auth'), findsOneWidget);
      expect(find.text('Splash Screen'), findsOneWidget);
      expect(find.text('Phone Login'), findsOneWidget);
      expect(find.text('OTP Verification'), findsOneWidget);

      // Verify persona chips
      expect(find.text('Rahim Uddin'), findsOneWidget);
      expect(find.text('Karim Mia'), findsOneWidget);

      // Tap on Karim Mia chip
      await tester.tap(find.text('Karim Mia'));
      await tester.pumpAndSettle();

      // Verify role switched to LABOUR
      expect(find.text('LABOUR'), findsOneWidget);
    });

    testWidgets('DesignPreviewFloatingHubButton pops to root when clicked', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const Scaffold(
                          body: Stack(
                            children: [
                              Center(child: Text('Sub Screen')),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: DesignPreviewFloatingHubButton(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Open Sub'),
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to sub screen
      await tester.tap(find.text('Open Sub'));
      await tester.pumpAndSettle();

      expect(find.text('Sub Screen'), findsOneWidget);
      expect(find.byKey(const Key('floating_preview_hub_button')), findsOneWidget);

      // Tap Floating Hub button
      await tester.tap(find.byKey(const Key('floating_preview_hub_button')));
      await tester.pumpAndSettle();

      // Returned to root
      expect(find.text('Sub Screen'), findsNothing);
      expect(find.text('Open Sub'), findsOneWidget);
    });

    test('In-memory FakeAuthRepository works without network', () async {
      final container = ProviderContainer();
      final fakeAuth = container.read(fakeAuthRepositoryProvider);

      expect(fakeAuth.currentUser, isNotNull);
      expect(fakeAuth.currentUser!.id, PreviewData.customer1Id);

      final profile = await fakeAuth.getUserProfile(PreviewData.customer1Id);
      expect(profile?.fullName, 'Rahim Uddin');

      await fakeAuth.updateProfile(userId: PreviewData.customer1Id, fullName: 'Rahim Updated');
      final updatedProfile = await fakeAuth.getUserProfile(PreviewData.customer1Id);
      expect(updatedProfile?.fullName, 'Rahim Updated');
    });

    test('In-memory FakeLabourRepository works without network', () async {
      final fakeLabour = FakeLabourRepository();

      final skills = await fakeLabour.getSkills();
      expect(skills.length, 7);

      final karimProfile = await fakeLabour.getLabourProfile(PreviewData.labour1Id);
      expect(karimProfile?.experience, contains('8 years'));

      final karimSkills = await fakeLabour.getLabourSkills(PreviewData.labour1Id);
      expect(karimSkills.length, 3);
      expect(karimSkills.first.score, 245.5);
    });

    test('In-memory FakeVerificationRepository works without network', () async {
      final fakeVerification = FakeVerificationRepository();

      final nasirVerif = await fakeVerification.getLatestVerification(PreviewData.labour3Id);
      expect(nasirVerif?.status, 'pending');

      final submission = await fakeVerification.submitVerification(
        userId: 'test-user',
        documentType: 'nid',
        documentNumber: 'NID-999999',
        frontPath: 'front.jpg',
        selfiePath: 'selfie.jpg',
      );
      expect(submission.status, 'pending');
      expect(submission.documentNumber, 'NID-999999');
    });
  });
}
