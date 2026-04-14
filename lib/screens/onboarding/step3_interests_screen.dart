import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../data/domains.dart';
import '../../theme/app_theme.dart';
import '../../widgets/onboarding/onboarding_scaffold.dart';
import '../../widgets/onboarding/step_header.dart';
import '../../widgets/onboarding/glass_chip_selector.dart';
import '../../widgets/onboarding/glass_radio_cards.dart';
import '../../widgets/onboarding/glass_slider_field.dart';
import '../../widgets/onboarding/glass_text_field.dart';

class Step3InterestsScreen extends ConsumerStatefulWidget {
  const Step3InterestsScreen({super.key});

  @override
  ConsumerState<Step3InterestsScreen> createState() => _Step3InterestsScreenState();
}

class _Step3InterestsScreenState extends ConsumerState<Step3InterestsScreen> {
  List<String> _domains = [];
  List<String> _activities = [];
  List<String> _workStyle = [];
  String? _environment;
  String? _shortTermGoal;
  String? _sector;
  String? _salaryPriority;
  final _extraCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = ref.read(onboardingProvider);
    _domains = List.from(s.interestDomains);
    _activities = List.from(s.likedActivities);
    _workStyle = List.from(s.workStyle);
    _environment = s.environmentPref;
    _shortTermGoal = s.shortTermGoal;
    _sector = s.sectorPreference;
    _salaryPriority = s.salaryPriority;
    if (s.extraContext != null) _extraCtrl.text = s.extraContext!;
  }

  @override
  void dispose() { _extraCtrl.dispose(); super.dispose(); }

  bool get _canContinue =>
      _domains.isNotEmpty && _workStyle.isNotEmpty &&
      _environment != null && _shortTermGoal != null &&
      _sector != null && _salaryPriority != null;

  void _saveAndContinue(bool fromProfile) {
    ref.read(onboardingProvider.notifier).setStep3(
      interestDomains: _domains, likedActivities: _activities,
      workStyle: _workStyle, environmentPref: _environment,
      shortTermGoal: _shortTermGoal, sectorPreference: _sector,
      salaryPriority: _salaryPriority,
      extraContext: _extraCtrl.text.isEmpty ? null : _extraCtrl.text,
    );
    if (fromProfile) {
      context.push('/onboarding/step4', extra: {'fromProfile': true});
    } else {
      context.go('/onboarding/step4');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fromProfile = (GoRouterState.of(context).extra as Map<Object?, Object?>?)?['fromProfile'] == true;

    return OnboardingScaffold(
      currentStep: 3,
      totalSteps: 5,
      onBack: () => fromProfile ? context.pop() : context.go('/onboarding/step2'),
      onSkip: () {
        ref.read(onboardingProvider.notifier).markStepSkipped(3);
        if (fromProfile) { context.pop(); } else { context.go('/onboarding/step4'); }
      },
      canContinue: _canContinue,
      onContinue: () => _saveAndContinue(fromProfile),
      continueLabel: l.commonContinue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(title: l.step3Title, microcopy: l.step3Microcopy),
          const SizedBox(height: 28),

          // ── Interest domains ────────────────────────────
          _Label(l.step3DomainsLabel),
          const SizedBox(height: 10),
          _DomainGrid(
            domains: kInterestDomains,
            domainLabel: (d) => _domainLabel(l, d.id),
            selected: _domains,
            onToggle: (id, sel) => setState(() {
              if (sel && _domains.length < 3) { _domains.add(id); }
              else { _domains.remove(id); }
            }),
          ),
          const SizedBox(height: 20),

          // ── Liked activities ────────────────────────────
          GlassChipSelector(
            label: l.step3ActivitiesLabel,
            options: [
              ChipOption(id: 'building_things', label: '🔨 ${l.actBuildingThings}'),
              ChipOption(id: 'helping_people',  label: '🤝 ${l.actHelpingPeople}'),
              ChipOption(id: 'writing',         label: '✍️ ${l.actWriting}'),
              ChipOption(id: 'analyzing_data',  label: '📊 ${l.actAnalyzingData}'),
              ChipOption(id: 'designing',       label: '🎨 ${l.actDesigning}'),
              ChipOption(id: 'teaching',        label: '📚 ${l.actTeaching}'),
              ChipOption(id: 'researching',     label: '🔍 ${l.actResearching}'),
              ChipOption(id: 'organizing',      label: '📋 ${l.actOrganizing}'),
            ],
            selected: _activities,
            onToggle: (id, sel) => setState(() {
              if (sel) { _activities.add(id); } else { _activities.remove(id); }
            }),
          ),
          const SizedBox(height: 20),

          // ── Work style icon cards ───────────────────────
          _Label(l.step3WorkStyleLabel),
          const SizedBox(height: 10),
          _IconCardGrid(
            options: kWorkStyles,
            labelOf: (id) => _workStyleLabel(l, id),
            selected: _workStyle,
            onToggle: (id, sel) => setState(() {
              if (sel) { _workStyle.add(id); } else { _workStyle.remove(id); }
            }),
          ),
          const SizedBox(height: 20),

          // ── Environment ─────────────────────────────────
          GlassRadioCards(
            label: l.step3EnvironmentLabel,
            options: kEnvironments.map((e) => RadioOption(
              id: e.id, label: _envLabel(l, e.id), icon: e.icon,
            )).toList(),
            selected: _environment,
            onSelect: (id) => setState(() => _environment = id),
          ),
          const SizedBox(height: 20),

          // ── Short term goal ─────────────────────────────
          _Label(l.step3GoalLabel),
          const SizedBox(height: 10),
          ..._buildGoalCards(l),
          const SizedBox(height: 20),

          // ── Sector ─────────────────────────────────────
          _Label(l.step3SectorLabel),
          const SizedBox(height: 10),
          Row(
            children: [
              _SectorPill(id: 'public',  label: l.sectorPublic,  selected: _sector, onTap: (id) => setState(() => _sector = id)),
              const SizedBox(width: 8),
              _SectorPill(id: 'private', label: l.sectorPrivate, selected: _sector, onTap: (id) => setState(() => _sector = id)),
              const SizedBox(width: 8),
              _SectorPill(id: 'both',    label: l.sectorBoth,    selected: _sector, onTap: (id) => setState(() => _sector = id)),
              const SizedBox(width: 8),
              _SectorPill(id: 'ngo',     label: l.sectorNgo,     selected: _sector, onTap: (id) => setState(() => _sector = id)),
            ],
          ),
          const SizedBox(height: 20),

          // ── Salary priority ─────────────────────────────
          _Label(l.step3SalaryLabel),
          const SizedBox(height: 8),
          SalaryPrioritySlider(
            value: _salaryPriority,
            onChanged: (v) => setState(() => _salaryPriority = v),
            lowLabel: l.step3SalaryLow,
            medLabel: l.step3SalaryMedium,
            highLabel: l.step3SalaryHigh,
          ),
          const SizedBox(height: 20),

          // ── Extra context ───────────────────────────────
          GlassTextField(
            label: l.step3ExtraLabel,
            hint: l.step3ExtraHint,
            controller: _extraCtrl,
            maxLines: 4,
            maxLength: 300,
            optional: true,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGoalCards(AppLocalizations l) {
    final goals = [
      ('get_job',          '💼', l.goalGetJob,     l.goalGetJobDesc),
      ('continue_masters', '📘', l.goalMasters,    l.goalMastersDesc),
      ('continue_phd',     '🔬', l.goalPhd,        l.goalPhdDesc),
      ('start_business',   '🚀', l.goalBusiness,   l.goalBusinessDesc),
      ('emigrate',         '✈️', l.goalEmigrate,   l.goalEmigrateDesc),
    ];
    return goals.map((g) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _GoalCard(
        id: g.$1, icon: g.$2, label: g.$3, desc: g.$4,
        selected: _shortTermGoal,
        onSelect: (id) => setState(() => _shortTermGoal = id),
      ),
    )).toList();
  }

  String _domainLabel(AppLocalizations l, String id) {
    switch (id) {
      case 'technology':   return l.domainTechnology;
      case 'medicine':     return l.domainMedicine;
      case 'law':          return l.domainLaw;
      case 'engineering':  return l.domainEngineering;
      case 'business':     return l.domainBusiness;
      case 'arts':         return l.domainArts;
      case 'education':    return l.domainEducation;
      case 'science':      return l.domainScience;
      case 'agriculture':  return l.domainAgriculture;
      case 'architecture': return l.domainArchitecture;
      case 'sport_science':return l.domainSportScience;
      case 'journalism':   return l.domainJournalism;
      default:             return id;
    }
  }

  String _workStyleLabel(AppLocalizations l, String id) {
    switch (id) {
      case 'solo':       return l.workStyleSolo;
      case 'team':       return l.workStyleTeam;
      case 'creative':   return l.workStyleCreative;
      case 'analytical': return l.workStyleAnalytical;
      case 'hands_on':   return l.workStyleHandsOn;
      case 'research':   return l.workStyleResearch;
      case 'management': return l.workStyleManagement;
      default:           return id;
    }
  }

  String _envLabel(AppLocalizations l, String id) {
    switch (id) {
      case 'office':   return l.envOffice;
      case 'field':    return l.envField;
      case 'lab':      return l.envLab;
      case 'remote':   return l.envRemote;
      case 'hospital': return l.envHospital;
      case 'school':   return l.envSchool;
      case 'outdoor':  return l.envOutdoor;
      default:         return id;
    }
  }
}

// ── Widgets ────────────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
      );
}

