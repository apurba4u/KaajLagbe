import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/supabase_config.dart';
import '../../auth/presentation/auth_providers.dart';
import '../data/supabase_verification_repository.dart';
import '../domain/identity_verification.dart';
import '../domain/verification_repository.dart';

/// Provider for the VerificationRepository instance
final verificationRepositoryProvider = Provider<VerificationRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseVerificationRepository(supabase);
});

/// Streams the latest identity verification for the current authenticated user
final currentVerificationStreamProvider = StreamProvider<IdentityVerification?>((ref) {
  final user = ref.watch(currentAuthUserProvider);
  if (user == null) return Stream.value(null);

  final repository = ref.watch(verificationRepositoryProvider);
  return repository.watchLatestVerification(user.id);
});

/// Future provider fetching current verification record
final currentVerificationFutureProvider = FutureProvider<IdentityVerification?>((ref) async {
  final user = ref.watch(currentAuthUserProvider);
  if (user == null) return null;

  final repository = ref.watch(verificationRepositoryProvider);
  return repository.getLatestVerification(user.id);
});

/// Controller handling verification submission and image uploads
class VerificationController extends StateNotifier<AsyncValue<IdentityVerification?>> {
  final VerificationRepository _repository;
  final Ref _ref;

  VerificationController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<IdentityVerification?> submitVerification({
    required String documentType,
    required String documentNumber,
    required Uint8List frontBytes,
    Uint8List? backBytes,
    required Uint8List selfieBytes,
  }) async {
    final user = _ref.read(currentAuthUserProvider);
    if (user == null) {
      state = AsyncValue.error(
        StateError('User must be authenticated to submit verification'),
        StackTrace.current,
      );
      return null;
    }

    state = const AsyncValue.loading();
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      // 1. Upload Front Photo
      final frontPath = await _repository.uploadDocumentPhoto(
        userId: user.id,
        bytes: frontBytes,
        fileName: '${documentType}_front_$now.jpg',
      );

      // 2. Upload Back Photo (if provided / NID)
      String? backPath;
      if (backBytes != null) {
        backPath = await _repository.uploadDocumentPhoto(
          userId: user.id,
          bytes: backBytes,
          fileName: '${documentType}_back_$now.jpg',
        );
      }

      // 3. Upload Selfie
      final selfiePath = await _repository.uploadDocumentPhoto(
        userId: user.id,
        bytes: selfieBytes,
        fileName: 'selfie_$now.jpg',
      );

      // 4. Submit Verification Record
      final verification = await _repository.submitVerification(
        userId: user.id,
        documentType: documentType,
        documentNumber: documentNumber,
        frontPath: frontPath,
        backPath: backPath,
        selfiePath: selfiePath,
      );

      state = AsyncValue.data(verification);
      _ref.invalidate(currentVerificationFutureProvider);
      return verification;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final verificationControllerProvider =
    StateNotifierProvider<VerificationController, AsyncValue<IdentityVerification?>>((ref) {
  final repository = ref.watch(verificationRepositoryProvider);
  return VerificationController(repository, ref);
});
