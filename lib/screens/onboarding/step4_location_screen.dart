import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../data/wilayas.dart';
import '../../theme/app_theme.dart';
import '../../widgets/onboarding/onboarding_scaffold.dart';
import '../../widgets/onboarding/step_header.dart';
import '../../widgets/onboarding/glass_dropdown.dart';
import '../../widgets/onboarding/glass_chip_selector.dart';
import '../../widgets/onboarding/glass_radio_cards.dart';
import '../../widgets/onboarding/glass_toggle_card.dart';
import '../../widgets/onboarding/glass_slider_field.dart';

class Step4LocationScreen extends ConsumerStatefulWidget {
  const Step4LocationScreen({super.key});

  @override
  ConsumerState<Step4LocationScreen> createState() => _Step4LocationScreenState();
}

class _Step4LocationScreenState extends ConsumerState<Step4LocationScreen> {
  int? _wilayaCode;
  String? _communeName;
  List<String> _transport = [];
  int _maxCommute = 45;
  bool _hasPersonalTransport = false;
  String? _relocate;
  bool _prefersHousing = false;
  String? _uniType;
  String? _studyLanguage;

  @override
  void initState() {
    super.initState();
    final s = ref.read(onboardingProvider);
    _wilayaCode = s.homeWilayaCode ?? s.wilayaCode;
    _communeName = s.homeCommuneName ?? (s.homeWilayaCode == null ? s.communeName : null);
    _transport = List.from(s.transportModes);
    _maxCommute = s.maxCommuteMin ?? 45;
    _hasPersonalTransport = s.hasPersonalTransport;
    _relocate = s.willingToRelocate;
    _prefersHousing = s.prefersHousing;
    _uniType = s.preferredUniType;
    _studyLanguage = s.preferredLanguageOfStudy;
  }

  bool get _canContinue =>
      _wilayaCode != null && _communeName != null &&
      _transport.isNotEmpty && _relocate != null && _studyLanguage != null;