class _DomainGrid extends StatelessWidget {
  final List<DomainOption> domains;
  final String Function(DomainOption) domainLabel;
  final List<String> selected;
  final void Function(String, bool) onToggle;
  const _DomainGrid({required this.domains, required this.domainLabel, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1,
      ),
      itemCount: domains.length,
      itemBuilder: (_, i) {
        final d = domains[i];
        final isSelected = selected.contains(d.id);
        return GestureDetector(
          onTap: () => onToggle(d.id, !isSelected),
          child: AnimatedContainer(
            duration: 200.ms,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent.withAlpha(31) : AppColors.glassFill,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.glassBorder,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 10)] : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(d.icon, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 6),
                Text(
                  domainLabel(d),
                  textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? AppColors.accent : AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _IconCardGrid extends StatelessWidget {
  final List<DomainOption> options;
  final String Function(String id) labelOf;
  final List<String> selected;
  final void Function(String, bool) onToggle;
  const _IconCardGrid({required this.options, required this.labelOf, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10, runSpacing: 10,
      children: options.map((opt) {
        final isSelected = selected.contains(opt.id);
        return GestureDetector(
          onTap: () => onToggle(opt.id, !isSelected),
          child: AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent.withAlpha(31) : AppColors.glassFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.glassBorder,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 8)] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(opt.icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  labelOf(opt.id),
                  style: TextStyle(
                    color: isSelected ? AppColors.accent : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String id, icon, label, desc;
  final String? selected;
  final void Function(String) onSelect;
  const _GoalCard({required this.id, required this.icon, required this.label, required this.desc, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == id;
    return GestureDetector(
      onTap: () => onSelect(id),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withAlpha(26) : AppColors.glassFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.accent : AppColors.glassBorder, width: isSelected ? 1.5 : 1),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 12)] : null,
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: isSelected ? AppColors.accent : AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500)),
                  Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.accent : AppColors.textHint, size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectorPill extends StatelessWidget {
  final String id, label;
  final String? selected;
  final void Function(String) onTap;
  const _SectorPill({required this.id, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(id),
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent.withAlpha(31) : AppColors.glassFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? AppColors.accent : AppColors.glassBorder, width: isSelected ? 1.5 : 1),
            boxShadow: isSelected ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 8)] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
              fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
