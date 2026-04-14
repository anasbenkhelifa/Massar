import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../data/subjects.dart';
import '../../theme/app_theme.dart';
import '../../widgets/onboarding/onboarding_scaffold.dart';
import '../../widgets/onboarding/step_header.dart';
import '../../widgets/onboarding/glass_text_field.dart';
import '../../widgets/onboarding/glass_chip_selector.dart';
import '../../widgets/onboarding/glass_toggle_card.dart';

class Step2AcademicScreen extends ConsumerStatefulWidget {
  const Step2AcademicScreen({super.key});

  @override
  ConsumerState<Step2AcademicScreen> createState() => _Step2AcademicScreenState();
}

class _Step2AcademicScreenState extends ConsumerState<Step2AcademicScreen> {
  String? _bacStream;
  int _bacYear = 2022;
  double _bacAverage = 0;
  bool _bacAvgOutOfRange = false;
  List<String> _strong = [];
  List<String> _weak = [];
  bool _enrolled = false;
  String? _currentYear;
  List<String> _extracurriculars = [];
  final _majorCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();
  final _bacAvgCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = ref.read(onboardingProvider);
    _bacStream = s.bacStream;
    _bacYear = s.bacYear ?? 2022;
    _bacAverage = s.bacAverage ?? 0;
    if (_bacAverage > 0) _bacAvgCtrl.text = _bacAverage.toStringAsFixed(2);
    _strong = List.from(s.strongSubjects);
    _weak = List.from(s.weakSubjects);
    _enrolled = s.currentlyEnrolled;
    _currentYear = s.currentYear;
    _extracurriculars = List.from(s.extracurriculars);
    if (s.currentMajor != null) _majorCtrl.text = s.currentMajor!;
  }

  @override
  void dispose() {
    _majorCtrl.dispose();
    _tagCtrl.dispose();
    _bacAvgCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _bacStream != null && _bacAverage >= 10;

  void _onAvgInput(String text) {
    final raw = text.replaceAll(',', '.');
    final v = double.tryParse(raw);
    setState(() {
      if (raw.isEmpty) {
        _bacAverage = 0;
        _bacAvgOutOfRange = false;
      } else if (v == null || v < 0 || v > 20) {
        _bacAverage = 0;
        _bacAvgOutOfRange = true;
      } else {
        _bacAverage = v;
        _bacAvgOutOfRange = false;
      }
    });
  }

  void _saveAndContinue(bool fromProfile) {
    ref.read(onboardingProvider.notifier).setStep2(
      bacStream: _bacStream,
      bacYear: _bacYear,
      bacAverage: _bacAverage > 0 ? _bacAverage : null,
      strongSubjects: _strong,
      weakSubjects: _weak,
      currentlyEnrolled: _enrolled,
      currentMajor: _majorCtrl.text.isEmpty ? null : _majorCtrl.text,
      currentYear: _currentYear,
      extracurriculars: _extracurriculars,
    );
    if (fromProfile) {
      context.push('/onboarding/step3', extra: {'fromProfile': true});
    } else {
      context.go('/onboarding/step3');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fromProfile = (GoRouterState.of(context).extra as Map<Object?, Object?>?)?['fromProfile'] == true;

    return OnboardingScaffold(
      currentStep: 2,
      totalSteps: 5,
      onBack: () => fromProfile ? context.pop() : context.go('/onboarding/step1'),
      onSkip: () {
        ref.read(onboardingProvider.notifier).markStepSkipped(2);
        if (fromProfile) { context.pop(); } else { context.go('/onboarding/step3'); }
      },
      canContinue: _canContinue,
      onContinue: () => _saveAndContinue(fromProfile),
      continueLabel: l.commonContinue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(title: l.step2Title, microcopy: l.step2Microcopy),
          const SizedBox(height: 28),

          // ── Bac stream ─────────────────────────────────
          _Label(l.step2BacStream),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: kBacStreams.map((stream) {
                final isSelected = _bacStream == stream;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _BacStreamCard(
                    icon: kBacStreamIcons[stream]!,
                    label: _bacStreamLabel(l, stream),
                    isSelected: isSelected,
                    onTap: () => setState(() => _bacStream = stream),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // ── Bac year ─────────────────────────────── Fix 5: wheel picker
          _BacYearPicker(
            label: l.step2BacYear,
            value: _bacYear,
            onChanged: (y) => setState(() => _bacYear = y),
          ),
          const SizedBox(height: 20),

          // ── Bac average ──────────────────────────── Fix 6: plain text field
          _Label(l.step2BacAverage),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _bacAvgOutOfRange
                    ? AppColors.error
                    : (_bacAverage >= 10 ? AppColors.accent : AppColors.glassBorder),
                width: _bacAverage >= 10 ? 1.5 : 1,
              ),
            ),
            child: TextField(
              controller: _bacAvgCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
              onChanged: _onAvgInput,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'ex: 14.50',
                hintStyle: TextStyle(color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          if (_bacAvgOutOfRange) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(l.step2BacAverageInvalid,
                  style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ),
          ],
          if (_bacAverage >= 10) ...[
            const SizedBox(height: 12),
            Center(
              child: AnimatedSwitcher(
                duration: 200.ms,
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Container(
                  key: ValueKey(_mentionLabel(l, _bacAverage)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _mentionColor(_bacAverage).withAlpha(31),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _mentionColor(_bacAverage).withAlpha(100)),
                  ),
                  child: Text(
                    '🏅 ${_mentionLabel(l, _bacAverage)}',
                    style: TextStyle(
                      color: _mentionColor(_bacAverage),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),

          // ── Strong subjects ────────────────────────────
          GlassChipSelector(
            label: l.step2StrongSubjects,
            options: kSubjects.map((s) => ChipOption(id: s.id, label: _subjectLabel(l, s.id))).toList(),
            selected: _strong,
            maxSelections: 3,
            disabledIds: _weak,
            onToggle: (id, sel) => setState(() {
              if (sel) { _strong.add(id); } else { _strong.remove(id); }
            }),
          ),
          const SizedBox(height: 16),

          // ── Weak subjects ──────────────────────────────
          GlassChipSelector(
            label: l.step2WeakSubjects,
            options: kSubjects.map((s) => ChipOption(id: s.id, label: _subjectLabel(l, s.id))).toList(),
            selected: _weak,
            disabledIds: _strong,
            onToggle: (id, sel) => setState(() {
              if (sel) { _weak.add(id); } else { _weak.remove(id); }
            }),
          ),
          const SizedBox(height: 20),

          // ── Currently enrolled toggle ──────────────────
          GlassToggleCard(
            label: l.step2EnrolledToggle,
            value: _enrolled,
            onChanged: (v) => setState(() => _enrolled = v),
            leading: const Text('🎓', style: TextStyle(fontSize: 22)),
          ),

          // ── Reveal: major + year ───────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            child: _enrolled
                ? Column(
                    children: [
                      const SizedBox(height: 14),
                      GlassTextField(
                        label: l.step2CurrentMajor,
                        hint: l.step2CurrentMajorHint,
                        controller: _majorCtrl,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),

                      // Fix 7: LMD + GE groups
                      _UniversityYearGroups(
                        l: l,
                        selected: _currentYear,
                        onSelect: (y) => setState(() => _currentYear = y),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.04, end: 0)
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),

          // ── Extracurriculars ───────────────────────────
          _TagInput(
            label: l.step2Extracurriculars,
            hint: l.step2ExtracurricularsHint,
            tags: _extracurriculars,
            controller: _tagCtrl,
            onAdd: (tag) {
              if (_extracurriculars.length < 5) setState(() => _extracurriculars.add(tag));
            },
            onRemove: (tag) => setState(() => _extracurriculars.remove(tag)),
          ),
        ],
      ),
    );
  }

  String _bacStreamLabel(AppLocalizations l, String stream) {
    switch (stream) {
      case 'math':       return l.bacStreamMath;
      case 'sciences':   return l.bacStreamSciences;
      case 'tech_math':  return l.bacStreamTechMath;
      case 'literature': return l.bacStreamLiterature;
      case 'languages':  return l.bacStreamLanguages;
      case 'management': return l.bacStreamManagement;
      case 'islamic':    return l.bacStreamIslamic;
      default:           return stream;
    }
  }

  String _subjectLabel(AppLocalizations l, String id) {
    switch (id) {
      case 'maths':           return l.subjectMaths;
      case 'physics':         return l.subjectPhysics;
      case 'arabic':          return l.subjectArabic;
      case 'french':          return l.subjectFrench;
      case 'english':         return l.subjectEnglish;
      case 'history':         return l.subjectHistory;
      case 'biology':         return l.subjectBiology;
      case 'chemistry':       return l.subjectChemistry;
      case 'philosophy':      return l.subjectPhilosophy;
      case 'economics':       return l.subjectEconomics;
      case 'computer_science':return l.subjectComputerScience;
      default:                return id;
    }
  }

  String _mentionLabel(AppLocalizations l, double avg) {
    if (avg < 10)  return l.mentionInvalid;
    if (avg < 12)  return l.mentionPassable;
    if (avg < 14)  return l.mentionAssezBien;
    if (avg < 16)  return l.mentionBien;
    if (avg < 18)  return l.mentionTresBien;
    return l.mentionFelicitations;
  }

  Color _mentionColor(double avg) {
    if (avg < 10)  return AppColors.error;
    if (avg < 12)  return AppColors.warning;
    if (avg < 14)  return const Color(0xFF4FC3F7);
    if (avg < 16)  return AppColors.accent;
    if (avg < 18)  return AppColors.secondary;
    return const Color(0xFFFFD700);
  }
}

// ── Fix 5: Bac year wheel picker ──────────────────────────────────────────────

class _BacYearPicker extends StatefulWidget {
  final String label;
  final int value;
  final void Function(int) onChanged;
  const _BacYearPicker({required this.label, required this.value, required this.onChanged});

  @override
  State<_BacYearPicker> createState() => _BacYearPickerState();
}

class _BacYearPickerState extends State<_BacYearPicker> {
  static const _years = [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027];
  late FixedExtentScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    final idx = (_years.indexOf(widget.value)).clamp(0, _years.length - 1);
    _ctrl = FixedExtentScrollController(initialItem: idx < 0 ? 7 : idx);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: AppColors.accent.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent.withAlpha(77)),
                ),
              ),
              ListWheelScrollView.useDelegate(
                controller: _ctrl,
                itemExtent: 48,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (i) {
                  HapticFeedback.selectionClick();
                  widget.onChanged(_years[i]);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _years.length,
                  builder: (context, i) {
                    final isSelected = _years[i] == widget.value;
                    return Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withAlpha(102),
                          fontSize: isSelected ? 20 : 16,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        ),
                        child: Text(_years[i].toString()),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── University year groups ──────────────────────────────────────────────

class _UniversityYearGroups extends StatelessWidget {
  final AppLocalizations l;
  final String? selected;
  final void Function(String) onSelect;

  const _UniversityYearGroups({required this.l, this.selected, required this.onSelect});

  static const _lmd = ['L1', 'L2', 'L3', 'M1', 'M2'];
  static const _ge  = ['1A', '2A', '3A', '4A', '5A'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.step2UniversityYear,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        // LMD group
        Text(l.step2LmdSystem,
            style: const TextStyle(color: AppColors.textHint, fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Row(
          children: _lmd.asMap().entries.map((e) {
            final y = e.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: e.key < _lmd.length - 1 ? 6 : 0),
                child: _YearChip(year: y, selected: selected, onSelect: onSelect),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // GE group
        Text(l.step2EngineerSystem,
            style: const TextStyle(color: AppColors.textHint, fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Row(
          children: _ge.asMap().entries.map((e) {
            final y = e.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: e.key < _ge.length - 1 ? 6 : 0),
                child: _YearChip(year: y, selected: selected, onSelect: onSelect),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _YearChip extends StatelessWidget {
  final String year;
  final String? selected;
  final void Function(String) onSelect;
  const _YearChip({required this.year, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isSelected = year == selected;
    return GestureDetector(
      onTap: () => onSelect(year),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withAlpha(31) : AppColors.glassFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.glassBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          year,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
      );
}

class _BacStreamCard extends StatefulWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _BacStreamCard({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  State<_BacStreamCard> createState() => _BacStreamCardState();
}

class _BacStreamCardState extends State<_BacStreamCard> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: 100.ms,
        curve: Curves.elasticOut,
        child: AnimatedContainer(
          duration: 200.ms,
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.accent.withAlpha(31) : AppColors.glassFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected ? AppColors.accent : AppColors.glassBorder,
              width: widget.isSelected ? 1.5 : 1,
            ),
            boxShadow: widget.isSelected
                ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 10)]
                : null,
          ),
          child: Column(
            children: [
              Text(widget.icon, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.isSelected ? AppColors.accent : AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagInput extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> tags;
  final TextEditingController controller;
  final void Function(String) onAdd;
  final void Function(String) onRemove;

  const _TagInput({
    required this.label, required this.hint,
    required this.tags, required this.controller,
    required this.onAdd, required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: 8, runSpacing: 6,
            children: tags.map((tag) => _TagChip(label: tag, onRemove: () => onRemove(tag))).toList(),
          ),
          const SizedBox(height: 10),
        ],
        if (tags.length < 5)
          Row(
            children: [
              Expanded(
                child: GlassTextField(label: '', hint: hint, controller: controller, textInputAction: TextInputAction.done),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  final t = controller.text.trim();
                  if (t.isNotEmpty) { onAdd(t); controller.clear(); }
                },
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(31),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent.withAlpha(100)),
                  ),
                  child: const Icon(Icons.add_rounded, color: AppColors.accent, size: 20),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _TagChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary.withAlpha(31),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withAlpha(100)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, color: AppColors.secondary, size: 14),
          ),
        ],
      ),
    );
  }
}
