import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';

/// Domain entity representing a registered user's public profile in KaajLagbe
@immutable
class UserProfile {
  final String id;
  final String? phone;
  final String? fullName;
  final UserRole role;
  final AccountStatus accountStatus;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    this.phone,
    this.fullName,
    required this.role,
    required this.accountStatus,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to parse PostgreSQL public.users record
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      role: UserRole.fromString(json['role'] as String? ?? 'customer'),
      accountStatus: AccountStatus.fromString(
        json['account_status'] as String? ?? 'pending_verification',
      ),
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  /// Converts UserProfile to a JSON map for Supabase update operations
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (phone != null) 'phone': phone,
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }

  UserProfile copyWith({
    String? id,
    String? phone,
    String? fullName,
    UserRole? role,
    AccountStatus? accountStatus,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      accountStatus: accountStatus ?? this.accountStatus,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convenience getters for permission and gate evaluations
  bool get isCustomer => role == UserRole.customer;
  bool get isLabour => role == UserRole.labour;
  bool get isAdmin => role == UserRole.admin;

  bool get isApproved => accountStatus == AccountStatus.approved;
  bool get isPending => accountStatus == AccountStatus.pendingVerification;
  bool get isRejected => accountStatus == AccountStatus.rejected;
  bool get isSuspended => accountStatus == AccountStatus.suspended;
  bool get isPermanentlyBanned => accountStatus == AccountStatus.permanentlyBanned;

  /// User has full active marketplace clearance
  bool get canAccessMarketplace => isApproved;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          phone == other.phone &&
          fullName == other.fullName &&
          role == other.role &&
          accountStatus == other.accountStatus &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      phone.hashCode ^
      fullName.hashCode ^
      role.hashCode ^
      accountStatus.hashCode ^
      avatarUrl.hashCode;

  @override
  String toString() {
    return 'UserProfile(id: $id, phone: $phone, fullName: $fullName, role: ${role.name}, accountStatus: ${accountStatus.name})';
  }
}
