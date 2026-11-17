import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/booking/presentation/screens/booking_request_screen.dart';
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
          child: const BookingRequestScreen(),
        ),
      ),
    );
  }

  group('BookingRequestScreen Widget Tests', () {
    testWidgets('Renders all core booking sections correctly in Bangla', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // App bar & Stepper
      expect(find.text('তাৎক্ষণিক বুকিং'), findsOneWidget);
      expect(find.text('১. কাজ'), findsOneWidget);
      expect(find.text('২. সময় ও বিরতি'), findsOneWidget);

      // Worker snapshot
      expect(find.text('রফিকুল ইসলাম'), findsOneWidget);
      expect(find.text('NID ভেরিফায়েড'), findsOneWidget);

      // Overlap guard
      expect(find.textContaining('সময়সূচী উপলব্ধ'), findsOneWidget);

      // Cost breakdown & CTA
      expect(find.text('খরচের বিস্তারিত বিবরণ'), findsOneWidget);
      expect(find.byKey(const Key('confirm_booking_btn')), findsOneWidget);
    });

    testWidgets('Tapping confirm booking button shows Preview only SnackBar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final confirmBtn = find.byKey(const Key('confirm_booking_btn'));
      expect(confirmBtn, findsOneWidget);

      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('পরবর্তী ফেজে'), findsOneWidget);
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
