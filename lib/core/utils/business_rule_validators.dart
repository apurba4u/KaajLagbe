import '../constants/app_constants.dart';

/// Business Rule Validators for Core Invariants in KaajLagbe.
class BusinessRuleValidators {
  BusinessRuleValidators._();

  /// Validates work-hour interval matching.
  ///
  /// Customer booking is confirmed ONLY if the customer's required interval
  /// falls entirely within the labour's available interval.
  /// Identical durations with non-overlapping hours (e.g., 09:00-13:00 vs 15:00-19:00) must return false.
  static bool isWorkHourMatching({
    required DateTime customerStartTime,
    required DateTime customerEndTime,
    required DateTime labourAvailableStart,
    required DateTime labourAvailableEnd,
  }) {
    if (!customerStartTime.isBefore(customerEndTime)) {
      return false;
    }
    if (!labourAvailableStart.isBefore(labourAvailableEnd)) {
      return false;
    }

    // Customer window must be completely contained within Labour's available interval
    final startsAfterOrAt = customerStartTime.isAtSameMomentAs(labourAvailableStart) ||
        customerStartTime.isAfter(labourAvailableStart);
    final endsBeforeOrAt = customerEndTime.isAtSameMomentAs(labourAvailableEnd) ||
        customerEndTime.isBefore(labourAvailableEnd);

    return startsAfterOrAt && endsBeforeOrAt;
  }

  /// Calculates skill score based on positive (+1) and negative (-0.5) votes.
  /// Floor is strictly 0.0 (never negative).
  static double calculateSkillScore({
    required int positiveVotes,
    required int negativeVotes,
  }) {
    final rawScore = (positiveVotes * AppConstants.positiveVoteWeight) +
        (negativeVotes * AppConstants.negativeVoteWeight);
    return rawScore < 0.0 ? 0.0 : rawScore;
  }

  /// Determines if a Labour earns an active badge for a specific skill.
  /// Badge earned when skill score >= 200.0.
  static bool isBadgeActive(double skillScore) {
    return skillScore >= AppConstants.badgeThreshold;
  }

  /// Checks whether a Labour account has permission to accept a booking.
  /// Unapproved accounts (pending, rejected, suspended, banned) CANNOT accept bookings.
  static bool canLabourAcceptBooking(AccountStatus status) {
    return status == AccountStatus.approved;
  }

  /// Checks if a payment transaction can be marked as paid.
  /// Failed or non-completed payments must NEVER be marked paid.
  static bool canMarkPaymentAsPaid({
    required bool gatewaySuccess,
    required String? idempotencyKey,
    required Set<String> processedIdempotencyKeys,
  }) {
    if (!gatewaySuccess) {
      return false;
    }
    if (idempotencyKey == null || idempotencyKey.trim().isEmpty) {
      return false;
    }
    // Prevent duplicate processing
    if (processedIdempotencyKeys.contains(idempotencyKey)) {
      return false;
    }
    return true;
  }
}
