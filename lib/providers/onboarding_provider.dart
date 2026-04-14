import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/onboarding_state.dart';

const _kOnboardingKey = 'massar_onboarding_state';
const _kOnboardingCompleteKey = 'massar_onboarding_complete';
const _kCurrentStepKey = 'massar_onboarding_step';

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  // ── Persistence ────────────────────────────────────────────────

  Future<void> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_kOnboardingKey);
    if (json == null) return;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      state = _fromJson(map);
    } catch (_) {
      // Corrupt data — start fresh
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kOnboardingKey, jsonEncode(state.toJson()));
  }

  Future<int> getSavedStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kCurrentStepKey) ?? 0;
  }

  Future<void> saveCurrentStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kCurrentStepKey, step);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOnboardingCompleteKey) ?? false;
  }

  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingCompleteKey, true);
  }

  Future<void> clearSavedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kOnboardingKey);
    await prefs.remove(_kCurrentStepKey);
    await prefs.remove(_kOnboardingCompleteKey);
    state = const OnboardingState();
  }

  // ── Field Updaters ──────────────────────────────────────────────

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
    _persist();
  }

  /// Generic patch — apply any copyWith transform to the current state.
  void update(OnboardingState Function(OnboardingState) updater) {
    state = updater(state);
    _persist();
  }

  void setStep1({
    String? fullName,
    int? birthYear,
    String? gender,
    int? wilayaCode,
    String? communeName,
    String? email,
    String? phone,
    String? password,
  }) {
    state = state.copyWith(
      fullName: fullName,
      birthYear: birthYear,
      gender: gender,
      wilayaCode: wilayaCode,
      communeName: communeName,
      email: email,
      phone: phone,
      password: password,
    );
    _persist();
  }

  void setStep2({
    String? bacStream,
    int? bacYear,
    double? bacAverage,
    List<String>? strongSubjects,
    List<String>? weakSubjects,
    bool? currentlyEnrolled,
    String? currentMajor,
    String? currentYear,
    List<String>? extracurriculars,
  }) {
    state = state.copyWith(
      bacStream: bacStream,
      bacYear: bacYear,
      bacAverage: bacAverage,
      strongSubjects: strongSubjects,
      weakSubjects: weakSubjects,
      currentlyEnrolled: currentlyEnrolled,
      currentMajor: currentMajor,
      currentYear: currentYear,
      extracurriculars: extracurriculars,
    );
    _persist();
  }

  void setStep3({
    List<String>? interestDomains,
    List<String>? likedActivities,
    List<String>? workStyle,
    String? environmentPref,
    String? shortTermGoal,
    String? sectorPreference,
    String? salaryPriority,
    String? extraContext,
  }) {
    state = state.copyWith(
      interestDomains: interestDomains,
      likedActivities: likedActivities,
      workStyle: workStyle,
      environmentPref: environmentPref,
      shortTermGoal: shortTermGoal,
      sectorPreference: sectorPreference,
      salaryPriority: salaryPriority,
      extraContext: extraContext,
    );
    _persist();
  }

  void setStep4({
    int? homeWilayaCode,
    String? homeCommuneName,
    List<String>? transportModes,
    int? maxCommuteMin,
    bool? hasPersonalTransport,
    String? willingToRelocate,
    bool? prefersHousing,
    String? preferredUniType,
    String? preferredLanguageOfStudy,
  }) {
    state = state.copyWith(
      homeWilayaCode: homeWilayaCode,
      homeCommuneName: homeCommuneName,
      transportModes: transportModes,
      maxCommuteMin: maxCommuteMin,
      hasPersonalTransport: hasPersonalTransport,
      willingToRelocate: willingToRelocate,
      prefersHousing: prefersHousing,
      preferredUniType: preferredUniType,
      preferredLanguageOfStudy: preferredLanguageOfStudy,
    );
    _persist();
  }

  void setStep5({
    int? studyHoursPerDay,
    List<String>? learningStyle,
    String? resourceLanguage,
    bool? hasInternet,
    bool? canAffordPaid,
    String? biggestConcern,
    String? extraNotes,
  }) {
    state = state.copyWith(
      studyHoursPerDay: studyHoursPerDay,
      learningStyle: learningStyle,
      resourceLanguage: resourceLanguage,
      hasInternet: hasInternet,
      canAffordPaid: canAffordPaid,
      biggestConcern: biggestConcern,
      extraNotes: extraNotes,
    );
    _persist();
  }

  void markStepSkipped(int step) {
    final updated = Map<int, bool>.from(state.skippedSteps)
      ..[step] = true;
    state = state.copyWith(skippedSteps: updated);
    _persist();
  }

  // ── Validation ──────────────────────────────────────────────────

  bool canSkipStep(int step) {
    // All steps are skippable except step 0 (language)
    return step != 0;
  }

  bool isStepComplete(int step) {
    switch (step) {
      case 0:
        return state.language != null;
      case 1:
        return state.fullName != null &&
            state.fullName!.isNotEmpty &&
            state.birthYear != null &&
            state.gender != null &&
            state.wilayaCode != null &&
            state.communeName != null &&
            state.email != null &&
            _isValidEmail(state.email!) &&
            state.password != null &&
            state.password!.length >= 8;
      case 2:
        return state.bacStream != null &&
            state.bacYear != null &&
            state.bacAverage != null &&
            state.bacAverage! >= 10;
      case 3:
        return state.interestDomains.isNotEmpty &&
            state.workStyle.isNotEmpty &&
            state.environmentPref != null &&
            state.shortTermGoal != null &&
            state.sectorPreference != null &&
            state.salaryPriority != null;
      case 4:
        return state.homeWilayaCode != null &&
            state.homeCommuneName != null &&
            state.transportModes.isNotEmpty &&
            state.maxCommuteMin != null &&
            state.willingToRelocate != null &&
            state.preferredLanguageOfStudy != null;
      case 5:
        return state.studyHoursPerDay != null &&
            state.studyHoursPerDay! >= 1 &&
            state.resourceLanguage != null;
      default:
        return false;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // ── Deserialize ─────────────────────────────────────────────────

  OnboardingState _fromJson(Map<String, dynamic> m) {
    return OnboardingState(
      language: m['language'] as String?,
      fullName: m['fullName'] as String?,
      birthYear: m['birthYear'] as int?,
      gender: m['gender'] as String?,
      wilayaCode: m['wilayaCode'] as int?,
      communeName: m['communeName'] as String?,
      email: m['email'] as String?,
      phone: m['phone'] as String?,
      password: m['password'] as String?,
      bacStream: m['bacStream'] as String?,
      bacYear: m['bacYear'] as int?,
      bacAverage: (m['bacAverage'] as num?)?.toDouble(),
      strongSubjects: List<String>.from(m['strongSubjects'] ?? []),
      weakSubjects: List<String>.from(m['weakSubjects'] ?? []),
      currentlyEnrolled: m['currentlyEnrolled'] as bool? ?? false,
      currentMajor: m['currentMajor'] as String?,
      currentYear: m['currentYear'] as String?,
      extracurriculars: List<String>.from(m['extracurriculars'] ?? []),
      interestDomains: List<String>.from(m['interestDomains'] ?? []),
      likedActivities: List<String>.from(m['likedActivities'] ?? []),
      workStyle: List<String>.from(m['workStyle'] ?? []),
      environmentPref: m['environmentPref'] as String?,
      shortTermGoal: m['shortTermGoal'] as String?,
      sectorPreference: m['sectorPreference'] as String?,
      salaryPriority: m['salaryPriority'] as String?,
      extraContext: m['extraContext'] as String?,
      homeWilayaCode: m['homeWilayaCode'] as int?,
      homeCommuneName: m['homeCommuneName'] as String?,
      transportModes: List<String>.from(m['transportModes'] ?? []),
      maxCommuteMin: m['maxCommuteMin'] as int?,
      hasPersonalTransport: m['hasPersonalTransport'] as bool? ?? false,
      willingToRelocate: m['willingToRelocate'] as String?,
      prefersHousing: m['prefersHousing'] as bool? ?? false,
      preferredUniType: m['preferredUniType'] as String?,
      preferredLanguageOfStudy: m['preferredLanguageOfStudy'] as String?,
      studyHoursPerDay: m['studyHoursPerDay'] as int?,
      learningStyle: List<String>.from(m['learningStyle'] ?? []),
      resourceLanguage: m['resourceLanguage'] as String?,
      hasInternet: m['hasInternet'] as bool? ?? true,
      canAffordPaid: m['canAffordPaid'] as bool? ?? false,
      biggestConcern: m['biggestConcern'] as String?,
      extraNotes: m['extraNotes'] as String?,
    );
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);
