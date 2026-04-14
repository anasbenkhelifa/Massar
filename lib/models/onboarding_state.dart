class OnboardingState {
  // Meta
  final String? language; // 'ar' | 'fr' | 'en'
  final Map<int, bool> skippedSteps;

  // Step 1 — Personal Info
  final String? fullName;
  final int? birthYear;
  final String? gender; // 'male' | 'female' | 'prefer_not_to_say'
  final int? wilayaCode;
  final String? communeName;
  final String? email;
  final String? phone;
  final String? password;

  // Step 2 — Academic Background
  final String? bacStream;
  final int? bacYear;
  final double? bacAverage;
  final List<String> strongSubjects;
  final List<String> weakSubjects;
  final bool currentlyEnrolled;
  final String? currentMajor;
  final String? currentYear; // 'L1'|'L2'|'L3'|'M1'|'M2'
  final List<String> extracurriculars;

  // Step 3 — Interests & Goals
  final List<String> interestDomains;
  final List<String> likedActivities;
  final List<String> workStyle;
  final String? environmentPref;
  final String? shortTermGoal;
  final String? sectorPreference; // 'public'|'private'|'both'|'ngo'
  final String? salaryPriority; // 'low'|'medium'|'high'
  final String? extraContext;

  // Step 4 — Location & Mobility
  final int? homeWilayaCode;
  final String? homeCommuneName;
  final List<String> transportModes;
  final int? maxCommuteMin;
  final bool hasPersonalTransport;
  final String? willingToRelocate; // 'no'|'same_wilaya'|'nearby_wilaya'|'anywhere'
  final bool prefersHousing;
  final String? preferredUniType;
  final String? preferredLanguageOfStudy;

  // Step 5 — Study Preferences
  final int? studyHoursPerDay;
  final List<String> learningStyle;
  final String? resourceLanguage;
  final bool hasInternet;
  final bool canAffordPaid;
  final String? biggestConcern;
  final String? extraNotes;

  const OnboardingState({
    this.language,
    this.skippedSteps = const {},
    // Step 1
    this.fullName,
    this.birthYear,
    this.gender,
    this.wilayaCode,
    this.communeName,
    this.email,
    this.phone,
    this.password,
    // Step 2
    this.bacStream,
    this.bacYear,
    this.bacAverage,
    this.strongSubjects = const [],
    this.weakSubjects = const [],
    this.currentlyEnrolled = false,
    this.currentMajor,
    this.currentYear,
    this.extracurriculars = const [],
    // Step 3
    this.interestDomains = const [],
    this.likedActivities = const [],
    this.workStyle = const [],
    this.environmentPref,
    this.shortTermGoal,
    this.sectorPreference,
    this.salaryPriority,
    this.extraContext,
    // Step 4
    this.homeWilayaCode,
    this.homeCommuneName,
    this.transportModes = const [],
    this.maxCommuteMin,
    this.hasPersonalTransport = false,
    this.willingToRelocate,
    this.prefersHousing = false,
    this.preferredUniType,
    this.preferredLanguageOfStudy,
    // Step 5
    this.studyHoursPerDay,
    this.learningStyle = const [],
    this.resourceLanguage,
    this.hasInternet = true,
    this.canAffordPaid = false,
    this.biggestConcern,
    this.extraNotes,
  });

  OnboardingState copyWith({
    String? language,
    Map<int, bool>? skippedSteps,
    String? fullName,
    int? birthYear,
    String? gender,
    int? wilayaCode,
    String? communeName,
    String? email,
    String? phone,
    String? password,
    String? bacStream,
    int? bacYear,
    double? bacAverage,
    List<String>? strongSubjects,
    List<String>? weakSubjects,
    bool? currentlyEnrolled,
    String? currentMajor,
    String? currentYear,
    List<String>? extracurriculars,
    List<String>? interestDomains,
    List<String>? likedActivities,
    List<String>? workStyle,
    String? environmentPref,
    String? shortTermGoal,
    String? sectorPreference,
    String? salaryPriority,
    String? extraContext,
    int? homeWilayaCode,
    String? homeCommuneName,
    List<String>? transportModes,
    int? maxCommuteMin,
    bool? hasPersonalTransport,
    String? willingToRelocate,
    bool? prefersHousing,
    String? preferredUniType,
    String? preferredLanguageOfStudy,
    int? studyHoursPerDay,
    List<String>? learningStyle,
    String? resourceLanguage,
    bool? hasInternet,
    bool? canAffordPaid,
    String? biggestConcern,
    String? extraNotes,
  }) {
    return OnboardingState(
      language: language ?? this.language,
      skippedSteps: skippedSteps ?? this.skippedSteps,
      fullName: fullName ?? this.fullName,
      birthYear: birthYear ?? this.birthYear,
      gender: gender ?? this.gender,
      wilayaCode: wilayaCode ?? this.wilayaCode,
      communeName: communeName ?? this.communeName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      bacStream: bacStream ?? this.bacStream,
      bacYear: bacYear ?? this.bacYear,
      bacAverage: bacAverage ?? this.bacAverage,
      strongSubjects: strongSubjects ?? this.strongSubjects,
      weakSubjects: weakSubjects ?? this.weakSubjects,
      currentlyEnrolled: currentlyEnrolled ?? this.currentlyEnrolled,
      currentMajor: currentMajor ?? this.currentMajor,
      currentYear: currentYear ?? this.currentYear,
      extracurriculars: extracurriculars ?? this.extracurriculars,
      interestDomains: interestDomains ?? this.interestDomains,
      likedActivities: likedActivities ?? this.likedActivities,
      workStyle: workStyle ?? this.workStyle,
      environmentPref: environmentPref ?? this.environmentPref,
      shortTermGoal: shortTermGoal ?? this.shortTermGoal,
      sectorPreference: sectorPreference ?? this.sectorPreference,
      salaryPriority: salaryPriority ?? this.salaryPriority,
      extraContext: extraContext ?? this.extraContext,
      homeWilayaCode: homeWilayaCode ?? this.homeWilayaCode,
      homeCommuneName: homeCommuneName ?? this.homeCommuneName,
      transportModes: transportModes ?? this.transportModes,
      maxCommuteMin: maxCommuteMin ?? this.maxCommuteMin,
      hasPersonalTransport: hasPersonalTransport ?? this.hasPersonalTransport,
      willingToRelocate: willingToRelocate ?? this.willingToRelocate,
      prefersHousing: prefersHousing ?? this.prefersHousing,
      preferredUniType: preferredUniType ?? this.preferredUniType,
      preferredLanguageOfStudy: preferredLanguageOfStudy ?? this.preferredLanguageOfStudy,
      studyHoursPerDay: studyHoursPerDay ?? this.studyHoursPerDay,
      learningStyle: learningStyle ?? this.learningStyle,
      resourceLanguage: resourceLanguage ?? this.resourceLanguage,
      hasInternet: hasInternet ?? this.hasInternet,
      canAffordPaid: canAffordPaid ?? this.canAffordPaid,
      biggestConcern: biggestConcern ?? this.biggestConcern,
      extraNotes: extraNotes ?? this.extraNotes,
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language,
    'fullName': fullName,
    'birthYear': birthYear,
    'gender': gender,
    'wilayaCode': wilayaCode,
    'communeName': communeName,
    'email': email,
    'phone': phone,
    'bacStream': bacStream,
    'bacYear': bacYear,
    'bacAverage': bacAverage,
    'strongSubjects': strongSubjects,
    'weakSubjects': weakSubjects,
    'currentlyEnrolled': currentlyEnrolled,
    'currentMajor': currentMajor,
    'currentYear': currentYear,
    'extracurriculars': extracurriculars,
    'interestDomains': interestDomains,
    'likedActivities': likedActivities,
    'workStyle': workStyle,
    'environmentPref': environmentPref,
    'shortTermGoal': shortTermGoal,
    'sectorPreference': sectorPreference,
    'salaryPriority': salaryPriority,
    'extraContext': extraContext,
    'homeWilayaCode': homeWilayaCode,
    'homeCommuneName': homeCommuneName,
    'transportModes': transportModes,
    'maxCommuteMin': maxCommuteMin,
    'hasPersonalTransport': hasPersonalTransport,
    'willingToRelocate': willingToRelocate,
    'prefersHousing': prefersHousing,
    'preferredUniType': preferredUniType,
    'preferredLanguageOfStudy': preferredLanguageOfStudy,
    'studyHoursPerDay': studyHoursPerDay,
    'learningStyle': learningStyle,
    'resourceLanguage': resourceLanguage,
    'hasInternet': hasInternet,
    'canAffordPaid': canAffordPaid,
    'biggestConcern': biggestConcern,
    'extraNotes': extraNotes,
  };
}
