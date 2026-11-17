import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/chat/presentation/screens/chat_agreement_screen.dart';
import 'package:kaajlagbe/features/customer/presentation/screens/customer_bookings_screen.dart';
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
          child: const CustomerBookingsScreen(),
        ),
      ),
    );
  }

  group('CustomerBookingsScreen Widget Tests', () {
    testWidgets('Renders all core booking tracking sections correctly in Bangla', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Header & Stats
      expect(find.text('আমার বুকিংসমূহ'), findsWidgets);
      expect(find.text('১১টি মোট'), findsOneWidget);

      // Status tabs
      expect(find.text('চলমান'), findsOneWidget);
      expect(find.text('আসন্ন'), findsOneWidget);

      // In-progress card
      expect(find.textContaining('KL-849204'), findsOneWidget);
      expect(find.text('রফিকুল ইসলাম'), findsOneWidget);
      expect(find.text('ডিজিটাল পেমেন্ট সুরক্ষিত'), findsOneWidget);
      expect(find.byKey(const Key('live_tracking_btn')), findsOneWidget);
      expect(find.byKey(const Key('booking_chat_btn')), findsOneWidget);

      // Scroll to next scheduled section
      await tester.drag(find.byKey(const Key('customer_bookings_scroll_view')), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(find.text('ফুল হাউস ডিপ ক্লিনিং'), findsOneWidget);
      expect(find.text('মোছাঃ সালমা বেগম'), findsOneWidget);
    });

    testWidgets('Tapping chat button navigates to ChatAgreementScreen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final chatBtn = find.byKey(const Key('booking_chat_btn'));
      expect(chatBtn, findsOneWidget);

      await tester.tap(chatBtn);
      await tester.pumpAndSettle();

      expect(find.byType(ChatAgreementScreen), findsOneWidget);
    });

    testWidgets('Tapping live tracking button shows Preview only SnackBar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final trackingBtn = find.byKey(const Key('live_tracking_btn'));
      expect(trackingBtn, findsOneWidget);

      await tester.tap(trackingBtn);
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
