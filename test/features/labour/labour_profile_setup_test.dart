import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/user_profile.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/labour/domain/labour_profile.dart';
import 'package:kaajlagbe/features/labour/domain/labour_repository.dart';
import 'package:kaajlagbe/features/labour/domain/labour_skill.dart';
import 'package:kaajlagbe/features/labour/domain/skill.dart';
import 'package:kaajlagbe/features/labour/presentation/labour_providers.dart';
import 'package:kaajlagbe/features/labour/presentation/screens/labour_profile_setup_screen.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockLabourRepository extends Mock implements LabourRepository {}

void main() {
  late MockLabourRepository mockLabourRepository;

  final testUser = UserProfile(
    id: 'worker-karim-001',
    role: UserRole.labour,
    accountStatus: AccountStatus.approved,
    fullName: 'Karim Mia',
    phone: '+8801800000001',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  final allPlatformSkills = <Skill>[
    const Skill(
      id: 'skill-elec',
      name: 'Electrician',
      nameBn: 'ইলেকট্রিশিয়ান',
      description: 'Wiring, circuit fixing',
    ),
    const Skill(
      id: 'skill-plumb',
      name: 'Plumber',
      nameBn: 'প্লাম্বার',
      description: 'Pipe and leak repair',
    ),
    const Skill(
      id: 'skill-clean',
      name: 'Cleaner',
      nameBn: 'ক্লিনার',
      description: 'Deep cleaning service',
    ),
    const Skill(
      id: 'skill-paint',
      name: 'Painter',
      nameBn: 'পেইন্টার',
      description: 'Wall painting',
    ),
    const Skill(
      id: 'skill-gard',
      name: 'Gardener',
      nameBn: 'মালী',
      description: 'Lawn and plant care',
    ),
    const Skill(
      id: 'skill-carp',
      name: 'Carpenter',
      nameBn: 'ছুতার',
      description: 'Wood and furniture',
    ),
    const Skill(
      id: 'skill-move',
      name: 'Moving Helper',
      nameBn: 'মুভিং হেল্পার',
      description: 'Furniture lifting & shifting',
    ),
  ];

  final initialLabourSkills = <LabourSkill>[
    LabourSkill(
      id: 'ls-1',
      labourId: 'worker-karim-001',
      skillId: 'skill-elec',
      score: 245.5,
      badgeActive: true,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
    LabourSkill(
      id: 'ls-2',
      labourId: 'worker-karim-001',
      skillId: 'skill-paint',
      score: 146.5,
      badgeActive: false,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
  ];

  final initialLabourProfile = LabourProfile(
    id: 'lp-1',
    userId: 'worker-karim-001',
    experience: '8 years',
    serviceArea: 'Dhanmondi, Mohammadpur',
    expectedWage: 600,
    availability: 'Sat,Sun,Mon,Tue,Wed,Thu | 09:00 - 18:00',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  setUp(() {
    mockLabourRepository = MockLabourRepository();
    when(() => mockLabourRepository.getSkills())
        .thenAnswer((_) async => allPlatformSkills);
    when(() => mockLabourRepository.watchLabourProfile('worker-karim-001'))
        .thenAnswer((_) => Stream.value(initialLabourProfile));
    when(() => mockLabourRepository.getLabourProfile('worker-karim-001'))
        .thenAnswer((_) async => initialLabourProfile);
    when(() => mockLabourRepository.watchLabourSkills('worker-karim-001'))
        .thenAnswer((_) => Stream.value(initialLabourSkills));
    when(() => mockLabourRepository.getLabourSkills('worker-karim-001'))
        .thenAnswer((_) async => initialLabourSkills);
  });

  Widget createTestWidget({
    UserProfile? currentUser,
    Locale locale = const Locale('bn'),
  }) {
    final activeUser = currentUser ?? testUser;
    return ProviderScope(
      overrides: [
        currentUserProfileProvider.overrideWith((ref) => Stream.value(activeUser)),
        labourRepositoryProvider.overrideWithValue(mockLabourRepository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const LabourProfileSetupScreen(),
      ),
    );
  }

  group('Labour Domain Models Tests', () {
    test('Skill correctly deserializes from JSON', () {
      final json = {
        'id': 'skill-elec',
        'name': 'Electrician',
        'name_bn': 'ইলেকট্রিশিয়ান',
        'description': 'Wiring',
      };
      final skill = Skill.fromJson(json);
      expect(skill.id, 'skill-elec');
      expect(skill.name, 'Electrician');
      expect(skill.nameBn, 'ইলেকট্রিশিয়ান');
    });

    test('LabourProfile correctly deserializes and serializes', () {
      final json = {
        'id': 'lp-1',
        'user_id': 'worker-karim-001',
        'experience': '8 years',
        'service_area': 'Dhanmondi, Mohammadpur',
        'expected_wage': 600.0,
        'availability': 'Sat,Sun,Mon,Tue,Wed,Thu | 09:00 - 18:00',
        'created_at': '2026-11-04T00:00:00Z',
        'updated_at': '2026-11-04T00:00:00Z',
      };
      final profile = LabourProfile.fromJson(json);
      expect(profile.userId, 'worker-karim-001');
      expect(profile.expectedWage, 600.0);
      expect(profile.serviceArea, 'Dhanmondi, Mohammadpur');

      final output = profile.toJson();
      expect(output['user_id'], 'worker-karim-001');
      expect(output['expected_wage'], 600.0);
    });

    test('LabourSkill default state enforces zero score and false badgeActive', () {
      final skill = LabourSkill(
        id: 'ls-new',
        labourId: 'worker-karim-001',
        skillId: 'skill-clean',
        createdAt: DateTime.now(),
      );
      // New skills must start at score 0 and badgeActive false
      expect(skill.score, 0.0);
      expect(skill.badgeActive, false);
      expect(skill.isClaimed, true);
    });
  });

  group('LabourProfileSetupScreen Widget Tests', () {
    testWidgets('Renders all 7 platform skills and distinguishes verified vs claimed', (tester) async {
      await tester.pumpWidget(createTestWidget(locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Check that all 7 skills are displayed in Bengali
      expect(find.text('ইলেকট্রিশিয়ান'), findsOneWidget);
      expect(find.text('প্লাম্বার'), findsOneWidget);
      expect(find.text('ক্লিনার'), findsOneWidget);
      expect(find.text('পেইন্টার'), findsOneWidget);
      expect(find.text('মালী'), findsOneWidget);
      expect(find.text('ছুতার'), findsOneWidget);
      expect(find.text('মুভিং হেল্পার'), findsOneWidget);

      // Electrician is verified (badgeActive = true) -> has verified icon
      expect(find.byIcon(Icons.verified_rounded), findsWidgets);

      // Painter is claimed (badgeActive = false) -> shows Claimed tag
      expect(find.text('দাবিকৃত'), findsWidgets);
    });

    testWidgets('Renders English trade names in English locale', (tester) async {
      await tester.pumpWidget(createTestWidget(locale: const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Electrician'), findsOneWidget);
      expect(find.text('Plumber'), findsOneWidget);
      expect(find.text('Cleaner'), findsOneWidget);
      expect(find.text('Painter'), findsOneWidget);
      expect(find.text('Gardener'), findsOneWidget);
      expect(find.text('Carpenter'), findsOneWidget);
      expect(find.text('Moving Helper'), findsOneWidget);
      expect(find.text('Claimed'), findsWidgets);
    });

    testWidgets('Populates initial profile values (experience, service area, wage)', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('8 years'), findsOneWidget);
      expect(find.text('Dhanmondi, Mohammadpur'), findsOneWidget);
      expect(find.text('600'), findsOneWidget);
    });

    testWidgets('Toggles skill selection when tapped', (tester) async {
      await tester.pumpWidget(createTestWidget(locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Tap on Cleaner (which was not initially selected)
      final cleanerFinder = find.text('ক্লিনার');
      expect(cleanerFinder, findsOneWidget);
      await tester.tap(cleanerFinder);
      await tester.pumpAndSettle();

      // Selected count increases (initially 2 selected: elec + paint, now 3)
      expect(find.text('3 Selected'), findsOneWidget);
    });

    testWidgets('Shows error if required fields are invalid', (tester) async {
      await tester.pumpWidget(createTestWidget(locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Clear the wage field
      final wageField = find.byKey(const Key('wage_input'));
      await tester.enterText(wageField, '');
      await tester.pumpAndSettle();

      // Tap save
      final saveBtn = find.text('প্রোফাইল সংরক্ষণ করুন');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Error message appears
      expect(find.text('ঘণ্টাপ্রতি পারিশ্রমিক লিখুন'), findsOneWidget);
    });

    testWidgets('Saves profile and calls repository methods on valid submission', (tester) async {
      when(() => mockLabourRepository.upsertLabourProfile(
            userId: any(named: 'userId'),
            experience: any(named: 'experience'),
            serviceArea: any(named: 'serviceArea'),
            expectedWage: any(named: 'expectedWage'),
            availability: any(named: 'availability'),
          )).thenAnswer((_) async => initialLabourProfile);

      when(() => mockLabourRepository.syncLabourSkills(
            userId: any(named: 'userId'),
            selectedSkillIds: any(named: 'selectedSkillIds'),
          )).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(locale: const Locale('bn')));
      await tester.pumpAndSettle();

      final saveBtn = find.text('প্রোফাইল সংরক্ষণ করুন');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify repository was called
      verify(() => mockLabourRepository.upsertLabourProfile(
            userId: 'worker-karim-001',
            experience: '8 years',
            serviceArea: 'Dhanmondi, Mohammadpur',
            expectedWage: 600.0,
            availability: any(named: 'availability'),
          )).called(1);

      verify(() => mockLabourRepository.syncLabourSkills(
            userId: 'worker-karim-001',
            selectedSkillIds: any(named: 'selectedSkillIds'),
          )).called(1);
    });
  });
}
