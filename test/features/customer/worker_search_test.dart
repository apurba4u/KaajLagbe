import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/customer/presentation/screens/worker_search_screen.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';

void main() {
  Widget buildTestWidget({
    Locale locale = const Locale('bn'),
  }) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const WorkerSearchScreen(),
      ),
    );
  }

  group('WorkerSearchScreen Widget Tests', () {
    testWidgets('Renders search bar, filter chips, and fake workers in Bangla', (tester) async {
      await tester.pumpWidget(buildTestWidget(locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Locality radius pill
      expect(find.text('মিরপুর ও ধানমণ্ডি (৪.৫ কিমি ব্যাসার্ধ)'), findsOneWidget);

      // Filter chips
      expect(find.text('যাচাইকৃত শুধু ✓'), findsOneWidget);
      expect(find.text('রেটিং ৪.৫+ ★'), findsOneWidget);
      expect(find.text('আজই সম্ভব'), findsOneWidget);

      // Results count
      expect(find.text('৩৮ জন যাচাইকৃত কর্মী পাওয়া গেছে'), findsOneWidget);

      // Fake worker cards
      expect(find.textContaining('Karim Mia'), findsOneWidget);
      expect(find.textContaining('Jamal Hossain'), findsOneWidget);
      expect(find.textContaining('Nasir Ahmed'), findsOneWidget);

      // Reset filter box
      expect(find.text('ফিল্টার রিসেট'), findsOneWidget);

      // Floating filter pill
      expect(find.text('সব ফিল্টার ও রেঞ্জ'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Toggles filter chip when tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget(locale: const Locale('bn')));
      await tester.pumpAndSettle();

      final todayChip = find.text('আজই সম্ভব');
      expect(todayChip, findsOneWidget);

      await tester.tap(todayChip);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Does not overflow at 320x640 with textScaler 1.3 in Bangla', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale: Locale('bn'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(320, 640),
                textScaler: TextScaler.linear(1.3),
              ),
              child: WorkerSearchScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
