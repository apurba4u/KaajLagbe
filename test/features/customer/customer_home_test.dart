import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/customer/presentation/screens/customer_home_screen.dart';
import 'package:kaajlagbe/features/preview/domain/preview_data.dart';
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
        home: CustomerHomeScreen(profile: PreviewData.rahimCustomer),
      ),
    );
  }

  group('CustomerHomeScreen Widget Tests', () {
    testWidgets('Renders all core marketplace sections correctly in Bangla', (tester) async {
      await tester.pumpWidget(buildTestWidget(locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Top Greeting
      expect(find.textContaining('রফিক'), findsWidgets);
      // NID assurance
      expect(find.text('১০০% জাতীয় পরিচয়পত্র (NID) যাচাইকৃত'), findsOneWidget);
      // En route card
      expect(find.text('কর্মী পথে আছেন (En Route)'), findsOneWidget);
      // Categories
      expect(find.text('জরুরি ও দৈনন্দিন সেবা'), findsOneWidget);
      expect(find.text('ইলেকট্রিশিয়ান'), findsWidgets);
      expect(find.text('প্লাম্বিং'), findsOneWidget);
      // Promotional banner
      expect(find.text('যেকোনো মেরামতে ৫০৳ ছাড়!'), findsOneWidget);
      // Safety Guarantee
      expect(find.text('কাজলাগবে সুরক্ষা নিশ্চয়তা'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders properly in English', (tester) async {
      await tester.pumpWidget(buildTestWidget(locale: const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('100% National ID (NID) Verified'), findsOneWidget);
      expect(find.text('Worker is en route'), findsOneWidget);
      expect(find.text('Emergency & Daily Services'), findsOneWidget);
      expect(find.text('KaajLagbe Safety Guarantee'), findsOneWidget);

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
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('bn'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(320, 640),
                textScaler: TextScaler.linear(1.3),
              ),
              child: CustomerHomeScreen(profile: PreviewData.rahimCustomer),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
