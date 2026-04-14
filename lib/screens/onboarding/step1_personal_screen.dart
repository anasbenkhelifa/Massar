import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../widgets/onboarding/glass_text_field.dart';
import '../../widgets/onboarding/glass_dropdown.dart';
import '../../widgets/onboarding/glass_toggle_card.dart';

class Step1PersonalScreen extends ConsumerStatefulWidget {
  const Step1PersonalScreen({super.key});

  @override
  ConsumerState<Step1PersonalScreen> createState() => _Step1PersonalScreenState();
}

class _Step1PersonalScreenState extends ConsumerState<Step1PersonalScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  int? _birthYear;
  String? _gender;
  int? _wilayaCode;
  String? _communeName;
  double _passwordStrength = 0;

  // Drum roll: index into years list (1990–2010 = 21 items, default middle)
  late final FixedExtentScrollController _yearScrollCtrl;
  static final List<int> _years = List.generate(21, (i) => 2010 - i); // 2010→1990

  @override
  void initState() {
    super.initState();
    final s = ref.read(onboardingProvider);
    if (s.fullName != null) _nameCtrl.text = s.fullName!;
    if (s.email != null) _emailCtrl.text = s.email!;
    if (s.phone != null) _phoneCtrl.text = s.phone!;
    _gender = s.gender;
    _wilayaCode = s.wilayaCode;
    _communeName = s.communeName;

    final savedYear = s.birthYear ?? 2002;
    _birthYear = savedYear;
    final initialIndex = _years.indexOf(savedYear).clamp(0, _years.length - 1);
    _yearScrollCtrl = FixedExtentScrollController(initialItem: initialIndex);

    _passCtrl.addListener(_updateStrength);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _yearScrollCtrl.dispose();
    super.dispose();
  }

  void _updateStrength() {
    final p = _passCtrl.text;
    double s = 0;
    if (p.length >= 8) s += 0.34;
    if (p.contains(RegExp(r'[A-Z]')) || p.contains(RegExp(r'[0-9]'))) s += 0.33;
    if (p.contains(RegExp(r'[!@#\$&*~]'))) s += 0.33;
    setState(() => _passwordStrength = s);
  }

  bool get _canContinue {
    return _nameCtrl.text.isNotEmpty &&
        _birthYear != null &&
        _gender != null &&
        _wilayaCode != null &&
        _communeName != null &&
        _emailCtrl.text.isNotEmpty &&
        RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailCtrl.text) &&
        _passCtrl.text.length >= 8 &&
        _passCtrl.text == _confirmCtrl.text;
  }

  void _saveAndContinue(bool fromProfile) {
    ref.read(onboardingProvider.notifier).setStep1(
      fullName: _nameCtrl.text,
      birthYear: _birthYear,
      gender: _gender,
      wilayaCode: _wilayaCode,
      communeName: _communeName,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text.isEmpty ? null : _phoneCtrl.text,
      password: _passCtrl.text,
    );
    if (fromProfile) {
      context.push('/onboarding/step2', extra: {'fromProfile': true});
    } else {
      context.go('/onboarding/step2');
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

    return OnboardingScaffold(
      currentStep: 1,
      totalSteps: 5,
      onBack: () => fromProfile ? context.pop() : context.go('/onboarding/language'),
      onSkip: () {
        ref.read(onboardingProvider.notifier).markStepSkipped(1);
        if (fromProfile) { context.pop(); } else { context.go('/onboarding/step2'); }
      },
      canContinue: _canContinue,
      onContinue: () => _saveAndContinue(fromProfile),
      continueLabel: l.commonContinue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(title: l.step1Title, microcopy: l.step1Microcopy),
          const SizedBox(height: 28),

          // Full name
          GlassTextField(
            label: l.step1FullName,
            hint: l.step1FullNameHint,
            controller: _nameCtrl,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Birth year — drum roll wheel
          _BirthYearWheel(
            label: l.step1BirthYear,
            years: _years,
            scrollCtrl: _yearScrollCtrl,
            selectedYear: _birthYear,
            onChanged: (y) => setState(() => _birthYear = y),
          ),
          const SizedBox(height: 16),

          // Gender — 2 cards only
          _FieldLabel(l.step1Gender),
          const SizedBox(height: 8),
          GlassToggleGroup(
            options: [
              ToggleOption(id: 'male',   label: l.step1Male,   icon: '👨'),
              ToggleOption(id: 'female', label: l.step1Female, icon: '👩'),
            ],
            selected: _gender,
            onSelect: (g) => setState(() => _gender = g),
          ),
          const SizedBox(height: 16),

          // Wilaya
          GlassDropdown<int>(
            label: l.step1Wilaya,
            placeholder: l.step1WilayaPlaceholder,
            searchable: true,
            items: kWilayas.map((w) => DropdownItem(
              value: w.code,
              label: '${w.code.toString().padLeft(2, '0')} — ${isAr ? w.nameAr : w.nameFr}',
            )).toList(),
            value: _wilayaCode,
            onChanged: (v) => setState(() {
              _wilayaCode = v;
              _communeName = null;
            }),
          ),
          const SizedBox(height: 16),

          // Commune (cascades)
          GlassDropdown<String>(
            label: l.step1Commune,
            placeholder: _wilayaCode == null
                ? l.step1CommuneSelectFirst
                : l.step1CommunePlaceholder,
            searchable: true,
            items: selectedWilaya?.communes
                    .map((c) => DropdownItem(value: c, label: c))
                    .toList() ??
                [],
            value: _communeName,
            onChanged: (v) => setState(() => _communeName = v),
          ),
          const SizedBox(height: 16),

          // Email
          GlassTextField(
            label: l.step1Email,
            hint: l.step1EmailHint,
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Phone (optional)
          GlassTextField(
            label: l.step1Phone,
            hint: l.step1PhoneHint,
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            optional: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Password
          GlassTextField(
            label: l.step1Password,
            hint: l.step1PasswordHint,
            controller: _passCtrl,
            obscureText: true,
            showPasswordToggle: true,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 8),
          _PasswordStrengthBar(
            strength: _passwordStrength,
            weak: l.step1PasswordWeak,
            fair: l.step1PasswordFair,
            strong: l.step1PasswordStrong,
          ),
          const SizedBox(height: 16),

          // Confirm password
          GlassTextField(
            label: l.step1ConfirmPassword,
            hint: l.step1ConfirmPasswordHint,
            controller: _confirmCtrl,
            obscureText: true,
            showPasswordToggle: true,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.done,
          ),
          if (_confirmCtrl.text.isNotEmpty && _confirmCtrl.text != _passCtrl.text) ...[
            const SizedBox(height: 6),
            Text(
              l.step1PasswordMismatch,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
      );
}

// ── Fix 4: Drum-roll birth year wheel ─────────────────────────────────────────

class _BirthYearWheel extends StatelessWidget {
  final String label;
  final List<int> years;
  final FixedExtentScrollController scrollCtrl;
  final int? selectedYear;
  final void Function(int) onChanged;

  const _BirthYearWheel({
    required this.label,
    required this.years,
    required this.scrollCtrl,
    required this.selectedYear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Selection highlight band
              Center(
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(26), // 0.10
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent.withAlpha(77)), // 0.30
                  ),
                ),
              ),
              ListWheelScrollView.useDelegate(
                controller: scrollCtrl,
                itemExtent: 48,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (i) {
                  HapticFeedback.selectionClick();
                  onChanged(years[i]);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: years.length,
                  builder: (context, i) {
                    final year = years[i];
                    final isSelected = year == selectedYear;
                    return Center(
                      child: AnimatedDefaultTextStyle(
                        duration: 150.ms,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textPrimary.withAlpha(102), // 0.40
                          fontSize: isSelected ? 24 : 18,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        ),
                        child: Text(year.toString()),
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

// ── Password strength bar ──────────────────────────────────────────────────────

class _PasswordStrengthBar extends StatelessWidget {
  final double strength;
  final String weak;
  final String fair;
  final String strong;

  const _PasswordStrengthBar({
    required this.strength,
    required this.weak,
    required this.fair,
    required this.strong,
  });

  Color get _color {
    if (strength <= 0.34) return AppColors.error;
    if (strength <= 0.67) return AppColors.warning;
    return AppColors.accent;
  }

  String _label() {
    if (strength <= 0) return '';
    if (strength <= 0.34) return weak;
    if (strength <= 0.67) return fair;
    return strong;
  }

  @override
  Widget build(BuildContext context) {
    if (strength <= 0) return const SizedBox.shrink();
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: strength,
              backgroundColor: AppColors.glassBorder,
              valueColor: AlwaysStoppedAnimation(_color),
              minHeight: 3,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(_label(), style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
