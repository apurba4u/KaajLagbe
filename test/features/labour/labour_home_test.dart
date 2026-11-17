import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/features/labour/presentation/screens/labour_home_screen.dart';
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
        home: LabourHomeScreen(profile: PreviewData.karimLabour),
      ),
    );
  }

  group('LabourHomeScreen Widget Tests', () {
    testWidgets('Renders all core dashboard sections correctly in Bangla', (tester) async {
      await tester.pumpWidget(buildTestWidget(locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Top Header & Panel
      expect(find.text('শ্রমিক প্যানেল'), findsOneWidget);
      expect(find.text('অনলাইন'), findsWidgets);

      // Incoming job alert
      expect(find.text('নতুন কাজের অনুরোধ!'), findsOneWidget);
      expect(find.text('সিলিং ফ্যান ও শর্ট সার্কিট মেরামত'), findsOneWidget);
      expect(find.text('গ্রহণ করুন'), findsOneWidget);
      expect(find.text('প্রত্যাখ্যান'), findsOneWidget);

      // Quick Stats
      expect(find.text('আজকের আয়'), findsOneWidget);
      expect(find.text('পেন্ডিং পেআউট'), findsOneWidget);
      expect(find.text('সাপ্তাহিক টার্গেট'), findsOneWidget);

      // Upcoming schedule
      expect(find.text('আসন্ন শিডিউল'), findsOneWidget);
      expect(find.text('ডিবি সুইচবোর্ড সার্ভিসিং'), findsOneWidget);

      // Skill badges
      expect(find.text('দক্ষতা ও রেটিং ব্যাজ'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Toggles online status and accepts incoming job', (tester) async {
      await tester.pumpWidget(buildTestWidget(locale: const Locale('bn')));
      await tester.pumpAndSettle();

      // Tap online toggle button
      final toggleFinder = find.byKey(const Key('labour_online_toggle_btn'));
      expect(toggleFinder, findsOneWidget);
      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();

      expect(find.text('অফলাইন'), findsWidgets);

      // Tap accept job button
      final acceptBtn = find.text('গ্রহণ করুন');
      expect(acceptBtn, findsOneWidget);
      await tester.tap(acceptBtn);
      await tester.pumpAndSettle();

      expect(find.text('কাজটি গ্রহণ করা হয়েছে!'), findsOneWidget);
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
              child: LabourHomeScreen(profile: PreviewData.karimLabour),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
