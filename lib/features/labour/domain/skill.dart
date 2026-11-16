/// Represents a trade skill definition from public.skills
class Skill {
  final String id;
  final String name;
  final String nameBn;
  final String? description;
  final String? iconName;

  const Skill({
    required this.id,
    required this.name,
    required this.nameBn,
    this.description,
    this.iconName,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String,
      name: json['name'] as String,
      nameBn: json['name_bn'] as String? ?? json['name'] as String,
      description: json['description'] as String?,
      iconName: json['icon_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_bn': nameBn,
      'description': description,
      'icon_name': iconName,
    };
  }

  String localizedName(String languageCode) {
    return languageCode == 'bn' ? nameBn : name;
  }
}
