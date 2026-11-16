import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../domain/labour_profile.dart';
import '../../domain/labour_skill.dart';
import '../../domain/skill.dart';
import '../labour_providers.dart';

/// Labour Profile Setup & Edit screen strictly implementing Stitch design 0deb1361a2a147a88f0a6fc0f9545fc3
/// with frozen Kinetic Trust tokens.
class LabourProfileSetupScreen extends ConsumerStatefulWidget {
  const LabourProfileSetupScreen({super.key});

  @override
  ConsumerState<LabourProfileSetupScreen> createState() =>
      _LabourProfileSetupScreenState();
}

class _LabourProfileSetupScreenState extends ConsumerState<LabourProfileSetupScreen> {
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _serviceAreaController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();

  final Set<String> _selectedSkillIds = {};
  final Set<String> _selectedDays = {'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'};

  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);

  bool _initialized = false;
  String? _errorMessage;

  @override
  void dispose() {
    _experienceController.dispose();
    _serviceAreaController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  void _populateInitialData(LabourProfile? profile, List<LabourSkill> existingSkills) {
    if (_initialized) return;
    _initialized = true;

    if (profile != null) {
      if (profile.experience != null) {
        _experienceController.text = profile.experience!;
      }
      if (profile.serviceArea != null) {
        _serviceAreaController.text = profile.serviceArea!;
      }
      if (profile.expectedWage != null) {
        _wageController.text = profile.expectedWage!.toStringAsFixed(0);
      }
      if (profile.availability != null && profile.availability!.isNotEmpty) {
        // e.g. "Sat,Sun,Mon,Tue,Wed,Thu | 09:00 - 18:00"
        final parts = profile.availability!.split('|');
        if (parts.isNotEmpty) {
          final days = parts[0].split(',').map((d) => d.trim()).where((d) => d.isNotEmpty);
          if (days.isNotEmpty) {
            _selectedDays.clear();
            _selectedDays.addAll(days);
          }
        }
      }
    }

    for (final s in existingSkills) {
      _selectedSkillIds.add(s.skillId);
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _saveProfile(AppLocalizations l10n) async {
    if (_selectedSkillIds.isEmpty) {
      setState(() {
        _errorMessage = l10n.selectAtLeastOneSkill;
      });
      return;
    }

    final serviceArea = _serviceAreaController.text.trim();
    if (serviceArea.isEmpty) {
      setState(() {
        _errorMessage = l10n.serviceAreaRequired;
      });
      return;
    }

    final wageText = _wageController.text.trim();
    final normalizedWage = NumberFormatter.toAsciiDigits(wageText);
    final wage = double.tryParse(normalizedWage);
    if (wage == null || wage <= 0) {
      setState(() {
        _errorMessage = l10n.wageRequired;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final formattedStart =
        '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final formattedEnd =
        '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';
    final availabilityString =
        '${_selectedDays.join(',')} | $formattedStart - $formattedEnd';

    final controller = ref.read(labourProfileControllerProvider.notifier);
    final success = await controller.saveProfile(
      experience: _experienceController.text.trim(),
      serviceArea: serviceArea,
      expectedWage: wage,
      availability: availabilityString,
      selectedSkillIds: _selectedSkillIds.toList(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileSavedSuccess),
          backgroundColor: AppColors.secondary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProfileProvider).valueOrNull;
    final skillsAsync = ref.watch(allSkillsProvider);

    final userId = user?.id ?? '';
    final profileAsync = ref.watch(labourProfileStreamProvider(userId));
    final labourSkillsAsync = ref.watch(labourSkillsStreamProvider(userId));
    final controllerState = ref.watch(labourProfileControllerProvider);
    final isSaving = controllerState.isLoading;

    final currentProfile = profileAsync.valueOrNull;
    final currentLabourSkills = labourSkillsAsync.valueOrNull ?? [];

    if (!_initialized && currentProfile != null || currentLabourSkills.isNotEmpty) {
      _populateInitialData(currentProfile, currentLabourSkills);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'K',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'KaajLagbe',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: const [
          Center(child: LanguageTogglePill()),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle
              Text(
                l10n.labourProfileSetupTitle,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.labourProfileSetupSubtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 20),

              // 1. Profile Photo Section
              _buildPhotoCard(user, l10n),

              const SizedBox(height: 20),

              // 2. Skills & Badges Multi-Select Section
              _buildSkillsSection(skillsAsync.valueOrNull ?? [], currentLabourSkills, l10n),

              const SizedBox(height: 20),

              // 3. Work Details & Rates Section
              _buildWorkDetailsSection(l10n),

              const SizedBox(height: 20),

              // 4. Weekly Availability Section
              _buildAvailabilitySection(l10n),

              if (_errorMessage != null) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 16, color: AppColors.error),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 28),

              // Sticky Save Profile CTA
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isSaving ? null : () => _saveProfile(l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.saveProfile,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoCard(dynamic user, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.background,
                backgroundImage: user?.avatarUrl != null
                    ? NetworkImage(user!.avatarUrl!)
                    : null,
                child: user?.avatarUrl == null
                    ? const Icon(Icons.person_rounded, size: 36, color: AppColors.textMuted)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profilePhotoSectionTitle,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.profilePhotoHelperText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(
    List<Skill> allSkills,
    List<LabourSkill> existingLabourSkills,
    AppLocalizations l10n,
  ) {
    // Map existing skills to easily check score and badgeActive
    final existingMap = {for (var s in existingLabourSkills) s.skillId: s};

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.skillsAndBadgesTitle,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_selectedSkillIds.length} Selected',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Legend Card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          l10n.claimedSkillLegend,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded, size: 14, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.verifiedSkillLegend,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Skill Selection Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allSkills.map((skill) {
              final isSelected = _selectedSkillIds.contains(skill.id);
              final existingSkill = existingMap[skill.id];
              final hasVerifiedBadge = existingSkill?.badgeActive ?? false;

              Color chipBg;
              Color chipBorder;
              Widget? statusTag;

              if (isSelected) {
                if (hasVerifiedBadge) {
                  chipBg = AppColors.secondary.withValues(alpha: 0.1);
                  chipBorder = AppColors.secondary;
                  statusTag = const Icon(Icons.verified_rounded,
                      size: 14, color: AppColors.secondary);
                } else {
                  chipBg = AppColors.tertiary.withValues(alpha: 0.1);
                  chipBorder = AppColors.tertiary;
                  statusTag = Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      l10n.claimedSkill,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              } else {
                chipBg = AppColors.background;
                chipBorder = AppColors.outline;
              }

              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSkillIds.remove(skill.id);
                    } else {
                      _selectedSkillIds.add(skill.id);
                    }
                    _errorMessage = null;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: chipBorder, width: isSelected ? 1.5 : 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                        size: 16,
                        color: isSelected
                            ? (hasVerifiedBadge ? AppColors.secondary : AppColors.tertiary)
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        skill.localizedName(Localizations.localeOf(context).languageCode),
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: AppColors.onSurface,
                        ),
                      ),
                      if (statusTag != null) ...[
                        const SizedBox(width: 6),
                        statusTag,
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkDetailsSection(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.workDetailsTitle,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          // Experience Textarea
          Text(
            l10n.experienceLabel,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.outline),
            ),
            child: TextField(
              key: const Key('experience_input'),
              controller: _experienceController,
              maxLines: 3,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: l10n.experiencePlaceholder,
                hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Service Area Input
          Text(
            '${l10n.serviceAreaLabel} *',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    key: const Key('service_area_input'),
                    controller: _serviceAreaController,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: l10n.serviceAreaPlaceholder,
                      hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Expected Wage per Hour Input
          Text(
            '${l10n.expectedWageLabel} *',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: [
                Text(
                  '৳',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    key: const Key('wage_input'),
                    controller: _wageController,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: l10n.expectedWagePlaceholder,
                      hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection(AppLocalizations l10n) {
    const dayKeys = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    final dayLabels = {
      'Sat': l10n.satDay,
      'Sun': l10n.sunDay,
      'Mon': l10n.monDay,
      'Tue': l10n.tueDay,
      'Wed': l10n.wedDay,
      'Thu': l10n.thuDay,
      'Fri': l10n.friDay,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.weeklyAvailabilityTitle,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.selectAvailableDays,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Day Chips Row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: dayKeys.map((day) {
              final isSelected = _selectedDays.contains(day);
              return ChoiceChip(
                label: Text(dayLabels[day] ?? day),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.background,
                labelStyle: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Start & End Time Pickers
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _pickTime(isStart: true),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.startTimeLabel,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              _startTime.format(context),
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => _pickTime(isStart: false),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.endTimeLabel,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time_filled_rounded,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              _endTime.format(context),
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
