import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/user_profile.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/verification/domain/identity_verification.dart';
import 'package:kaajlagbe/features/verification/domain/verification_repository.dart';
import 'package:kaajlagbe/features/verification/presentation/screens/identity_verification_screen.dart';
import 'package:kaajlagbe/features/verification/presentation/verification_providers.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockVerificationRepository extends Mock implements VerificationRepository {}

void main() {
  late MockVerificationRepository mockVerificationRepository;

  final testUser = UserProfile(
    id: 'user-test-123',
    role: UserRole.labour,
    accountStatus: AccountStatus.pendingVerification,
    fullName: 'Test Worker',
    phone: '+8801800000001',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  setUp(() {
    mockVerificationRepository = MockVerificationRepository();
  });

  Widget createTestWidget({
    IdentityVerification? currentVerification,
    Locale locale = const Locale('bn'),
  }) {
    return ProviderScope(
      overrides: [
        currentUserProfileProvider.overrideWith((ref) => Stream.value(testUser)),
        currentVerificationStreamProvider.overrideWith((ref) => Stream.value(currentVerification)),
        verificationRepositoryProvider.overrideWithValue(mockVerificationRepository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const IdentityVerificationScreen(),
      ),
    );
  }

  group('IdentityVerification Domain Model Tests', () {
    test('Correctly parses JSON record', () {
      final json = {
        'id': 'v-1',
        'user_id': 'u-1',
        'document_type': 'nid',
        'document_number': '19881029381',
        'front_path': 'u-1/front.jpg',
        'back_path': 'u-1/back.jpg',
        'selfie_path': 'u-1/selfie.jpg',
        'status': 'pending',
        'admin_id': null,
        'rejection_reason': null,
        'created_at': '2026-11-04T12:00:00.000Z',
        'reviewed_at': null,
      };

      final record = IdentityVerification.fromJson(json);
      expect(record.id, 'v-1');
      expect(record.isPending, isTrue);
      expect(record.isApproved, isFalse);
      expect(record.isRejected, isFalse);
      expect(record.documentNumber, '19881029381');
    });

    test('Correctly handles approved and rejected states', () {
      final approved = IdentityVerification(
        id: 'v-2',
        userId: 'u-1',
        documentType: 'passport',
        documentNumber: 'A12345678',
        frontPath: 'u-1/pass.jpg',
        selfiePath: 'u-1/selfie.jpg',
        status: 'approved',
        adminId: 'admin-1',
        rejectionReason: null,
        createdAt: DateTime.now(),
        reviewedAt: DateTime.now(),
      );
      expect(approved.isApproved, isTrue);
      expect(approved.isPending, isFalse);

      final rejected = approved.copyWith(
        status: 'rejected',
        rejectionReason: 'Blurry photo',
      );
      expect(rejected.isRejected, isTrue);
      expect(rejected.rejectionReason, 'Blurry photo');
    });
  });

  group('IdentityVerificationScreen Widget Tests', () {
    testWidgets('Renders screen with unsubmitted state in Bengali', (tester) async {
      await tester.pumpWidget(createTestWidget(currentVerification: null));
      await tester.pumpAndSettle();

      expect(find.text('জাতীয় পরিচয়পত্র যাচাই'), findsOneWidget);
      expect(find.text('এখনও জমা দেওয়া হয়নি'), findsOneWidget);
      expect(find.text('জাতীয় পরিচয়পত্র'), findsOneWidget);
      expect(find.text('পাসপোর্ট'), findsOneWidget);
      expect(find.text('যাচাইয়ের জন্য জমা দিন'), findsOneWidget);
    });

    testWidgets('Shows validation error when submitting empty fields', (tester) async {
      await tester.pumpWidget(createTestWidget(currentVerification: null));
      await tester.pumpAndSettle();

      final submitBtn = find.text('যাচাইয়ের জন্য জমা দিন');
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('সঠিক ডকুমেন্ট নম্বর দিন'), findsOneWidget);
    });

    testWidgets('Renders pending review status card when verification is in progress', (tester) async {
      final pendingRecord = IdentityVerification(
        id: 'v-pending',
        userId: testUser.id,
        documentType: 'nid',
        documentNumber: '19881029381',
        frontPath: 'u/front.jpg',
        backPath: 'u/back.jpg',
        selfiePath: 'u/selfie.jpg',
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createTestWidget(currentVerification: pendingRecord));
      await tester.pumpAndSettle();

      expect(find.text('যাচাই প্রক্রিয়াধীন (১-৪ ঘণ্টা)'), findsOneWidget);
      expect(find.textContaining('19881029381'), findsOneWidget);

      // Submit button is disabled in pending state
      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('Renders rejected status card with reason and active resubmit button', (tester) async {
      final rejectedRecord = IdentityVerification(
        id: 'v-rejected',
        userId: testUser.id,
        documentType: 'nid',
        documentNumber: '19881029381',
        frontPath: 'u/front.jpg',
        backPath: 'u/back.jpg',
        selfiePath: 'u/selfie.jpg',
        status: 'rejected',
        rejectionReason: 'ছবির টেক্সট অস্পষ্ট',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createTestWidget(currentVerification: rejectedRecord));
      await tester.pumpAndSettle();

      expect(find.text('যাচাইকরণ প্রত্যাখ্যাত হয়েছে'), findsOneWidget);
      expect(find.textContaining('ছবির টেক্সট অস্পষ্ট'), findsOneWidget);

      final resubmitBtn = find.text('পুনরায় যাচাইয়ের আবেদন করুন');
      await tester.ensureVisible(resubmitBtn);
      expect(resubmitBtn, findsOneWidget);
    });

    testWidgets('Attaching sample documents updates upload cards to attached state', (tester) async {
      await tester.pumpWidget(createTestWidget(currentVerification: null));
      await tester.pumpAndSettle();

      expect(find.text('Take Photo or Choose File'), findsNWidgets(3));

      // Tap first upload card (Front)
      await tester.tap(find.text('Take Photo or Choose File').first);
      await tester.pumpAndSettle();

      expect(find.text('nid_front.jpg'), findsOneWidget);
    });
  });
}
