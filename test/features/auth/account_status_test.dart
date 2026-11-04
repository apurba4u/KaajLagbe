import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/account_status_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget createTestWidget(AccountStatus status) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      child: MaterialApp(
        home: AccountStatusScreen(status: status),
      ),
    );
  }

  group('AccountStatusScreen Tests', () {
    testWidgets('Pending status displays verification progress and lock banner', (tester) async {
      await tester.pumpWidget(createTestWidget(AccountStatus.pendingVerification));
      await tester.pumpAndSettle();

      expect(find.textContaining('যাচাইকরণ প্রক্রিয়াধীন'), findsAtLeastNWidgets(1));
      expect(find.text('যাচাইকরণ অগ্রগতি / Verification Progress'), findsOneWidget);
      expect(find.text('মার্কেটপ্লেস সুরক্ষা নীতি'), findsOneWidget);
      expect(find.text('স্ট্যাটাস রিফ্রেশ করুন / Check Status'), findsOneWidget);
    });

    testWidgets('Rejected status displays rejection notice and helpline', (tester) async {
      await tester.pumpWidget(createTestWidget(AccountStatus.rejected));
      await tester.pumpAndSettle();

      expect(find.textContaining('আবেদন প্রত্যাখ্যাত'), findsAtLeastNWidgets(1));
      expect(find.textContaining('১৬৪২০'), findsOneWidget);
    });

    testWidgets('Suspended status displays suspended notice', (tester) async {
      await tester.pumpWidget(createTestWidget(AccountStatus.suspended));
      await tester.pumpAndSettle();

      expect(find.textContaining('অ্যাকাউন্ট সাময়িক স্থগিত'), findsAtLeastNWidgets(1));
    });

    testWidgets('Permanently Banned status displays banned notice', (tester) async {
      await tester.pumpWidget(createTestWidget(AccountStatus.permanentlyBanned));
      await tester.pumpAndSettle();

      expect(find.textContaining('অ্যাকাউন্ট স্থায়ীভাবে নিষিদ্ধ'), findsAtLeastNWidgets(1));
    });

    testWidgets('Sign out button calls AuthRepository.signOut', (tester) async {
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget(AccountStatus.pendingVerification));
      await tester.pumpAndSettle();

      final signOutBtn = find.text('লগআউট / Sign Out');
      await tester.ensureVisible(signOutBtn);
      await tester.tap(signOutBtn);
      await tester.pumpAndSettle();

      verify(() => mockAuthRepository.signOut()).called(1);
    });
  });
}
