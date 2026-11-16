import 'labour_profile.dart';
import 'labour_skill.dart';
import 'skill.dart';

/// Repository managing skills directory, labour profile records and skills claims.
abstract class LabourRepository {
  /// Fetches all platform skills from public.skills
  Future<List<Skill>> getSkills();

  /// Fetches a worker's profile record from public.labour_profiles
  Future<LabourProfile?> getLabourProfile(String userId);

  /// Streams a worker's profile record from public.labour_profiles
  Stream<LabourProfile?> watchLabourProfile(String userId);

  /// Fetches associated skills with server-calculated scores & badges from public.labour_skills
  Future<List<LabourSkill>> getLabourSkills(String userId);

  /// Streams associated skills from public.labour_skills
  Stream<List<LabourSkill>> watchLabourSkills(String userId);

  /// Upserts profile details (experience, service area, expected wage, availability)
  Future<void> upsertLabourProfile({
    required String userId,
    String? experience,
    String? serviceArea,
    double? expectedWage,
    String? availability,
  });

  /// Synchronizes worker's selected skills.
  /// Strictly never writes or overrides [score] or [badge_active] from the client.
  Future<void> syncLabourSkills({
    required String userId,
    required List<String> selectedSkillIds,
  });
}
