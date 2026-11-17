import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/chat/presentation/screens/chat_agreement_screen.dart';
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
          child: const ChatAgreementScreen(),
        ),
      ),
    );
  }

  group('ChatAgreementScreen Widget Tests', () {
    testWidgets('Renders all core chat & agreement sections correctly in Bangla', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // App bar & Worker bar
      expect(find.text('সরাসরি চ্যাট'), findsOneWidget);
      expect(find.text('রফিকুল ইসলাম'), findsWidgets);
      expect(find.text('NID ভেরিফাইড'), findsOneWidget);
      expect(find.text('লাইভ বুকিং'), findsOneWidget);

      // Booking context
      expect(find.textContaining('KL-849204'), findsOneWidget);
      expect(find.text('নিশ্চিতকৃত'), findsOneWidget);

      // Security notice
      expect(find.textContaining('নিরাপত্তা বার্তা:'), findsOneWidget);

      // Scroll down to reveal digital agreement card
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Digital Agreement card
      expect(find.textContaining('ডিজিটাল চুক্তিপত্র'), findsOneWidget);
      expect(find.text('সম্মত ✓'), findsOneWidget);
    });

    testWidgets('Entering message and pressing send button adds bubble to stream', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final inputField = find.byType(TextField);
      expect(inputField, findsOneWidget);

      await tester.enterText(inputField, 'আমি বাসায় আছি, আপনি আসুন।');
      await tester.tap(find.byKey(const Key('chat_send_btn')));
      await tester.pumpAndSettle();

      expect(find.text('আমি বাসায় আছি, আপনি আসুন।'), findsOneWidget);
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
