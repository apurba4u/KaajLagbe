import 'dart:typed_data';
import 'identity_verification.dart';

/// Abstract repository managing identity document uploads and verification workflows
abstract class VerificationRepository {
  /// Fetches the latest verification record for [userId], or null if not yet submitted
  Future<IdentityVerification?> getLatestVerification(String userId);

  /// Streams the latest verification record for [userId]
  Stream<IdentityVerification?> watchLatestVerification(String userId);

  /// Uploads a document photo to the private 'identity-documents' bucket
  /// under `<userId>/<fileName>` and returns the storage path
  Future<String> uploadDocumentPhoto({
    required String userId,
    required Uint8List bytes,
    required String fileName,
    String contentType = 'image/jpeg',
  });

  /// Submits an identity verification record to public.identity_verifications
  Future<IdentityVerification> submitVerification({
    required String userId,
    required String documentType,
    required String documentNumber,
    required String frontPath,
    String? backPath,
    required String selfiePath,
  });
}
