import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/job/presentation/screens/on_site_checkin_timer_screen.dart';
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
          child: const OnSiteCheckinTimerScreen(),
        ),
      ),
    );
  }

  group('OnSiteCheckinTimerScreen Widget Tests', () {
    testWidgets('Renders all core on-site check-in & timer sections correctly in Bangla', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Top Header
      expect(find.text('সরাসরি কাজ ট্র্যাকিং'), findsOneWidget);

      // Arrival ribbon
      expect(find.text('কর্মী উপস্থিত'), findsOneWidget);
      expect(find.text('অন-সাইট'), findsOneWidget);

      // Card 1: Identity & Security PIN
      expect(find.text('কর্মী পরিচয় যাচাইকরণ'), findsOneWidget);
      expect(find.text('যাচাইকৃত ✓'), findsOneWidget);
      expect(find.text('রফিকুল ইসলাম'), findsOneWidget);
      expect(find.text('চেক-ইন সিকিউরিটি পিন'), findsOneWidget);
      expect(find.text('৭'), findsOneWidget);
      expect(find.text('৩'), findsOneWidget);
      expect(find.text('৯'), findsOneWidget);
      expect(find.text('২'), findsWidgets); // PIN digit and Step 2

      // Card 2: Timer & Actions
      expect(find.text('চলমান কাজের সময়'), findsOneWidget);
      expect(find.text('০১:২৪:৩৫'), findsOneWidget);
      expect(find.text('১ ঘণ্টা ২৪ মিনিট'), findsOneWidget);

      // Scroll down to see buttons & summary
      await tester.drag(find.byKey(const Key('on_site_checkin_timer_scroll_view')), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('take_break_button')), findsOneWidget);
      expect(find.byKey(const Key('complete_job_button')), findsOneWidget);

      // Scroll further down to summary & location
      await tester.drag(find.byKey(const Key('on_site_checkin_timer_scroll_view')), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Summary Card
      expect(find.textContaining('#KL-849204'), findsOneWidget);
      expect(find.text('ডিজিটাল পেমেন্ট সুরক্ষিত'), findsOneWidget);
      expect(find.byKey(const Key('help_dispute_button')), findsOneWidget);

      // Location Stamp
      expect(find.text('লাইভ জিও-ফেন্স সক্রিয়'), findsOneWidget);
      expect(find.text('রোড ৮/এ, ধানমন্ডি, ঢাকা'), findsOneWidget);
    });

    testWidgets('Tapping take break toggles break state and action label', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final breakBtn = find.byKey(const Key('take_break_button'));
      await tester.ensureVisible(breakBtn);
      await tester.pumpAndSettle();

      expect(breakBtn, findsOneWidget);
      expect(find.text('১৫ মিনিট বিরতি নিন'), findsOneWidget);

      await tester.tap(breakBtn);
      await tester.pumpAndSettle();

      expect(find.text('বিরতি শেষ করুন'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Tapping complete job shows preview only SnackBar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final completeBtn = find.byKey(const Key('complete_job_button'));
      await tester.ensureVisible(completeBtn);
      await tester.pumpAndSettle();

      expect(completeBtn, findsOneWidget);

      await tester.tap(completeBtn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Preview only'), findsOneWidget);
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
