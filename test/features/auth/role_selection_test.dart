import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/role_selection_screen.dart';

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

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        currentAuthUserProvider.overrideWithValue(mockUser),
      ],
      child: const MaterialApp(
        home: RoleSelectionScreen(),
      ),
    );
  }

  testWidgets('Renders both Customer and Labour role options', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('আমার সেবা প্রয়োজন'), findsOneWidget);
    expect(find.text('আমি কাজ করতে চাই'), findsOneWidget);
    expect(find.text('চালিয়ে যান / Continue'), findsOneWidget);
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
    final continueFinder = find.text('চালিয়ে যান / Continue');
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
