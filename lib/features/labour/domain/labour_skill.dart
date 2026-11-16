/// Represents an associated skill record from public.labour_skills.
/// NOTE: [score] and [badgeActive] are strictly calculated and assigned server-side.
class LabourSkill {
  final String id;
  final String labourId;
  final String skillId;
  final String? skillName;
  final String? skillNameBn;
  final double score;
  final bool badgeActive;
  final DateTime createdAt;

  const LabourSkill({
    required this.id,
    required this.labourId,
    required this.skillId,
    this.skillName,
    this.skillNameBn,
    this.score = 0.0,
    this.badgeActive = false,
    required this.createdAt,
  });

  /// A skill claim is "Claimed, not verified" if badgeActive is false
  bool get isClaimed => !badgeActive;

  factory LabourSkill.fromJson(Map<String, dynamic> json) {
    // If joined with public.skills
    final skillJoin = json['skills'] as Map<String, dynamic>?;

    return LabourSkill(
      id: json['id'] as String,
      labourId: json['labour_id'] as String,
      skillId: json['skill_id'] as String,
      skillName: skillJoin != null
          ? skillJoin['name'] as String?
          : json['skill_name'] as String?,
      skillNameBn: skillJoin != null
          ? skillJoin['name_bn'] as String?
          : json['skill_name_bn'] as String?,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      badgeActive: json['badge_active'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'labour_id': labourId,
      'skill_id': skillId,
      'score': score,
      'badge_active': badgeActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String localizedSkillName(String languageCode) {
    if (languageCode == 'bn' && skillNameBn != null && skillNameBn!.isNotEmpty) {
      return skillNameBn!;
    }
    return skillName ?? '';
  }
}
