/// Represents an identity verification submission record from public.identity_verifications
class IdentityVerification {
  final String id;
  final String userId;
  final String documentType; // 'nid' or 'passport'
  final String documentNumber;
  final String frontPath;
  final String? backPath;
  final String selfiePath;
  final String status; // 'pending', 'approved', 'rejected'
  final String? adminId;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  const IdentityVerification({
    required this.id,
    required this.userId,
    required this.documentType,
    required this.documentNumber,
    required this.frontPath,
    this.backPath,
    required this.selfiePath,
    required this.status,
    this.adminId,
    this.rejectionReason,
    required this.createdAt,
    this.reviewedAt,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  factory IdentityVerification.fromJson(Map<String, dynamic> json) {
    return IdentityVerification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      documentType: json['document_type'] as String? ?? 'nid',
      documentNumber: json['document_number'] as String? ?? '',
      frontPath: json['front_path'] as String? ?? '',
      backPath: json['back_path'] as String?,
      selfiePath: json['selfie_path'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      adminId: json['admin_id'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'document_type': documentType,
      'document_number': documentNumber,
      'front_path': frontPath,
      'back_path': backPath,
      'selfie_path': selfiePath,
      'status': status,
      'admin_id': adminId,
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
    };
  }

  IdentityVerification copyWith({
    String? id,
    String? userId,
    String? documentType,
    String? documentNumber,
    String? frontPath,
    String? backPath,
    String? selfiePath,
    String? status,
    String? adminId,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? reviewedAt,
  }) {
    return IdentityVerification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      frontPath: frontPath ?? this.frontPath,
      backPath: backPath ?? this.backPath,
      selfiePath: selfiePath ?? this.selfiePath,
      status: status ?? this.status,
      adminId: adminId ?? this.adminId,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }
}

