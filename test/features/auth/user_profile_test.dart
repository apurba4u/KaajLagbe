import 'package:flutter_test/flutter_test.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/user_profile.dart';

void main() {
  group('UserProfile Entity Tests', () {
    test('Correctly deserializes from Postgres json record', () {
      final json = {
        'id': 'b883072b-87d4-4bb0-8ee2-78d2b7816866',
        'phone': '+8801712345678',
        'full_name': 'Rahim Uddin',
        'role': 'labour',
        'account_status': 'approved',
        'avatar_url': 'https://example.com/avatar.jpg',
        'created_at': '2026-11-04T10:00:00.000Z',
        'updated_at': '2026-11-04T11:00:00.000Z',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.id, 'b883072b-87d4-4bb0-8ee2-78d2b7816866');
      expect(profile.phone, '+8801712345678');
      expect(profile.fullName, 'Rahim Uddin');
      expect(profile.role, UserRole.labour);
      expect(profile.accountStatus, AccountStatus.approved);
      expect(profile.avatarUrl, 'https://example.com/avatar.jpg');
      expect(profile.isLabour, isTrue);
      expect(profile.isCustomer, isFalse);
      expect(profile.isAdmin, isFalse);
      expect(profile.isApproved, isTrue);
      expect(profile.canAccessMarketplace, isTrue);
    });

    test('Defaults to customer and pending_verification on missing json fields', () {
      final json = {
        'id': 'c883072b-87d4-4bb0-8ee2-78d2b7816877',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.role, UserRole.customer);
      expect(profile.accountStatus, AccountStatus.pendingVerification);
      expect(profile.isCustomer, isTrue);
      expect(profile.isApproved, isFalse);
      expect(profile.isPending, isTrue);
      expect(profile.canAccessMarketplace, isFalse);
    });

    test('Correctly serializes updates to JSON', () {
      final profile = UserProfile(
        id: 'user-123',
        phone: '+8801812345678',
        fullName: 'Karim Mia',
        role: UserRole.customer,
        accountStatus: AccountStatus.approved,
        avatarUrl: 'https://example.com/pic.png',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 2),
      );

      final json = profile.toJson();

      expect(json['id'], 'user-123');
      expect(json['phone'], '+8801812345678');
      expect(json['full_name'], 'Karim Mia');
      expect(json['avatar_url'], 'https://example.com/pic.png');
      // Role and account_status must not be serialized for client updates
      expect(json.containsKey('role'), isFalse);
      expect(json.containsKey('account_status'), isFalse);
    });

    test('copyWith updates fields correctly', () {
      final profile = UserProfile(
        id: 'user-123',
        fullName: 'Initial Name',
        role: UserRole.customer,
        accountStatus: AccountStatus.pendingVerification,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      );

      final updated = profile.copyWith(
        fullName: 'Updated Name',
        accountStatus: AccountStatus.approved,
      );

      expect(updated.id, 'user-123');
      expect(updated.fullName, 'Updated Name');
      expect(updated.accountStatus, AccountStatus.approved);
      expect(updated.role, UserRole.customer);
    });
  });
}
