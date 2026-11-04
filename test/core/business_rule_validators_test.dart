import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/core/utils/business_rule_validators.dart';

void main() {
  group('BusinessRuleValidators - Work-Hour Matching', () {
    final baseDate = DateTime(2026, 11, 10);

    test('Same duration with non-overlapping intervals must fail', () {
      final customerStart = baseDate.add(const Duration(hours: 9));
      final customerEnd = baseDate.add(const Duration(hours: 13));

      final labourStart = baseDate.add(const Duration(hours: 15));
      final labourEnd = baseDate.add(const Duration(hours: 19));

      final result = BusinessRuleValidators.isWorkHourMatching(
        customerStartTime: customerStart,
        customerEndTime: customerEnd,
        labourAvailableStart: labourStart,
        labourAvailableEnd: labourEnd,
      );

      expect(result, isFalse);
    });

    test('Customer interval completely within Labour availability must pass', () {
      final customerStart = baseDate.add(const Duration(hours: 10));
      final customerEnd = baseDate.add(const Duration(hours: 14));

      final labourStart = baseDate.add(const Duration(hours: 8));
      final labourEnd = baseDate.add(const Duration(hours: 17));

      final result = BusinessRuleValidators.isWorkHourMatching(
        customerStartTime: customerStart,
        customerEndTime: customerEnd,
        labourAvailableStart: labourStart,
        labourAvailableEnd: labourEnd,
      );

      expect(result, isTrue);
    });

    test('Customer interval exceeding Labour availability must fail', () {
      final customerStart = baseDate.add(const Duration(hours: 8));
      final customerEnd = baseDate.add(const Duration(hours: 18));

      final labourStart = baseDate.add(const Duration(hours: 9));
      final labourEnd = baseDate.add(const Duration(hours: 17));

      final result = BusinessRuleValidators.isWorkHourMatching(
        customerStartTime: customerStart,
        customerEndTime: customerEnd,
        labourAvailableStart: labourStart,
        labourAvailableEnd: labourEnd,
      );

      expect(result, isFalse);
    });
  });

  group('BusinessRuleValidators - Skill Score & Badges', () {
    test('Positive votes add 1.0, negative votes deduct 0.5', () {
      final score = BusinessRuleValidators.calculateSkillScore(
        positiveVotes: 10,
        negativeVotes: 4,
      );
      // 10*1.0 - 4*0.5 = 8.0
      expect(score, equals(8.0));
    });

    test('Skill score floor is strictly 0.0 and never negative', () {
      final score = BusinessRuleValidators.calculateSkillScore(
        positiveVotes: 2,
        negativeVotes: 10,
      );
      // 2 - 5 = -3 -> floor at 0.0
      expect(score, equals(0.0));
    });

    test('Badge becomes active only at score >= 200.0', () {
      expect(BusinessRuleValidators.isBadgeActive(199.5), isFalse);
      expect(BusinessRuleValidators.isBadgeActive(200.0), isTrue);
      expect(BusinessRuleValidators.isBadgeActive(250.0), isTrue);
    });
  });

  group('BusinessRuleValidators - Booking Acceptance Permissions', () {
    test('Only approved accounts can accept bookings', () {
      expect(
        BusinessRuleValidators.canLabourAcceptBooking(AccountStatus.approved),
        isTrue,
      );
      expect(
        BusinessRuleValidators.canLabourAcceptBooking(AccountStatus.pendingVerification),
        isFalse,
      );
      expect(
        BusinessRuleValidators.canLabourAcceptBooking(AccountStatus.rejected),
        isFalse,
      );
      expect(
        BusinessRuleValidators.canLabourAcceptBooking(AccountStatus.suspended),
        isFalse,
      );
      expect(
        BusinessRuleValidators.canLabourAcceptBooking(AccountStatus.permanentlyBanned),
        isFalse,
      );
    });
  });

  group('BusinessRuleValidators - Payments & Idempotency', () {
    test('Failed gateway payment is never marked paid', () {
      final result = BusinessRuleValidators.canMarkPaymentAsPaid(
        gatewaySuccess: false,
        idempotencyKey: 'idemp-12345',
        processedIdempotencyKeys: {},
      );
      expect(result, isFalse);
    });

    test('Duplicate idempotency key is rejected', () {
      final processedKeys = {'idemp-already-processed'};
      final result = BusinessRuleValidators.canMarkPaymentAsPaid(
        gatewaySuccess: true,
        idempotencyKey: 'idemp-already-processed',
        processedIdempotencyKeys: processedKeys,
      );
      expect(result, isFalse);
    });

    test('Valid successful new payment with idempotency key is accepted', () {
      final result = BusinessRuleValidators.canMarkPaymentAsPaid(
        gatewaySuccess: true,
        idempotencyKey: 'idemp-new-payment',
        processedIdempotencyKeys: {'idemp-other'},
      );
      expect(result, isTrue);
    });
  });
}
