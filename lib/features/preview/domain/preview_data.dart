import '../../auth/domain/user_profile.dart';
import '../../../core/constants/app_constants.dart';
import '../../labour/domain/labour_profile.dart';
import '../../labour/domain/labour_skill.dart';
import '../../labour/domain/skill.dart';
import '../../verification/domain/identity_verification.dart';

/// Pre-populated in-memory test data for Design Preview Mode
/// Matching deterministic seed accounts from supabase/seed/demo_users.sql.
class PreviewData {
  PreviewData._();

  // Deterministic Demo IDs
  static const String customer1Id = '00000000-0000-0000-0000-000000000001';
  static const String customer2Id = '00000000-0000-0000-0000-000000000002';
  static const String labour1Id = '00000000-0000-0000-0000-000000000003';
  static const String labour2Id = '00000000-0000-0000-0000-000000000004';
  static const String labour3Id = '00000000-0000-0000-0000-000000000005';
  static const String adminId = '00000000-0000-0000-0000-000000000006';

  // 1. Demo Personas
  static final UserProfile rahimCustomer = UserProfile(
    id: customer1Id,
    role: UserRole.customer,
    accountStatus: AccountStatus.approved,
    fullName: 'Rahim Uddin',
    phone: '+8801700000001',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  static final UserProfile sadiaCustomer = UserProfile(
    id: customer2Id,
    role: UserRole.customer,
    accountStatus: AccountStatus.approved,
    fullName: 'Sadia Akter',
    phone: '+8801700000002',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  static final UserProfile karimLabour = UserProfile(
    id: labour1Id,
    role: UserRole.labour,
    accountStatus: AccountStatus.approved,
    fullName: 'Karim Mia',
    phone: '+8801800000001',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  static final UserProfile jamalLabour = UserProfile(
    id: labour2Id,
    role: UserRole.labour,
    accountStatus: AccountStatus.approved,
    fullName: 'Jamal Hossain',
    phone: '+8801800000002',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  static final UserProfile nasirLabour = UserProfile(
    id: labour3Id,
    role: UserRole.labour,
    accountStatus: AccountStatus.pendingVerification,
    fullName: 'Nasir Ali',
    phone: '+8801800000003',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  static final UserProfile superAdmin = UserProfile(
    id: adminId,
    role: UserRole.admin,
    accountStatus: AccountStatus.approved,
    fullName: 'Admin Controller',
    phone: '+8801900000001',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  static List<UserProfile> get allPersonas => [
        rahimCustomer,
        sadiaCustomer,
        karimLabour,
        jamalLabour,
        nasirLabour,
        superAdmin,
      ];

  // 2. Platform Skills
  static const List<Skill> platformSkills = [
    Skill(
      id: 'skill-elec',
      name: 'Electrician',
      nameBn: 'ইলেকট্রিশিয়ান',
      description: 'House wiring, circuit breakers, electrical appliances',
    ),
    Skill(
      id: 'skill-plumb',
      name: 'Plumber',
      nameBn: 'প্লাম্বার',
      description: 'Pipe installation, leak repair, sanitary fittings',
    ),
    Skill(
      id: 'skill-clean',
      name: 'Cleaner',
      nameBn: 'ক্লিনার',
      description: 'Deep home cleaning, office cleaning, post-renovation',
    ),
    Skill(
      id: 'skill-paint',
      name: 'Painter',
      nameBn: 'পেইন্টার',
      description: 'Wall painting, weather coat, damp proofing',
    ),
    Skill(
      id: 'skill-gard',
      name: 'Gardener',
      nameBn: 'মালী',
      description: 'Rooftop gardens, lawn maintenance, pruning',
    ),
    Skill(
      id: 'skill-carp',
      name: 'Carpenter',
      nameBn: 'ছুতার',
      description: 'Furniture repair, door fitting, wood polishing',
    ),
    Skill(
      id: 'skill-move',
      name: 'Moving Helper',
      nameBn: 'মুভিং হেল্পার',
      description: 'House shifting, furniture lifting, loading/unloading',
    ),
  ];

  // 3. Worker Profiles & Skills
  static final LabourProfile karimLabourProfile = LabourProfile(
    id: 'lp-karim',
    userId: labour1Id,
    experience: '8 years, residential wiring and repair',
    serviceArea: 'Mirpur, Dhaka',
    expectedWage: 600.0,
    availability: 'Sat-Thu 09:00-18:00',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  static final List<LabourSkill> karimSkills = [
    LabourSkill(
      id: 'ls-k-1',
      labourId: labour1Id,
      skillId: 'skill-elec',
      skillName: 'Electrician',
      skillNameBn: 'ইলেকট্রিশিয়ান',
      score: 245.5,
      badgeActive: true,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
    LabourSkill(
      id: 'ls-k-2',
      labourId: labour1Id,
      skillId: 'skill-plumb',
      skillName: 'Plumber',
      skillNameBn: 'প্লাম্বার',
      score: 212.0,
      badgeActive: true,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
    LabourSkill(
      id: 'ls-k-3',
      labourId: labour1Id,
      skillId: 'skill-paint',
      skillName: 'Painter',
      skillNameBn: 'পেইন্টার',
      score: 146.5,
      badgeActive: false,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
  ];

  static final LabourProfile jamalLabourProfile = LabourProfile(
    id: 'lp-jamal',
    userId: labour2Id,
    experience: '5 years, gardening and home cleaning',
    serviceArea: 'Gulshan, Banani, Baridhara',
    expectedWage: 450.0,
    availability: 'Sat-Wed 08:00-17:00',
    createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    updatedAt: DateTime.parse('2026-11-04T00:00:00Z'),
  );

  static final List<LabourSkill> jamalSkills = [
    LabourSkill(
      id: 'ls-j-1',
      labourId: labour2Id,
      skillId: 'skill-gard',
      skillName: 'Gardener',
      skillNameBn: 'মালী',
      score: 205.0,
      badgeActive: true,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
    LabourSkill(
      id: 'ls-j-2',
      labourId: labour2Id,
      skillId: 'skill-clean',
      skillName: 'Cleaner',
      skillNameBn: 'ক্লিনার',
      score: 120.0,
      badgeActive: false,
      createdAt: DateTime.parse('2026-11-04T00:00:00Z'),
    ),
  ];

  // 4. Identity Verifications in Different States
  static final IdentityVerification pendingVerification = IdentityVerification(
    id: 'iv-nasir',
    userId: labour3Id,
    documentType: 'nid',
    documentNumber: 'NID-19958291024',
    frontPath: 'preview/nid_nasir_front.jpg',
    backPath: 'preview/nid_nasir_back.jpg',
    selfiePath: 'preview/selfie_nasir.jpg',
    status: 'pending',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  );

  static final IdentityVerification approvedVerification = IdentityVerification(
    id: 'iv-karim',
    userId: labour1Id,
    documentType: 'nid',
    documentNumber: 'NID-19924820194',
    frontPath: 'preview/nid_karim_front.jpg',
    backPath: 'preview/nid_karim_back.jpg',
    selfiePath: 'preview/selfie_karim.jpg',
    status: 'approved',
    adminId: adminId,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    reviewedAt: DateTime.now().subtract(const Duration(days: 4)),
  );

  static final IdentityVerification rejectedVerification = IdentityVerification(
    id: 'iv-rejected-sample',
    userId: 'sample-user-rejected',
    documentType: 'nid',
    documentNumber: 'NID-19901122334',
    frontPath: 'preview/nid_bad_front.jpg',
    backPath: 'preview/nid_bad_back.jpg',
    selfiePath: 'preview/selfie_bad.jpg',
    status: 'rejected',
    rejectionReason: 'জাতীয় পরিচয়পত্রের সামনের পাতার ছবি ঝাপসা ও অস্পষ্ট। অনুগ্রহ করে আলোয় পরিষ্কার ছবি তুলুন। (National ID front photo is blurry. Please capture a clear image in good lighting.)',
    adminId: adminId,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    reviewedAt: DateTime.now().subtract(const Duration(days: 1)),
  );

  static List<IdentityVerification> get allVerifications => [
        pendingVerification,
        approvedVerification,
        rejectedVerification,
      ];
}

