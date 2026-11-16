import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/domain/user_profile.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/labour/domain/labour_profile.dart';
import 'package:kaajlagbe/features/labour/domain/labour_repository.dart';
import 'package:kaajlagbe/features/labour/domain/labour_skill.dart';
import 'package:kaajlagbe/features/labour/presentation/labour_providers.dart';
import 'package:kaajlagbe/features/labour/presentation/screens/labour_profile_setup_screen.dart';
import 'package:kaajlagbe/features/labour/presentation/screens/labour_profile_view_screen.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockLabourRepository extends Mock implements LabourRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockLabourRepository mockLabourRepository;

  const karimId = '00000000-0000-0000-0000-000000000003';
  const rahimId = '00000000-0000-0000-0000-000000000001';

  final karimUserProfile = UserProfile(
    id: karimId,
    role: UserRole.labour,
    accountStatus: AccountStatus.approved,
    fullName: 'Karim Mia',
    phone: '+8801800000001',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  final rahimUserProfile = UserProfile(
    id: rahimId,
    role: UserRole.customer,
    accountStatus: AccountStatus.approved,
    fullName: 'Rahim Uddin',
    phone: '+8801700000001',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  final karimLabourProfile = LabourProfile(
    id: 'lp-karim',
    userId: karimId,
    experience: '8 years, residential wiring and repair',
    serviceArea: 'Mirpur, Dhaka',
    expectedWage: 600.0,
    availability: 'Sat-Thu 09:00-18:00',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  final karimLabourSkills = <LabourSkill>[
    LabourSkill(
      id: 'ls-karim-1',
      labourId: karimId,
      skillId: 'skill-elec',
      skillName: 'Electrician',
      skillNameBn: 'ইলেকট্রিশিয়ান',
      score: 245.5,
      badgeActive: true,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
    LabourSkill(
      id: 'ls-karim-2',
      labourId: karimId,
      skillId: 'skill-plumb',
      skillName: 'Plumber',
      skillNameBn: 'প্লাম্বার',
      score: 212.0,
      badgeActive: true,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
    LabourSkill(
      id: 'ls-karim-3',
      labourId: karimId,
      skillId: 'skill-paint',
      skillName: 'Painter',
      skillNameBn: 'পেইন্টার',
      score: 146.5,
      badgeActive: false,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
  ];

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockLabourRepository = MockLabourRepository();

    when(() => mockAuthRepository.watchUserProfile(karimId))
        .thenAnswer((_) => Stream.value(karimUserProfile));
    when(() => mockAuthRepository.getUserProfile(karimId))
        .thenAnswer((_) async => karimUserProfile);

    when(() => mockLabourRepository.watchLabourProfile(karimId))
        .thenAnswer((_) => Stream.value(karimLabourProfile));
    when(() => mockLabourRepository.getLabourProfile(karimId))
        .thenAnswer((_) async => karimLabourProfile);

    when(() => mockLabourRepository.watchLabourSkills(karimId))
        .thenAnswer((_) => Stream.value(karimLabourSkills));
    when(() => mockLabourRepository.getLabourSkills(karimId))
        .thenAnswer((_) async => karimLabourSkills);
  });

  Widget createTestWidget({
    required UserProfile currentUser,
    Locale locale = const Locale('bn'),
  }) {
    return ProviderScope(
      overrides: [
        currentUserProfileProvider.overrideWith((ref) => Stream.value(currentUser)),
        userProfileProvider(karimId).overrideWith((ref) => Stream.value(karimUserProfile)),
        labourProfileStreamProvider(karimId).overrideWith((ref) => Stream.value(karimLabourProfile)),
        labourSkillsStreamProvider(karimId).overrideWith((ref) => Stream.value(karimLabourSkills)),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        labourRepositoryProvider.overrideWithValue(mockLabourRepository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const LabourProfileViewScreen(workerId: karimId),
      ),
    );
  }

  group('LabourProfileViewScreen Widget Tests', () {
    testWidgets('Renders Karim Mia seeded details, hourly rate and trust credentials in Bengali', (tester) async {
      await tester.pumpWidget(createTestWidget(currentUser: rahimUserProfile, locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Header title
      expect(find.text('শ্রমিক প্রোফাইল'), findsOneWidget);

      // Worker name
      expect(find.text('Karim Mia'), findsOneWidget);

      // Hourly rate
      expect(find.text('৳ ৬০০'), findsWidgets);

      // Service area
      expect(find.text('Mirpur, Dhaka'), findsOneWidget);

      // Schedule & experience
      expect(find.text('Sat-Thu 09:00-18:00'), findsOneWidget);
      expect(find.text('8 years, residential wiring and repair'), findsOneWidget);

      // Trust credentials
      expect(find.text('পুলিশ রেকর্ড'), findsOneWidget);
      expect(find.text('সময়ানুবর্তিতা'), findsOneWidget);
      expect(find.text('সার্টিফিকেশন'), findsOneWidget);
    });

    testWidgets('Renders English details in English locale', (tester) async {
      await tester.pumpWidget(createTestWidget(currentUser: rahimUserProfile, locale: const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Worker Profile'), findsOneWidget);
      expect(find.text('৳ 600'), findsWidgets);
      expect(find.text('Electrician'), findsOneWidget);
      expect(find.text('Plumber'), findsOneWidget);
      expect(find.text('Painter'), findsOneWidget);
    });

    testWidgets('Displays read-only skill scores and badges matching seeded values', (tester) async {
      await tester.pumpWidget(createTestWidget(currentUser: rahimUserProfile, locale: const Locale('en')));
      await tester.pumpAndSettle();

      // Electrician score: 245.5 / 200 with Active Badge
      expect(find.text('245.5'), findsOneWidget);
      expect(find.text('Active Badge'), findsNWidgets(2)); // Electrician & Plumber

      // Plumber score: 212 / 200 with Active Badge
      expect(find.text('212'), findsOneWidget);

      // Painter score: 146.5 / 200 with Claimed (unverified)
      expect(find.text('146.5'), findsOneWidget);
      expect(find.text('Claimed'), findsOneWidget);

      // Confirm there are no edit or input controls for scores
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('Customer sees "Book Worker" CTA and tapping triggers snackbar', (tester) async {
      await tester.pumpWidget(createTestWidget(currentUser: rahimUserProfile, locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Customer sees Book Worker button
      final bookBtnFinder = find.byKey(const Key('book_labour_cta_button'));
      expect(bookBtnFinder, findsOneWidget);
      expect(find.byKey(const Key('edit_profile_cta_button')), findsNothing);

      // Tapping Book Worker shows Phase 5 info snackbar
      await tester.tap(bookBtnFinder);
      await tester.pumpAndSettle();

      expect(find.text('বুকিং প্রক্রিয়া ফেজ ৫-এ চালু হবে'), findsOneWidget);
    });

    testWidgets('Worker viewing own profile sees "Edit Profile" CTA and can navigate', (tester) async {
      when(() => mockLabourRepository.getSkills()).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(currentUser: karimUserProfile, locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Worker sees Edit Profile button
      final editBtnFinder = find.byKey(const Key('edit_profile_cta_button'));
      expect(editBtnFinder, findsOneWidget);
      expect(find.byKey(const Key('book_labour_cta_button')), findsNothing);

      // Tapping Edit Profile opens LabourProfileSetupScreen
      await tester.tap(editBtnFinder);
      await tester.pumpAndSettle();

      expect(find.byType(LabourProfileSetupScreen), findsOneWidget);
    });
  });
}