  void _saveAndContinue(bool fromProfile) {
    ref.read(onboardingProvider.notifier).setStep4(
      homeWilayaCode: _wilayaCode, homeCommuneName: _communeName,
      transportModes: _transport, maxCommuteMin: _maxCommute,
      hasPersonalTransport: _hasPersonalTransport,
      willingToRelocate: _relocate, prefersHousing: _prefersHousing,
      preferredUniType: _uniType, preferredLanguageOfStudy: _studyLanguage,
    );
    if (fromProfile) {
      context.push('/onboarding/step5', extra: {'fromProfile': true});
    } else {
      context.go('/onboarding/step5');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final isAr = locale.languageCode == 'ar';
    final fromProfile = (GoRouterState.of(context).extra as Map<Object?, Object?>?)?['fromProfile'] == true;
    final selectedWilaya = _wilayaCode != null
        ? kWilayas.firstWhere((w) => w.code == _wilayaCode)
        : null;

    final transportOptions = [
      ChipOption(id: 'car',        label: '🚗 ${l.transportCar}'),
      ChipOption(id: 'bus',        label: '🚌 ${l.transportBus}'),
      ChipOption(id: 'train',      label: '🚆 ${l.transportTrain}'),
      ChipOption(id: 'taxi',       label: '🚕 ${l.transportTaxi}'),
      ChipOption(id: 'walk',       label: '🚶 ${l.transportWalk}'),
      ChipOption(id: 'motorcycle', label: '🏍️ ${l.transportMoto}'),
    ];

    return OnboardingScaffold(
      currentStep: 4,
      totalSteps: 5,
      onBack: () => fromProfile ? context.pop() : context.go('/onboarding/step3'),
      onSkip: () {
        ref.read(onboardingProvider.notifier).markStepSkipped(4);
        if (fromProfile) { context.pop(); } else { context.go('/onboarding/step5'); }
      },
      canContinue: _canContinue,
      onContinue: () => _saveAndContinue(fromProfile),
      continueLabel: l.commonContinue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(title: l.step4Title, microcopy: l.step4Microcopy),
          const SizedBox(height: 28),

          GlassDropdown<int>(
            label: l.step4HomeWilaya,
            placeholder: l.step1WilayaPlaceholder,
            searchable: true,
            items: kWilayas
                .map((w) => DropdownItem(
                      value: w.code,
                      label: '${w.code.toString().padLeft(2, '0')} — ${isAr ? w.nameAr : w.nameFr}',
                    ))
                .toList(),
            value: _wilayaCode,
            onChanged: (v) => setState(() { _wilayaCode = v; _communeName = null; }),
          ),
          const SizedBox(height: 16),

          GlassDropdown<String>(
            label: l.step4HomeCommune,
            placeholder: _wilayaCode == null ? l.step1CommuneSelectFirst : l.step1CommunePlaceholder,
            searchable: true,
            items: selectedWilaya?.communes.map((c) => DropdownItem(value: c, label: c)).toList() ?? [],
            value: _communeName,
            onChanged: (v) => setState(() => _communeName = v),
          ),
          const SizedBox(height: 20),

          GlassChipSelector(
            label: l.step4TransportLabel,
            options: transportOptions,
            selected: _transport,
            onToggle: (id, sel) => setState(() {
              if (sel) { _transport.add(id); } else { _transport.remove(id); }
            }),
          ),
          const SizedBox(height: 16),

          GlassSliderField(
            label: l.step4MaxCommute,
            value: _maxCommute.toDouble(),
            min: 10, max: 180, divisions: 34,
            valueLabel: (v) => '${v.round()} min',
            onChanged: (v) => setState(() => _maxCommute = (v / 5).round() * 5),
          ),
          const SizedBox(height: 16),

          GlassSwitchRow(
            label: l.step4PersonalTransport,
            value: _hasPersonalTransport,
            onChanged: (v) => setState(() => _hasPersonalTransport = v),
          ),
          const SizedBox(height: 20),

          GlassRadioCards(
            label: l.step4RelocateLabel,
            options: [
              RadioOption(id: 'no',            label: l.relocateNo,         icon: '🏠', description: l.relocateNoDesc),
              RadioOption(id: 'same_wilaya',   label: l.relocateSameWilaya, icon: '🗺️', description: l.relocateSameWilayaDesc),
              RadioOption(id: 'nearby_wilaya', label: l.relocateNearby,     icon: '🚌', description: l.relocateNearbyDesc),
              RadioOption(id: 'anywhere',      label: l.relocateAnywhere,   icon: '✈️', description: l.relocateAnywhereDesc),
            ],
            selected: _relocate,
            onSelect: (id) => setState(() => _relocate = id),
          ),
          const SizedBox(height: 16),

          GlassSwitchRow(
            label: l.step4Housing,
            value: _prefersHousing,
            onChanged: (v) => setState(() => _prefersHousing = v),
          ),
          const SizedBox(height: 20),

          _Label(l.step4UniTypeLabel),
          const SizedBox(height: 10),
          GlassChipSelector(
            options: [
              ChipOption(id: 'any',          label: l.uniTypeAny),
              ChipOption(id: 'university',   label: '🏛️ ${l.uniTypeUniversity}'),
              ChipOption(id: 'ecole',        label: '🏫 ${l.uniTypeEcole}'),
              ChipOption(id: 'institute',    label: '📐 ${l.uniTypeInstitute}'),
              ChipOption(id: 'grande_ecole', label: '⭐ ${l.uniTypeGrandeEcole}'),
            ],
            selected: _uniType != null ? [_uniType!] : [],
            maxSelections: 1,
            onToggle: (id, sel) => setState(() => _uniType = sel ? id : null),
          ),
          const SizedBox(height: 20),

          _Label(l.step4StudyLanguageLabel),
          const SizedBox(height: 10),
          Row(
            children: [
              _LangPill(id: 'arabic',    label: '🇩🇿 ${l.studyLangArabic}',   selected: _studyLanguage, onSelect: (id) => setState(() => _studyLanguage = id)),
              const SizedBox(width: 8),
              _LangPill(id: 'french',    label: '🇫🇷 ${l.studyLangFrench}',   selected: _studyLanguage, onSelect: (id) => setState(() => _studyLanguage = id)),
              const SizedBox(width: 8),
              _LangPill(id: 'english',   label: '🇬🇧 ${l.studyLangEnglish}',  selected: _studyLanguage, onSelect: (id) => setState(() => _studyLanguage = id)),
              const SizedBox(width: 8),
              _LangPill(id: 'bilingual', label: '🌐 ${l.studyLangBilingual}', selected: _studyLanguage, onSelect: (id) => setState(() => _studyLanguage = id)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
      );
}

class _LangPill extends StatelessWidget {
  final String id, label;
  final String? selected;
  final void Function(String) onSelect;
  const _LangPill({required this.id, required this.label, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(id),
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent.withAlpha(31) : AppColors.glassFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? AppColors.accent : AppColors.glassBorder, width: isSelected ? 1.5 : 1),
            boxShadow: isSelected ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 8)] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: isSelected ? AppColors.accent : AppColors.textSecondary, fontSize: 11, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
