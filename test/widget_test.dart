import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:kaajlagbe/main.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  testWidgets('KaajLagbeApp smoke test initializes and renders root widget', (WidgetTester tester) async {
    final mockAuth = MockAuthRepository();
    when(() => mockAuth.currentSession).thenReturn(null);
    when(() => mockAuth.currentUser).thenReturn(null);
    when(() => mockAuth.authStateChanges).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuth),
          currentSessionProvider.overrideWithValue(null),
          currentAuthUserProvider.overrideWithValue(null),
        ],
        child: const KaajLagbeApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(KaajLagbeApp), findsOneWidget);
    expect(find.byType(PhoneLoginScreen), findsOneWidget);
  });
}
