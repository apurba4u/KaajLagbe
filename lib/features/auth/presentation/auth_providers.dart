import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/constants/app_constants.dart';
import '../data/supabase_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/user_profile.dart';

/// Provider exposing the repository contract
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepository(supabase);
});

/// Re-exposes the current active Supabase session
final currentSessionProvider = Provider<Session?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.value?.session ?? ref.watch(authRepositoryProvider).currentSession;
});

/// Re-exposes the currently authenticated Supabase user
final currentAuthUserProvider = Provider<User?>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.user ?? ref.watch(authRepositoryProvider).currentUser;
});

/// Streams real-time updates of the currently authenticated user's profile
final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(currentAuthUserProvider);
  if (user == null) {
    return Stream.value(null);
  }
  final repo = ref.watch(authRepositoryProvider);
  return repo.watchUserProfile(user.id);
});

/// Controller managing async authentication actions and UI loading states
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Send SMS OTP
  Future<bool> sendOtp({
    required String phone,
    UserRole? initialRole,
  }) async {
    state = const AsyncValue.loading();
    try {
      final meta = initialRole != null ? {'role': initialRole.value} : null;
      await _repository.signInWithOtp(phone: phone, data: meta);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Verify 6-digit OTP
  Future<AuthResponse?> verifyOtp({
    required String phone,
    required String token,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.verifyOtp(phone: phone, token: token);
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Select initial user role (Customer or Labour)
  Future<bool> setInitialRole(UserRole role) async {
    final user = _ref.read(currentAuthUserProvider);
    if (user == null) {
      state = AsyncValue.error(
        StateError('User must be authenticated to set role'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncValue.loading();
    try {
      await _repository.setInitialRole(userId: user.id, role: role);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Update user full name and/or avatar URL
  Future<bool> updateProfile({String? fullName, String? avatarUrl}) async {
    final user = _ref.read(currentAuthUserProvider);
    if (user == null) {
      state = AsyncValue.error(
        StateError('User must be authenticated to update profile'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncValue.loading();
    try {
      await _repository.updateProfile(
        userId: user.id,
        fullName: fullName,
        avatarUrl: avatarUrl,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Provider for the AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository, ref);
});
