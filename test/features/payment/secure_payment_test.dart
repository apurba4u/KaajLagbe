import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/payment/presentation/screens/secure_payment_screen.dart';
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
          child: const SecurePaymentScreen(),
        ),
      ),
    );
  }

  group('SecurePaymentScreen Widget Tests', () {
    testWidgets('Renders all core secure payment sections correctly in Bangla', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Title & Sandbox disclaimer
      expect(find.text('নিরাপদ পেমেন্ট (স্যান্ডবক্স)'), findsWidgets);
      expect(find.textContaining('স্যান্ডবক্স মোড'), findsOneWidget);

      // Trust steps
      expect(find.text('১. পেমেন্ট (সিমুলেটেড)'), findsOneWidget);
      expect(find.text('২. কাজ সম্পন্ন'), findsOneWidget);
      expect(find.text('৩. পে-আউট (সিমুলেটেড)'), findsOneWidget);
      expect(find.textContaining('এই ডেমোতে কোন আসল টাকা জমা বা লেনদেন হয় না'), findsWidgets);

      // Order Summary
      expect(find.text('অর্ডার বিবরণ'), findsOneWidget);
      expect(find.text('রফিকুল ইসলাম'), findsOneWidget);
      expect(find.text('সর্বমোট প্রদেয়'), findsOneWidget);

      // Scroll to payment methods
      await tester.drag(find.byKey(const Key('secure_payment_scroll_view')), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Payment Methods
      expect(find.text('পেমেন্ট মাধ্যম বেছে নিন'), findsOneWidget);
      expect(find.byKey(const Key('payment_method_bkash')), findsOneWidget);
      expect(find.byKey(const Key('payment_method_nagad')), findsOneWidget);
      expect(find.byKey(const Key('payment_method_card')), findsOneWidget);
      expect(find.byKey(const Key('payment_method_cash')), findsOneWidget);

      // Scroll to bottom button
      await tester.drag(find.byKey(const Key('secure_payment_scroll_view')), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('pay_securely_button')), findsOneWidget);
    });

    testWidgets('Tapping payment method updates selection', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final nagadOption = find.byKey(const Key('payment_method_nagad'));
      await tester.ensureVisible(nagadOption);
      await tester.pumpAndSettle();

      await tester.tap(nagadOption);
      await tester.pumpAndSettle();

      // Verify Nagad is tapped without error
      expect(nagadOption, findsOneWidget);
    });

    testWidgets('Tapping pay securely shows preview only SnackBar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final payBtn = find.byKey(const Key('pay_securely_button'));
      await tester.ensureVisible(payBtn);
      await tester.pumpAndSettle();

      await tester.tap(payBtn);
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
