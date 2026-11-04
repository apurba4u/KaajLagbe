import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:kaajlagbe/main.dart';

void main() {
  testWidgets('KaajLagbeApp smoke test initializes and renders root widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
