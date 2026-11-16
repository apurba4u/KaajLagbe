/// Represents a worker profile record from public.labour_profiles
class LabourProfile {
  final String id;
  final String userId;
  final String? experience;
  final String? serviceArea;
  final double? expectedWage;
  final String? availability;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LabourProfile({
    required this.id,
    required this.userId,
    this.experience,
    this.serviceArea,
    this.expectedWage,
    this.availability,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LabourProfile.fromJson(Map<String, dynamic> json) {
    return LabourProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      experience: json['experience'] as String?,
      serviceArea: json['service_area'] as String?,
      expectedWage: json['expected_wage'] != null
          ? (json['expected_wage'] as num).toDouble()
          : null,
      availability: json['availability'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'experience': experience,
      'service_area': serviceArea,
      'expected_wage': expectedWage,
      'availability': availability,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  LabourProfile copyWith({
    String? id,
    String? userId,
    String? experience,
    String? serviceArea,
    double? expectedWage,
    String? availability,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LabourProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      experience: experience ?? this.experience,
      serviceArea: serviceArea ?? this.serviceArea,
      expectedWage: expectedWage ?? this.expectedWage,
      availability: availability ?? this.availability,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

