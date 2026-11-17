import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/dispute/presentation/screens/dispute_submission_screen.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';

void main() {
  Widget buildTestableWidget({
    Locale locale = const Locale('bn'),
    double textScaleFactor = 1.0,
    Size surfaceSize = const Size(390, 844),
  }) {
    return ProviderScope(
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('bn'),
          Locale('en'),
        ],
        home: MediaQuery(
          data: MediaQueryData(
            size: surfaceSize,
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: const DisputeSubmissionScreen(),
        ),
      ),
    );
  }

  group('DisputeSubmissionScreen Widget Tests', () {
    testWidgets('Renders all core dispute submission sections correctly in Bangla', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Title & Context Card
      expect(find.text('অভিযোগ ও বিরোধ নিষ্পত্তি'), findsOneWidget);
      expect(find.text('বিরোধ নিষ্পত্তি আবেদন'), findsOneWidget);
      expect(find.textContaining('KL-849204'), findsOneWidget);
      expect(find.textContaining('রফিকুল ইসলাম'), findsOneWidget);

      // Step 1: Categories
      expect(find.text('সমস্যার ধরন বেছে নিন'), findsOneWidget);
      expect(find.text('কাজের মান খারাপ বা অসমাপ্ত'), findsOneWidget);
      expect(find.text('দক্ষতার ঘাটতি ও অমিল'), findsOneWidget);

      // Scroll down
      await tester.drag(find.byKey(const Key('dispute_submission_scroll_view')), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Step 2: Description
      expect(find.text('বিস্তারিত বিবরণ'), findsOneWidget);
      expect(find.byKey(const Key('dispute_description_input')), findsOneWidget);

      // Scroll further down
      await tester.drag(find.byKey(const Key('dispute_submission_scroll_view')), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Step 3: Evidence
      expect(find.text('ছবি বা প্রমাণ সংযুক্ত করুন'), findsOneWidget);
      expect(find.text('fan_wiring_damage.jpg'), findsOneWidget);
      expect(find.byKey(const Key('attach_photo_btn')), findsOneWidget);
      expect(find.byKey(const Key('attach_receipt_btn')), findsOneWidget);

      // Scroll to bottom
      await tester.drag(find.byKey(const Key('dispute_submission_scroll_view')), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('তদন্ত ও ন্যায্য সমাধান নীতিমালা'), findsOneWidget);
      expect(find.byKey(const Key('submit_dispute_button')), findsOneWidget);
    });

    testWidgets('Selecting category and entering text works properly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final overchargeCat = find.byKey(const Key('dispute_category_overcharge'));
      await tester.ensureVisible(overchargeCat);
      await tester.pumpAndSettle();

      await tester.tap(overchargeCat);
      await tester.pumpAndSettle();

      final descInput = find.byKey(const Key('dispute_description_input'));
      await tester.ensureVisible(descInput);
      await tester.pumpAndSettle();

      await tester.enterText(descInput, 'অতিরিক্ত টাকা দাবি করা হয়েছে');
      await tester.pumpAndSettle();

      expect(find.text('অতিরিক্ত টাকা দাবি করা হয়েছে'), findsOneWidget);
    });

    testWidgets('Tapping submit shows confirmation SnackBar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final submitBtn = find.byKey(const Key('submit_dispute_button'));
      await tester.ensureVisible(submitBtn);
      await tester.pumpAndSettle();

      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('অভিযোগ গৃহীত হয়েছে'), findsOneWidget);
    });

    testWidgets('Does not overflow at 320x640 with textScaler 1.3 in Bangla', (tester) async {
      final flutterExceptionHandler = FlutterError.onError;
      FlutterErrorDetails? errorDetails;
      FlutterError.onError = (details) {
        if (details.toString().contains('overflowed') || details.toString().contains('RenderFlex')) {
          errorDetails = details;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(320, 640));
        await tester.pumpWidget(buildTestableWidget(
          surfaceSize: const Size(320, 640),
          textScaleFactor: 1.3,
        ));
        await tester.pumpAndSettle();

        expect(errorDetails, isNull, reason: 'Must not trigger RenderFlex overflow at 320px with textScaler 1.3');
      } finally {
        FlutterError.onError = flutterExceptionHandler;
      }
    });
  });
}
