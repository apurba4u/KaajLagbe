import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/main.dart';

void main() {
  testWidgets('KaajLagbeApp smoke test displays app title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: KaajLagbeApp(),
      ),
    );

    expect(find.text(AppConstants.appName), findsOneWidget);
  });
}
