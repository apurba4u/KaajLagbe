import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/auth_repository.dart';
import '../domain/user_profile.dart';

/// Supabase implementation of the [AuthRepository] interface
class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase;

  SupabaseAuthRepository(this._supabase);

  @override
  Future<void> signInWithOtp({
    required String phone,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _supabase.auth.signInWithOtp(
        phone: phone,
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
    OtpType type = OtpType.sms,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        phone: phone,
        token: token,
        type: type,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Session? get currentSession => _supabase.auth.currentSession;

  @override
  User? get currentUser => _supabase.auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }
      return UserProfile.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<UserProfile?> watchUserProfile(String userId) {
    return _supabase
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((records) {
          if (records.isEmpty) return null;
          return UserProfile.fromJson(records.first);
        });
  }

  @override
  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };
      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await _supabase.from('users').update(updates).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setInitialRole({
    required String userId,
    required UserRole role,
  }) async {
    if (role != UserRole.customer && role != UserRole.labour) {
      throw ArgumentError('Only Customer or Labour role can be selected.');
    }

    try {
      // First attempt server-side RPC if configured in DB
      await _supabase.rpc('set_initial_role', params: {'chosen_role': role.value});
    } catch (_) {
      // Direct update fallback (for when role can be initially populated)
      await _supabase.from('users').update({
        'role': role.value,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', userId);
    }
  }
}
