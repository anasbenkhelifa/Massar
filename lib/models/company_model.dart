class Company {
  final String id;
  final String name;
  final String? nameAr;
  final String type;
  final List<String> domains;
  final List<String> relevantMajors;
  final int wilayaCode;
  final String? commune;
  final String? address;
  final double latitude;
  final double longitude;
  final String description;
  final String? employeeCountRange;
  final String? website;
  final String internshipLikelihood;
  final List<String> tags;
  final double distanceKm;
  final String source;

  Company({
    required this.id,
    required this.name,
    this.nameAr,
    required this.type,
    required this.domains,
    required this.relevantMajors,
    required this.wilayaCode,
    this.commune,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    this.employeeCountRange,
    this.website,
    required this.internshipLikelihood,
    required this.tags,
    required this.distanceKm,
    required this.source,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Company',
      nameAr: json['name_ar'] as String?,
      type: json['type'] as String? ?? '',
      domains: List<String>.from(json['domains'] ?? []),
      relevantMajors: List<String>.from(json['relevant_majors'] ?? []),
      wilayaCode: json['wilaya_code'] as int? ?? 16,
      commune: json['commune'] as String?,
      address: json['address'] as String?,
      latitude: (json['coordinates']?['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['coordinates']?['lng'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      employeeCountRange: json['employee_count_range'] as String?,
      website: json['website'] as String?,
      internshipLikelihood: json['internship_likelihood'] as String? ?? 'medium',
      tags: List<String>.from(json['tags'] ?? []),
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? 'static',
    );
  }
}
