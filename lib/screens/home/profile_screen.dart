import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/wilayas.dart';
import '../../l10n/app_localizations.dart';
import '../../models/onboarding_state.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  final bool standalone;
  const ProfileScreen({super.key, this.standalone = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final profile = ref.watch(onboardingProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final bg2 = isDark ? AppColors.background2 : const Color(0xFFE8EEF8);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    final name = profile.fullName ?? '';
    final initials = name.split(' ').where((w) => w.isNotEmpty).take(2).map((w) => w[0].toUpperCase()).join();
    final email = profile.email ?? '';
    final stepsCompleted = [
      profile.fullName != null,
      profile.bacStream != null,
      profile.interestDomains.isNotEmpty,
      profile.homeWilayaCode != null,
      profile.studyHoursPerDay != null,
    ].where((v) => v).length;

    final notSet = l.profileFieldNotSet;
    final isAr = locale.languageCode == 'ar';

    // First incomplete step (1-based), null if all done
    final incompleteStep = _firstIncompleteStep(profile);

    // Location display: resolve name from code for locale-correct display
    String locationDisplay() {
      final code = profile.homeWilayaCode ?? profile.wilayaCode;
      if (code == null) return notSet;
      try {
        final w = kWilayas.firstWhere((w) => w.code == code);
        final wilayaName = isAr ? w.nameAr : w.nameFr;
        final commune = profile.homeCommuneName ?? profile.communeName;
        return commune != null ? '$commune, $wilayaName' : wilayaName;
      } catch (_) {
        return notSet;
      }
    }

    // Gender label (fully localized)
    String genderLabel(String? g) {
      if (g == 'male') return l.step1Male;
      if (g == 'female') return l.step1Female;
      return notSet;
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.background1 : const Color(0xFFF2F5FB),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [bg1, bg2]),
            ),
          ),
          if (isDark)
            Positioned(
              top: -60, right: -40,
              child: Container(
                width: 240, height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [AppColors.accent.withAlpha(18), Colors.transparent]),
                ),
              ),
            ),
          SafeArea(
            bottom: standalone,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, standalone ? 40 : 100),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    children: [
                      if (standalone) ...[
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.glassFill : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
                            ),
                            child: Icon(Icons.arrow_back_ios_new_rounded, color: textSecondary, size: 16),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Text(l.profileTitle, style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 28),

                  // Avatar + info
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 88, height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF00D68F), Color(0xFF8B5CF6)],
                            ),
                            boxShadow: [BoxShadow(color: AppColors.accentGlow, blurRadius: 24, spreadRadius: 2)],
                          ),
                          child: Center(
                            child: Text(
                              initials.isEmpty ? '🎓' : initials,
                              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(name.isEmpty ? '—' : name, style: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(email, style: TextStyle(color: textSecondary, fontSize: 13)),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) => Container(
                            width: 30, height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: i < stepsCompleted ? AppColors.accent : (isDark ? Colors.white.withAlpha(25) : Colors.black.withAlpha(15)),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )),
                        ),
                        const SizedBox(height: 6),
                        Text(l.profileStepsCompleted(stepsCompleted), style: TextStyle(color: textSecondary, fontSize: 11)),

                        // ── Continue filling CTA ──
                        if (incompleteStep != null) ...
                          [const SizedBox(height: 16), _ContinueCta(
                            l: l,
                            isDark: isDark,
                            stepsCompleted: stepsCompleted,
                            onTap: () => context.push('/onboarding/step$incompleteStep', extra: {'fromProfile': true}),
                          )],
                      ],
                    ),
                  ).animate(delay: 80.ms).fadeIn(duration: 350.ms).slideY(begin: 0.03, end: 0),

                  const SizedBox(height: 28),

                  // ── App Settings ──
                  _SectionTitle(l.profileAppSettings, isDark),
                  const SizedBox(height: 12),
                  _glassSection(isDark, [
                    // Dark/Light toggle
                    _SettingsRow(
                      isDark: isDark,
                      icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      iconColor: isDark ? AppColors.secondary : const Color(0xFFFFA500),
                      label: isDark ? l.profileDarkMode : l.profileLightMode,
                      trailing: Switch(
                        value: isDark,
                        onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
                        activeColor: AppColors.accent,
                        inactiveThumbColor: const Color(0xFFFFA500),
                        inactiveTrackColor: const Color(0xFFFFA500).withAlpha(60),
                      ),
                    ),
                    _Divider(isDark),
                    // Language switcher
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(color: AppColors.accent.withAlpha(25), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.language_rounded, color: AppColors.accent, size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Text(l.profileLanguage, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500))),
                          Row(children: [
                            _LangButton(code: 'ar', label: 'ع', currentCode: locale.languageCode, isDark: isDark, onTap: () => ref.read(localeProvider.notifier).setLocale('ar')),
                            const SizedBox(width: 6),
                            _LangButton(code: 'fr', label: 'Fr', currentCode: locale.languageCode, isDark: isDark, onTap: () => ref.read(localeProvider.notifier).setLocale('fr')),
                            const SizedBox(width: 6),
                            _LangButton(code: 'en', label: 'En', currentCode: locale.languageCode, isDark: isDark, onTap: () => ref.read(localeProvider.notifier).setLocale('en')),
                          ]),
                        ],
                      ),
                    ),
                  ]).animate(delay: 140.ms).fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),

                  // ── Personal Info ──
                  _SectionTitle(l.profilePersonalInfo, isDark),
                  const SizedBox(height: 12),
                  _glassSection(isDark, [
                    _EditableRow(
                      isDark: isDark, label: l.profileFieldFullName,
                      value: profile.fullName ?? notSet,
                      onEdit: () => _showEditSheet(context, ref, l.profileFieldFullName, profile.fullName, isDark, (v) {
                        ref.read(onboardingProvider.notifier).update((s) => s.copyWith(fullName: v));
                      }),
                    ),
                    _Divider(isDark),
                    _EditableRow(
                      isDark: isDark, label: l.profileFieldBirthYear,
                      value: profile.birthYear?.toString() ?? notSet,
                      isNumeric: true,
                      onEdit: () => _showEditSheet(context, ref, l.profileFieldBirthYear, profile.birthYear?.toString(), isDark, (v) {
                        final yr = int.tryParse(v);
                        if (yr != null) ref.read(onboardingProvider.notifier).update((s) => s.copyWith(birthYear: yr));
                      }),
                    ),
                    _Divider(isDark),
                    _InfoRow(isDark: isDark, label: l.profileFieldGender, value: genderLabel(profile.gender)),
                    _Divider(isDark),
                    _EditableRow(
                      isDark: isDark, label: l.profileFieldWilaya,
                      value: locationDisplay(),
                      onEdit: () {},  // location editing requires the full dropdown flow
                    ),
                  ]).animate(delay: 200.ms).fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),

                  // ── Academic ──
                  _SectionTitle(l.profileAcademicInfo, isDark),
                  const SizedBox(height: 12),
                  _glassSection(isDark, [
                    _InfoRow(isDark: isDark, label: l.profileFieldBacStream, value: profile.bacStream ?? notSet),
                    _Divider(isDark),
                    _EditableRow(
                      isDark: isDark, label: l.profileFieldBacAverage,
                      value: profile.bacAverage != null ? '${profile.bacAverage!.toStringAsFixed(2)}/20' : notSet,
                      isNumeric: true,
                      onEdit: () => _showEditSheet(context, ref, l.profileFieldBacAverage, profile.bacAverage?.toString(), isDark, (v) {
                        final avg = double.tryParse(v);
                        if (avg != null) ref.read(onboardingProvider.notifier).update((s) => s.copyWith(bacAverage: avg));
                      }),
                    ),
                    _Divider(isDark),
                    _EditableRow(
                      isDark: isDark, label: l.profileFieldMajor,
                      value: profile.currentMajor ?? notSet,
                      onEdit: () => _showEditSheet(context, ref, l.profileFieldMajor, profile.currentMajor, isDark, (v) {
                        ref.read(onboardingProvider.notifier).update((s) => s.copyWith(currentMajor: v));
                      }),
                    ),
                    _Divider(isDark),
                    _InfoRow(isDark: isDark, label: l.profileFieldYear, value: profile.currentYear ?? notSet),
                  ]).animate(delay: 260.ms).fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),

                  // ── Danger Zone ──
                  _SectionTitle(l.profileDangerZone, isDark, isRed: true),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _confirmReset(context, ref, l, isDark),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.error.withAlpha(100)),
                        color: AppColors.error.withAlpha(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 18),
                          const SizedBox(width: 8),
                          Text(l.profileReset, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w700, fontSize: 14)),
                        ],
                      ),
                    ),
                  ).animate(delay: 340.ms).fadeIn(duration: 300.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(
    BuildContext context,
    WidgetRef ref,
    String label,
    String? currentValue,
    bool isDark,
    void Function(String) onSave,
  ) {
    final l = AppLocalizations.of(context);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    final ctrl = TextEditingController(text: currentValue ?? '');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xED0D1425) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(top: BorderSide(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(15))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(20), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 20),
                  Text(label, style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: ctrl,
                    autofocus: true,
                    style: TextStyle(color: textPrimary, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: label,
                      hintStyle: TextStyle(color: textSecondary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.glassBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(20))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
                      filled: true,
                      fillColor: isDark ? AppColors.glassFill : Colors.grey.withAlpha(12),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.glassFill : Colors.grey.withAlpha(25),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
                            ),
                            child: Center(child: Text(l.profileResetCancel, style: TextStyle(color: textSecondary, fontWeight: FontWeight.w600))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            final val = ctrl.text.trim();
                            if (val.isNotEmpty) onSave(val);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(colors: [Color(0xFF00D68F), Color(0xFF00B87A)]),
                              boxShadow: [BoxShadow(color: AppColors.accentGlow, blurRadius: 12)],
                            ),
                            child: Center(child: Text(l.profileEditSave, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref, AppLocalizations l, bool isDark) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0D1425) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l.profileResetConfirmTitle, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
        content: Text(l.profileResetConfirmBody, style: TextStyle(color: textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l.profileResetCancel, style: const TextStyle(color: AppColors.accent))),
          TextButton(
            onPressed: () {
              ref.read(onboardingProvider.notifier).clearSavedOnboarding();
              Navigator.pop(context);
              context.go('/');
            },
            child: Text(l.profileResetConfirm, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

// Returns 1-5 for the first unfilled step, null if all complete
int? _firstIncompleteStep(OnboardingState s) {
  if (s.fullName == null) return 1;
  if (s.bacStream == null) return 2;
  if (s.interestDomains.isEmpty) return 3;
  if (s.homeWilayaCode == null) return 4;
  if (s.studyHoursPerDay == null) return 5;
  return null;
}

class _ContinueCta extends StatelessWidget {
  final AppLocalizations l;
  final bool isDark;
  final int stepsCompleted;
  final VoidCallback onTap;
  const _ContinueCta({required this.l, required this.isDark, required this.stepsCompleted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent.withAlpha(isDark ? 35 : 22), AppColors.secondary.withAlpha(isDark ? 28 : 18)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.accent.withAlpha(100)),
            ),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_note_rounded, color: AppColors.accent, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.profileContinueFilling,
                        style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(l.profileContinueFillingDesc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textSecondary, fontSize: 11, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: AppColors.accentGlow, blurRadius: 10)],
                  ),
                  child: Text(l.profileContinueButton,
                    style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.04, end: 0);
  }
}

Widget _glassSection(bool isDark, List<Widget> children) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.glassFill : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
        ),
        child: Column(children: children),
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final bool isDark, isRed;
  const _SectionTitle(this.text, this.isDark, {this.isRed = false});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      color: isRed ? AppColors.error : (isDark ? AppColors.textSecondary : const Color(0xFF64748B)),
      fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.8,
    ));
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider(this.isDark);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool isDark;
  const _InfoRow({required this.isDark, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: textSecondary, fontSize: 13))),
          Text(value, style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _EditableRow extends StatelessWidget {
  final String label, value;
  final bool isDark, isNumeric;
  final VoidCallback onEdit;
  const _EditableRow({required this.isDark, required this.label, required this.value, required this.onEdit, this.isNumeric = false});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return GestureDetector(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(color: textSecondary, fontSize: 13))),
            Text(value, style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Icon(Icons.edit_rounded, color: AppColors.accent, size: 15),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget trailing;
  const _SettingsRow({required this.isDark, required this.icon, required this.iconColor, required this.label, required this.trailing});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withAlpha(25), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500))),
          trailing,
        ],
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String code, label, currentCode;
  final bool isDark;
  final VoidCallback onTap;
  const _LangButton({required this.code, required this.label, required this.currentCode, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = code == currentCode;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38, height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent.withAlpha(30) : (isDark ? AppColors.glassFill : Colors.grey.withAlpha(20)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? AppColors.accent : (isDark ? AppColors.glassBorder : Colors.black.withAlpha(18))),
        ),
        child: Text(label, style: TextStyle(
          color: isActive ? AppColors.accent : (isDark ? AppColors.textSecondary : const Color(0xFF64748B)),
          fontSize: 12, fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
        )),
      ),
    );
  }
}
