import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/role_selection_screen.dart';
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
    when(() => mockUser.id).thenReturn('user-test-uuid');
    when(() => mockUser.userMetadata).thenReturn({});
    when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
  });

  Widget createTestWidget({Locale locale = const Locale('bn')}) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        currentAuthUserProvider.overrideWithValue(mockUser),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const RoleSelectionScreen(),
      ),
    );
  }

  testWidgets('Renders both Customer and Labour role options in Bengali', (tester) async {
    await tester.pumpWidget(createTestWidget(locale: const Locale('bn')));
    await tester.pumpAndSettle();

    expect(find.text('আমার সেবা প্রয়োজন'), findsOneWidget);
    expect(find.text('আমি কাজ করতে চাই'), findsOneWidget);
    expect(find.text('এগিয়ে যান'), findsOneWidget);
  });

  testWidgets('Renders both Customer and Labour role options in English', (tester) async {
    await tester.pumpWidget(createTestWidget(locale: const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('I need work done'), findsOneWidget);
    expect(find.text('I want to work'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Allows selecting Labour role and submitting', (tester) async {
    when(() => mockAuthRepository.setInitialRole(
          userId: any(named: 'userId'),
          role: UserRole.labour,
        )).thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Tap on Labour card
    final labourFinder = find.text('আমি কাজ করতে চাই');
    await tester.ensureVisible(labourFinder);
    await tester.tap(labourFinder);
    await tester.pumpAndSettle();

    // Tap Continue
    final continueFinder = find.text('এগিয়ে যান');
    await tester.ensureVisible(continueFinder);
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    verify(() => mockAuthRepository.setInitialRole(
          userId: 'user-test-uuid',
          role: UserRole.labour,
        )).called(1);

    expect(find.byType(ProfileSetupScreen), findsOneWidget);
  });
}
