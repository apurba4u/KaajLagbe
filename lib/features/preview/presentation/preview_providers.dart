import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/domain/auth_repository.dart';
import '../../auth/domain/user_profile.dart';
import '../../../core/constants/app_constants.dart';
import '../../labour/domain/labour_profile.dart';
import '../../labour/domain/labour_repository.dart';
import '../../labour/domain/labour_skill.dart';
import '../../labour/domain/skill.dart';
import '../../verification/domain/identity_verification.dart';
import '../../verification/domain/verification_repository.dart';
import '../domain/preview_data.dart';

/// Currently selected demo persona in Design Preview Mode
final previewPersonaProvider = StateProvider<UserProfile>((ref) {
  return PreviewData.rahimCustomer;
});

/// Preview role selector (Customer / Labour / Admin)
final previewRoleFilterProvider = StateProvider<UserRole>((ref) {
  final current = ref.watch(previewPersonaProvider);
  return current.role;
});

/// Fake Auth Repository for in-memory operations (no network)
class FakeAuthRepository implements AuthRepository {
  final Ref _ref;
  final StreamController<AuthState> _authStateController =
      StreamController<AuthState>.broadcast();
  final Map<String, UserProfile> _profiles = {
    for (var p in PreviewData.allPersonas) p.id: p,
  };

  FakeAuthRepository(this._ref);

  @override
  Stream<AuthState> get authStateChanges => _authStateController.stream;

  @override
  User? get currentUser {
    final active = _ref.read(previewPersonaProvider);
    return User(
      id: active.id,
      appMetadata: {'provider': 'phone'},
      userMetadata: {
        'full_name': active.fullName,
        'role': active.role.name,
        'phone': active.phone,
      },
      aud: 'authenticated',
      createdAt: active.createdAt.toIso8601String(),
    );
  }

  @override
  Session? get currentSession {
    final user = currentUser;
    if (user == null) return null;
    return Session(
      accessToken: 'fake-preview-access-token',
      tokenType: 'bearer',
      user: user,
    );
  }

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    return _profiles[userId] ?? _ref.read(previewPersonaProvider);
  }

  @override
  Stream<UserProfile?> watchUserProfile(String userId) {
    return Stream.value(_profiles[userId] ?? _ref.read(previewPersonaProvider));
  }

  @override
  Future<void> setInitialRole({
    required String userId,
    required UserRole role,
  }) async {
    final UserProfile current = _profiles[userId] ?? _ref.read(previewPersonaProvider);
    final updated = UserProfile(
      id: current.id,
      role: role,
      accountStatus: current.accountStatus,
      fullName: current.fullName,
      phone: current.phone,
      avatarUrl: current.avatarUrl,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );
    _profiles[userId] = updated;
    _ref.read(previewPersonaProvider.notifier).state = updated;
  }

  @override
  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    final UserProfile current = _profiles[userId] ?? _ref.read(previewPersonaProvider);
    final updated = UserProfile(
      id: current.id,
      role: current.role,
      accountStatus: current.accountStatus,
      fullName: fullName ?? current.fullName,
      avatarUrl: avatarUrl ?? current.avatarUrl,
      phone: current.phone,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );
    _profiles[userId] = updated;
    _ref.read(previewPersonaProvider.notifier).state = updated;
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required List<int> bytes,
    required String fileExtension,
  }) async {
    return 'preview/avatar_$userId.$fileExtension';
  }

  @override
  Future<void> signInWithOtp({required String phone, Map<String, dynamic>? data}) async {}

  @override
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
    OtpType type = OtpType.sms,
  }) async {
    return AuthResponse(session: currentSession, user: currentUser);
  }

  @override
  Future<AuthResponse> signInWithDevPhone({
    required String phone,
    Map<String, dynamic>? data,
  }) async {
    return AuthResponse(session: currentSession, user: currentUser);
  }

  @override
  Future<void> signOut() async {}
}

/// Fake Labour Repository for in-memory operations (no network)
class FakeLabourRepository implements LabourRepository {
  final Map<String, LabourProfile> _profiles = {
    PreviewData.labour1Id: PreviewData.karimLabourProfile,
    PreviewData.labour2Id: PreviewData.jamalLabourProfile,
  };

  final Map<String, List<LabourSkill>> _skills = {
    PreviewData.labour1Id: List.from(PreviewData.karimSkills),
    PreviewData.labour2Id: List.from(PreviewData.jamalSkills),
  };

  @override
  Future<List<Skill>> getSkills() async {
    return PreviewData.platformSkills;
  }

