import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/domain/user_profile.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/profile_settings_screen.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    when(() => mockUser.id).thenReturn('u-profile-123');
    when(() => mockUser.userMetadata).thenReturn({});
    when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
  });

  Widget createTestWidget(Widget child, {Locale locale = const Locale('bn')}) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        currentAuthUserProvider.overrideWithValue(mockUser),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: child,
      ),
    );
  }

  group('ProfileSetupScreen Tests', () {
    testWidgets('Validates name input and calls updateProfile', (tester) async {
      when(() => mockAuthRepository.updateProfile(
            userId: any(named: 'userId'),
            fullName: any(named: 'fullName'),
            avatarUrl: any(named: 'avatarUrl'),
          )).thenAnswer((_) async {});

      await tester.pumpWidget(
        createTestWidget(const ProfileSetupScreen(selectedRole: UserRole.customer)),
      );
      await tester.pumpAndSettle();

      expect(find.text('আপনার প্রোফাইল সাজান'), findsOneWidget);

      // Enter name
      await tester.enterText(find.byType(TextField), 'Tanvir Ahmed');
      await tester.tap(find.text('সংরক্ষণ করুন ও এগিয়ে যান'));
      await tester.pumpAndSettle();

      verify(() => mockAuthRepository.updateProfile(
            userId: 'u-profile-123',
            fullName: 'Tanvir Ahmed',
            avatarUrl: any(named: 'avatarUrl'),
          )).called(1);
    });
  });

  group('ProfileSettingsScreen Tests', () {
    final testProfile = UserProfile(
      id: 'u-profile-123',
      fullName: 'Tanvir Ahmed',
      phone: '+8801712345678',
      role: UserRole.customer,
      accountStatus: AccountStatus.approved,
      avatarUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    testWidgets('Renders user profile details and settings rows in Bengali', (tester) async {
      await tester.pumpWidget(
        createTestWidget(ProfileSettingsScreen(profile: testProfile), locale: const Locale('bn')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tanvir Ahmed'), findsOneWidget);
      expect(find.text('+8801712345678'), findsOneWidget);
      expect(find.text('জাতীয় পরিচয়পত্র যাচাইকৃত'), findsOneWidget);
      expect(find.text('সংরক্ষিত ঠিকানাসমূহ'), findsOneWidget);
      expect(find.text('লগআউট'), findsOneWidget);
    });

    testWidgets('Renders in English when English locale is provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(ProfileSettingsScreen(profile: testProfile), locale: const Locale('en')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tanvir Ahmed'), findsOneWidget);
      expect(find.text('+8801712345678'), findsOneWidget);
      expect(find.text('National ID Verified'), findsOneWidget);
      expect(find.text('Saved Addresses'), findsAtLeastNWidgets(1));
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('Triggers signOut on logout button tap', (tester) async {
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

      await tester.pumpWidget(
        createTestWidget(ProfileSettingsScreen(profile: testProfile)),
      );
      await tester.pumpAndSettle();

      final logoutFinder = find.text('লগআউট');
      await tester.ensureVisible(logoutFinder);
      await tester.tap(logoutFinder);
      await tester.pumpAndSettle();

      verify(() => mockAuthRepository.signOut()).called(1);
    });
  });
}
