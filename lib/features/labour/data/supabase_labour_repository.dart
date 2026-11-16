import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/labour_profile.dart';
import '../domain/labour_repository.dart';
import '../domain/labour_skill.dart';
import '../domain/skill.dart';

/// Supabase implementation of [LabourRepository]
class SupabaseLabourRepository implements LabourRepository {
  final SupabaseClient _supabase;

  SupabaseLabourRepository(this._supabase);

  @override
  Future<List<Skill>> getSkills() async {
    final response = await _supabase.from('skills').select().order('name');
    return (response as List).map((e) => Skill.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<LabourProfile?> getLabourProfile(String userId) async {
    final response = await _supabase
        .from('labour_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return LabourProfile.fromJson(response);
  }

  @override
  Stream<LabourProfile?> watchLabourProfile(String userId) {
    return _supabase
        .from('labour_profiles')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((list) => list.isNotEmpty ? LabourProfile.fromJson(list.first) : null);
  }

  @override
  Future<List<LabourSkill>> getLabourSkills(String userId) async {
    final response = await _supabase
        .from('labour_skills')
        .select('id, labour_id, skill_id, score, badge_active, created_at, skills(name, name_bn)')
        .eq('labour_id', userId);

    return (response as List)
        .map((e) => LabourSkill.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<LabourSkill>> watchLabourSkills(String userId) {
    return _supabase
        .from('labour_skills')
        .stream(primaryKey: ['id'])
        .eq('labour_id', userId)
        .asyncMap((_) => getLabourSkills(userId));
  }

  @override
  Future<void> upsertLabourProfile({
    required String userId,
    String? experience,
    String? serviceArea,
    double? expectedWage,
    String? availability,
  }) async {
    final data = <String, dynamic>{
      'user_id': userId,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
    if (experience != null) data['experience'] = experience;
    if (serviceArea != null) data['service_area'] = serviceArea;
    if (expectedWage != null) data['expected_wage'] = expectedWage;
    if (availability != null) data['availability'] = availability;

    await _supabase.from('labour_profiles').upsert(data, onConflict: 'user_id');
  }

  @override
  Future<void> syncLabourSkills({
    required String userId,
    required List<String> selectedSkillIds,
  }) async {
    // 1. Fetch currently claimed skills
    final currentRecords = await _supabase
        .from('labour_skills')
        .select('skill_id')
        .eq('labour_id', userId);

    final currentIds = (currentRecords as List)
        .map((e) => e['skill_id'] as String)
        .toSet();

    final toAdd = selectedSkillIds.where((id) => !currentIds.contains(id)).toList();
    final toRemove = currentIds.where((id) => !selectedSkillIds.contains(id)).toList();

    // 2. Remove deselected skills
    for (final skillId in toRemove) {
      await _supabase
          .from('labour_skills')
          .delete()
          .eq('labour_id', userId)
          .eq('skill_id', skillId);
    }

    // 3. Insert newly selected skills with default score 0 and badge_active false
    // Note: Never writes or alters score/badge_active for existing skills!
    if (toAdd.isNotEmpty) {
      final rows = toAdd.map((sId) => {
        'labour_id': userId,
        'skill_id': sId,
        'score': 0,
        'badge_active': false,
      }).toList();

      await _supabase.from('labour_skills').insert(rows);
    }
  }
}