  @override
  Future<LabourProfile?> getLabourProfile(String userId) async {
    return _profiles[userId] ??
        LabourProfile(
          id: 'lp-$userId',
          userId: userId,
          experience: '3 years experience',
          serviceArea: 'Dhaka City',
          expectedWage: 500.0,
          availability: 'Sat-Thu 09:00-18:00',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
  }

  @override
  Stream<LabourProfile?> watchLabourProfile(String userId) {
    return Stream.value(_profiles[userId] ??
        LabourProfile(
          id: 'lp-$userId',
          userId: userId,
          experience: '3 years experience',
          serviceArea: 'Dhaka City',
          expectedWage: 500.0,
          availability: 'Sat-Thu 09:00-18:00',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
  }

  @override
  Future<List<LabourSkill>> getLabourSkills(String userId) async {
    return _skills[userId] ?? [];
  }

  @override
  Stream<List<LabourSkill>> watchLabourSkills(String userId) {
    return Stream.value(_skills[userId] ?? []);
  }

  @override
  Future<void> upsertLabourProfile({
    required String userId,
    String? experience,
    String? serviceArea,
    double? expectedWage,
    String? availability,
  }) async {
    final existing = _profiles[userId];
    _profiles[userId] = LabourProfile(
      id: existing?.id ?? 'lp-$userId',
      userId: userId,
      experience: experience ?? existing?.experience,
      serviceArea: serviceArea ?? existing?.serviceArea,
      expectedWage: expectedWage ?? existing?.expectedWage,
      availability: availability ?? existing?.availability,
      createdAt: existing?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> syncLabourSkills({
    required String userId,
    required List<String> selectedSkillIds,
  }) async {
    final currentList = _skills[userId] ?? [];
    final existingMap = {for (var s in currentList) s.skillId: s};

    final updated = <LabourSkill>[];
    for (final skillId in selectedSkillIds) {
      if (existingMap.containsKey(skillId)) {
        updated.add(existingMap[skillId]!);
      } else {
        final platformSkill = PreviewData.platformSkills.firstWhere(
          (s) => s.id == skillId,
          orElse: () => Skill(id: skillId, name: 'Skill', nameBn: 'দক্ষতা'),
        );
        updated.add(LabourSkill(
          id: 'ls-preview-$skillId',
          labourId: userId,
          skillId: skillId,
          skillName: platformSkill.name,
          skillNameBn: platformSkill.nameBn,
          score: 0.0,
          badgeActive: false,
          createdAt: DateTime.now(),
        ));
      }
    }
    _skills[userId] = updated;
  }
}

/// Fake Verification Repository for in-memory operations (no network)
class FakeVerificationRepository implements VerificationRepository {
  final Map<String, IdentityVerification> _verifications = {
    PreviewData.labour3Id: PreviewData.pendingVerification,
    PreviewData.labour1Id: PreviewData.approvedVerification,
    'sample-user-rejected': PreviewData.rejectedVerification,
  };

  @override
  Future<IdentityVerification?> getLatestVerification(String userId) async {
    return _verifications[userId];
  }

  @override
  Stream<IdentityVerification?> watchLatestVerification(String userId) {
    return Stream.value(_verifications[userId]);
  }

  @override
  Future<String> uploadDocumentPhoto({
    required String userId,
    required Uint8List bytes,
    required String fileName,
    String contentType = 'image/jpeg',
  }) async {
    return 'preview/$userId/$fileName';
  }

  @override
  Future<IdentityVerification> submitVerification({
    required String userId,
    required String documentType,
    required String documentNumber,
    required String frontPath,
    String? backPath,
    required String selfiePath,
  }) async {
    final record = IdentityVerification(
      id: 'iv-sub-$userId',
      userId: userId,
      documentType: documentType,
      documentNumber: documentNumber,
      frontPath: frontPath,
      backPath: backPath,
      selfiePath: selfiePath,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    _verifications[userId] = record;
    return record;
  }

  List<IdentityVerification> getPendingVerifications() {
    return _verifications.values
        .where((v) => v.status == 'pending')
        .toList();
  }

  void reviewVerification({
    required String verificationId,
    required String status,
    String? rejectionReason,
  }) {
    final entry = _verifications.entries.firstWhere(
      (e) => e.value.id == verificationId,
      orElse: () => _verifications.entries.first,
    );

    final updated = IdentityVerification(
      id: entry.value.id,
      userId: entry.value.userId,
      documentType: entry.value.documentType,
      documentNumber: entry.value.documentNumber,
      frontPath: entry.value.frontPath,
      backPath: entry.value.backPath,
      selfiePath: entry.value.selfiePath,
      status: status,
      rejectionReason: rejectionReason,
      adminId: PreviewData.adminId,
      createdAt: entry.value.createdAt,
      reviewedAt: DateTime.now(),
    );

    _verifications[entry.key] = updated;
  }
}

/// Singleton fake repositories for the preview session
final fakeAuthRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  return FakeAuthRepository(ref);
});

final fakeLabourRepositoryProvider = Provider<FakeLabourRepository>((ref) {
  return FakeLabourRepository();
});

final fakeVerificationRepositoryProvider =
    Provider<FakeVerificationRepository>((ref) {
  return FakeVerificationRepository();
});

