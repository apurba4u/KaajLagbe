import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import 'user_profile.dart';

/// Contract for Authentication and Profile Management in KaajLagbe
abstract class AuthRepository {
  /// Initiates SMS OTP phone authentication
  Future<void> signInWithOtp({
    required String phone,
    Map<String, dynamic>? data,
  });

  /// Verifies the 6-digit phone OTP code and establishes an authenticated session
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
    OtpType type = OtpType.sms,
  });

  /// Signs the currently authenticated user out
  Future<void> signOut();

  /// Gets the active Supabase authentication session
  Session? get currentSession;

  /// Gets the currently authenticated user
  User? get currentUser;

  /// Stream of Supabase Auth state changes
  Stream<AuthState> get authStateChanges;

  /// Fetches the profile corresponding to [userId] from public.users
  Future<UserProfile?> getUserProfile(String userId);

  /// Streams real-time updates for a user's profile
  Stream<UserProfile?> watchUserProfile(String userId);

  /// Updates editable profile fields (full name, avatar URL)
  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  });

  /// Sets the initial role ('customer' or 'labour') for newly signed up users
  Future<void> setInitialRole({
    required String userId,
    required UserRole role,
  });

  /// Uploads avatar image bytes to the 'avatars' storage bucket and updates public.users
  Future<String> uploadAvatar({
    required String userId,
    required List<int> bytes,
    required String fileExtension,
  });
}

