/// KaajLagbe Application Core Constants
class AppConstants {
  AppConstants._();

  static const String appName = 'KaajLagbe';
  static const String appTagline = 'Verified Labour Finding & Booking Marketplace';
  static const String currencySymbol = '৳';

  // Scoring and Badging Constants (Server-enforced, mirrored client-side for display)
  static const double badgeThreshold = 200.0;
  static const double positiveVoteWeight = 1.0;
  static const double negativeVoteWeight = -0.5;

  // Default Standard Labour Skills
  static const List<String> supportedSkills = [
    'Electrician',
    'Plumber',
    'Cleaner',
    'Painter',
    'Gardener',
    'Carpenter',
    'Moving Helper',
  ];
}

/// User Roles in KaajLagbe
enum UserRole {
  customer,
  labour,
  admin;

  String get value => name;

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'labour':
        return UserRole.labour;
      case 'admin':
        return UserRole.admin;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }
}

/// Account Statuses
enum AccountStatus {
  pendingVerification,
  approved,
  rejected,
  suspended,
  permanentlyBanned;

  String get value => name;

  static AccountStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AccountStatus.approved;
      case 'rejected':
        return AccountStatus.rejected;
      case 'suspended':
        return AccountStatus.suspended;
      case 'permanentlybanned':
      case 'permanently_banned':
      case 'banned':
        return AccountStatus.permanentlyBanned;
      case 'pendingverification':
      case 'pending_verification':
      default:
        return AccountStatus.pendingVerification;
    }
  }
}

/// Booking Lifecycle Statuses
enum BookingStatus {
  pending,
  accepted,
  confirmed,
  inProgress,
  completed,
  cancelled,
  disputed;

  String get value => name;

  static BookingStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return BookingStatus.accepted;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'inprogress':
      case 'in_progress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'disputed':
        return BookingStatus.disputed;
      case 'pending':
      default:
        return BookingStatus.pending;
    }
  }
}
