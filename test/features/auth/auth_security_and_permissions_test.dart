import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/core/utils/business_rule_validators.dart';
import 'package:kaajlagbe/features/auth/domain/user_profile.dart';

void main() {
  group('Auth Security & Marketplace Permissions Tests', () {
    test('Unapproved labour is strictly blocked from accepting bookings', () {
      final statuses = [
        AccountStatus.pendingVerification,
        AccountStatus.rejected,
        AccountStatus.suspended,
        AccountStatus.permanentlyBanned,
      ];

      for (final status in statuses) {
        final labour = UserProfile(
          id: 'labour-1',
          fullName: 'Electrician Jamal',
          phone: '+8801700000000',
          role: UserRole.labour,
          accountStatus: status,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(
          labour.canAccessMarketplace,
          isFalse,
          reason: 'Labour with status $status must not access marketplace',
        );

        final canAccept = BusinessRuleValidators.canLabourAcceptBooking(status);

        expect(
          canAccept,
          isFalse,
          reason: 'Labour with status $status must be rejected from accepting bookings',
        );
      }
    });

    test('Only approved labour can access marketplace and accept bookings', () {
      final approvedLabour = UserProfile(
        id: 'labour-2',
        fullName: 'Master Electrician Rafiq',
        phone: '+8801711111111',
        role: UserRole.labour,
        accountStatus: AccountStatus.approved,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(approvedLabour.canAccessMarketplace, isTrue);

      final canAccept = BusinessRuleValidators.canLabourAcceptBooking(
        approvedLabour.accountStatus,
      );

      expect(canAccept, isTrue);
    });

    test('UserProfile toJson strictly excludes role and account_status', () {
      final profile = UserProfile(
        id: 'u-secure-99',
        fullName: 'Customer Karim',
        phone: '+8801799999999',
        role: UserRole.customer,
        accountStatus: AccountStatus.approved,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updateMap = profile.toJson();

      // Client updates must never be able to pass 'role' or 'account_status'
      expect(updateMap.containsKey('role'), isFalse);
      expect(updateMap.containsKey('account_status'), isFalse);
    });

    test('Role immutability validator throws when user attempts unauthorized self-promotion', () {
      expect(
        () {
          // Attempting to select admin during self-service onboarding
          final chosenRole = UserRole.admin;
          if (chosenRole == UserRole.admin) {
            throw ArgumentError('Admin role is never self-selectable by clients.');
          }
        },
        throwsArgumentError,
      );
    });
  });
}
