import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/onboarding/onboarding_scaffold.dart';
import '../../widgets/onboarding/step_header.dart';
import '../../widgets/onboarding/glass_chip_selector.dart';
import '../../widgets/onboarding/glass_toggle_card.dart';
import '../../widgets/onboarding/glass_slider_field.dart';
import '../../widgets/onboarding/glass_text_field.dart';

class Step5PreferencesScreen extends ConsumerStatefulWidget {
  const Step5PreferencesScreen({super.key});

  @override
  ConsumerState<Step5PreferencesScreen> createState() => _Step5PreferencesScreenState();
}

class _Step5PreferencesScreenState extends ConsumerState<Step5PreferencesScreen> {
  int _studyHours = 3;
  List<String> _learningStyle = [];
  String? _resourceLanguage;
  bool _hasInternet = true;
  bool _canAffordPaid = false;
  final _concernCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = ref.read(onboardingProvider);
    _studyHours = s.studyHoursPerDay ?? 3;
    _learningStyle = List.from(s.learningStyle);
    _resourceLanguage = s.resourceLanguage ?? 'french';
    _hasInternet = s.hasInternet;
    _canAffordPaid = s.canAffordPaid;
    if (s.biggestConcern != null) _concernCtrl.text = s.biggestConcern!;
    if (s.extraNotes != null) _notesCtrl.text = s.extraNotes!;
  }

  @override
  void dispose() { _concernCtrl.dispose(); _notesCtrl.dispose(); super.dispose(); }

  bool get _canContinue => _studyHours >= 1 && _resourceLanguage != null;

  void _saveAndContinue(bool fromProfile) {
    ref.read(onboardingProvider.notifier).setStep5(
      studyHoursPerDay: _studyHours,
      learningStyle: _learningStyle,
      resourceLanguage: _resourceLanguage,
      hasInternet: _hasInternet,
      canAffordPaid: _canAffordPaid,
      biggestConcern: _concernCtrl.text.isEmpty ? null : _concernCtrl.text,
      extraNotes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
    );
    // In resume mode go back home; in first-run flow go to processing screen
    if (fromProfile) {
      context.go('/home');
    } else {
      context.go('/onboarding/processing');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fromProfile = (GoRouterState.of(context).extra as Map<Object?, Object?>?)?['fromProfile'] == true;

    return OnboardingScaffold(
      currentStep: 5,
      totalSteps: 5,
      onBack: () => fromProfile ? context.pop() : context.go('/onboarding/step4'),
      onSkip: () {
        ref.read(onboardingProvider.notifier).markStepSkipped(5);
        if (fromProfile) { context.go('/home'); } else { context.go('/onboarding/processing'); }
      },
      canContinue: _canContinue,
      onContinue: () => _saveAndContinue(fromProfile),
      isLastStep: true,
      continueLabel: l.commonBuildPlan,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(title: l.step5Title, microcopy: l.step5Microcopy),
          const SizedBox(height: 28),

          GlassSliderField(
            label: l.step5StudyHoursLabel,
            value: _studyHours.toDouble(),
            min: 1, max: 12, divisions: 11,
            valueLabel: (v) => '${v.round()} h/day',
            onChanged: (v) => setState(() => _studyHours = v.round()),
          ),
          const SizedBox(height: 20),

          GlassChipSelector(
            label: l.step5LearningStyleLabel,
            options: [
              ChipOption(id: 'visual',   label: '👁️ ${l.learningVisual}'),
              ChipOption(id: 'auditory', label: '👂 ${l.learningAuditory}'),
              ChipOption(id: 'reading',  label: '📖 ${l.learningReading}'),
              ChipOption(id: 'hands_on', label: '🛠️ ${l.learningHandsOn}'),
            ],
            selected: _learningStyle,
            onToggle: (id, sel) => setState(() {
              if (sel) { _learningStyle.add(id); } else { _learningStyle.remove(id); }
            }),
          ),
          const SizedBox(height: 20),

          _Label(l.step5ResourceLangLabel),
          const SizedBox(height: 10),
          Row(
            children: [
              _Pill(id: 'arabic',  label: '🇩🇿 ${l.resourceArabic}',  selected: _resourceLanguage, onSelect: (id) => setState(() => _resourceLanguage = id)),
              const SizedBox(width: 8),
              _Pill(id: 'french',  label: '🇫🇷 ${l.resourceFrench}',  selected: _resourceLanguage, onSelect: (id) => setState(() => _resourceLanguage = id)),
              const SizedBox(width: 8),
              _Pill(id: 'english', label: '🇬🇧 ${l.resourceEnglish}', selected: _resourceLanguage, onSelect: (id) => setState(() => _resourceLanguage = id)),
              const SizedBox(width: 8),
              _Pill(id: 'mixed',   label: '🌐 ${l.resourceMixed}',   selected: _resourceLanguage, onSelect: (id) => setState(() => _resourceLanguage = id)),
            ],
          ),
          const SizedBox(height: 20),

          GlassSwitchRow(
            label: l.step5Internet,
            value: _hasInternet,
            onChanged: (v) => setState(() => _hasInternet = v),
            microcopy: l.step5InternetMicro,
          ),
          const SizedBox(height: 16),

          GlassSwitchRow(
            label: l.step5Paid,
            value: _canAffordPaid,
            onChanged: (v) => setState(() => _canAffordPaid = v),
            microcopy: l.step5PaidMicro,
          ),
          const SizedBox(height: 20),

          GlassTextField(
            label: l.step5ConcernLabel,
            hint: l.step5ConcernHint,
            controller: _concernCtrl,
            maxLines: 3, maxLength: 300,
            optional: true,
          ),
          const SizedBox(height: 16),

          GlassTextField(
            label: l.step5NotesLabel,
            hint: l.step5NotesHint,
            controller: _notesCtrl,
            maxLines: 4, maxLength: 500,
            optional: true,
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

class _Pill extends StatelessWidget {
  final String id, label;
  final String? selected;
  final void Function(String) onSelect;
  const _Pill({required this.id, required this.label, required this.selected, required this.onSelect});

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
