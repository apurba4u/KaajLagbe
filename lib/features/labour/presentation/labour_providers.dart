import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/supabase_config.dart';
import '../../auth/presentation/auth_providers.dart';
import '../data/supabase_labour_repository.dart';
import '../domain/labour_profile.dart';
import '../domain/labour_repository.dart';
import '../domain/labour_skill.dart';
import '../domain/skill.dart';

/// Provider for LabourRepository
final labourRepositoryProvider = Provider<LabourRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseLabourRepository(supabase);
});

/// Fetches all available platform skills from the skills table
final allSkillsProvider = FutureProvider<List<Skill>>((ref) async {
  final repository = ref.watch(labourRepositoryProvider);
  return repository.getSkills();
});

/// Streams labour profile for a given [userId]
final labourProfileStreamProvider =
    StreamProvider.family<LabourProfile?, String>((ref, userId) {
  final repository = ref.watch(labourRepositoryProvider);
  return repository.watchLabourProfile(userId);
});

/// Fetches labour profile for a given [userId]
final labourProfileFutureProvider =
    FutureProvider.family<LabourProfile?, String>((ref, userId) async {
  final repository = ref.watch(labourRepositoryProvider);
  return repository.getLabourProfile(userId);
});

/// Streams associated skills for a given [userId]
final labourSkillsStreamProvider =
    StreamProvider.family<List<LabourSkill>, String>((ref, userId) {
  final repository = ref.watch(labourRepositoryProvider);
  return repository.watchLabourSkills(userId);
});

/// Fetches associated skills for a given [userId]
final labourSkillsFutureProvider =
    FutureProvider.family<List<LabourSkill>, String>((ref, userId) async {
  final repository = ref.watch(labourRepositoryProvider);
  return repository.getLabourSkills(userId);
});

/// Controller handling labour profile updates & skills sync
class LabourProfileController extends StateNotifier<AsyncValue<void>> {
  final LabourRepository _repository;
  final Ref _ref;

  LabourProfileController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> saveProfile({
    required String? experience,
    required String? serviceArea,
    required double? expectedWage,
    required String? availability,
    required List<String> selectedSkillIds,
  }) async {
    final profile = _ref.read(currentUserProfileProvider).valueOrNull;
    final userId = profile?.id ?? _ref.read(currentAuthUserProvider)?.id;
    if (userId == null) {
      state = AsyncValue.error(
        StateError('User must be authenticated'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncValue.loading();
    try {
      // 1. Update labour profile details
      await _repository.upsertLabourProfile(
        userId: userId,
        experience: experience,
        serviceArea: serviceArea,
        expectedWage: expectedWage,
        availability: availability,
      );

      // 2. Synchronize selected skills (server-side enforces score and badge integrity)
      await _repository.syncLabourSkills(
        userId: userId,
        selectedSkillIds: selectedSkillIds,
      );

      state = const AsyncValue.data(null);
      _ref.invalidate(labourProfileFutureProvider(userId));
      _ref.invalidate(labourSkillsFutureProvider(userId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final labourProfileControllerProvider =
    StateNotifierProvider<LabourProfileController, AsyncValue<void>>((ref) {
  final repository = ref.watch(labourRepositoryProvider);
  return LabourProfileController(repository, ref);
});
