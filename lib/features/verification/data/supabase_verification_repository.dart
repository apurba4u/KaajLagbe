import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/identity_verification.dart';
import '../domain/verification_repository.dart';

/// Supabase implementation of [VerificationRepository]
class SupabaseVerificationRepository implements VerificationRepository {
  final SupabaseClient _supabase;

  SupabaseVerificationRepository(this._supabase);

  @override
  Future<IdentityVerification?> getLatestVerification(String userId) async {
    final response = await _supabase
        .from('identity_verifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1);

    if (response.isEmpty) return null;
    return IdentityVerification.fromJson(response.first);
  }

  @override
  Stream<IdentityVerification?> watchLatestVerification(String userId) {
    return _supabase
        .from('identity_verifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((records) {
          if (records.isEmpty) return null;
          // Sort descending by created_at in client stream
          records.sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
          return IdentityVerification.fromJson(records.first);
        });
  }

  @override
  Future<String> uploadDocumentPhoto({
    required String userId,
    required Uint8List bytes,
    required String fileName,
    String contentType = 'image/jpeg',
  }) async {
    final storagePath = '$userId/$fileName';
    await _supabase.storage.from('identity-documents').uploadBinary(
          storagePath,
          bytes,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: true,
          ),
        );
    return storagePath;
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
    final payload = <String, dynamic>{
      'user_id': userId,
      'document_type': documentType,
      'document_number': documentNumber,
      'front_path': frontPath,
      'back_path': backPath,
      'selfie_path': selfiePath,
      'status': 'pending',
    };

    final record = await _supabase
        .from('identity_verifications')
        .insert(payload)
        .select()
        .single();

    return IdentityVerification.fromJson(record);
  }
}

