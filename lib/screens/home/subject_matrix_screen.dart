import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';

class SubjectMatrixScreen extends ConsumerStatefulWidget {
  const SubjectMatrixScreen({super.key});

  @override
  ConsumerState<SubjectMatrixScreen> createState() => _SubjectMatrixScreenState();
}

class _SubjectMatrixScreenState extends ConsumerState<SubjectMatrixScreen> {
  String _filter = 'all'; // 'all' | 'strong' | 'weak'

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final profile = ref.watch(onboardingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final bg2 = isDark ? AppColors.background2 : const Color(0xFFE8EEF8);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    // Combine subjects from profile, or show defaults
    final strong = profile.strongSubjects.isNotEmpty
        ? profile.strongSubjects
        : ['رياضيات', 'فيزياء', 'إعلام آلي'];
    final weak = profile.weakSubjects.isNotEmpty
        ? profile.weakSubjects
        : ['تاريخ', 'جغرافيا'];

    final allSubjects = [
      ...strong.map((s) => _Subject(s, true)),
      ...weak.map((s) => _Subject(s, false)),
    ];

    final filtered = _filter == 'strong'
        ? allSubjects.where((s) => s.isStrong).toList()
        : _filter == 'weak'
            ? allSubjects.where((s) => !s.isStrong).toList()
            : allSubjects;

    return Scaffold(
      backgroundColor: bg1,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bg1, bg2],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
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
                      Text(l.homeServiceMatrix, style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Summary row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _SummaryBadge(label: '${strong.length} قوية', color: AppColors.accent, isDark: isDark),
                      const SizedBox(width: 10),
                      _SummaryBadge(label: '${weak.length} ضعيفة', color: AppColors.error, isDark: isDark),
                      const SizedBox(width: 10),
                      _SummaryBadge(label: '${allSubjects.length} إجمالي', color: AppColors.secondary, isDark: isDark),
                    ],
                  ).animate().fadeIn(duration: 300.ms),
                ),
                const SizedBox(height: 14),

                // Filter chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _FilterChip(label: 'الكل', id: 'all', selected: _filter, isDark: isDark, onTap: (v) => setState(() => _filter = v)),
                      const SizedBox(width: 10),
                      _FilterChip(label: '✅ قوية', id: 'strong', selected: _filter, isDark: isDark, onTap: (v) => setState(() => _filter = v)),
                      const SizedBox(width: 10),
                      _FilterChip(label: '⚠️ ضعيفة', id: 'weak', selected: _filter, isDark: isDark, onTap: (v) => setState(() => _filter = v)),
                    ],
                  ).animate(delay: 80.ms).fadeIn(duration: 300.ms),
                ),
                const SizedBox(height: 16),

                // Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _SubjectCard(subject: filtered[i], isDark: isDark)
                        .animate(delay: Duration(milliseconds: 100 + i * 60))
                        .fadeIn(duration: 300.ms)
                        .scaleXY(begin: 0.95, end: 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Subject {
  final String name;
  final bool isStrong;
  const _Subject(this.name, this.isStrong);
}

class _SummaryBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;
  const _SummaryBadge({required this.label, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label, id, selected;
  final bool isDark;
  final void Function(String) onTap;
  const _FilterChip({required this.label, required this.id, required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = id == selected;
    return GestureDetector(
      onTap: () => onTap(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent.withAlpha(30) : (isDark ? AppColors.glassFill : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AppColors.accent : (isDark ? AppColors.glassBorder : Colors.black.withAlpha(18))),
        ),
        child: Text(label,
          style: TextStyle(
            color: isActive ? AppColors.accent : (isDark ? AppColors.textSecondary : const Color(0xFF64748B)),
            fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          )),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final _Subject subject;
  final bool isDark;
  const _SubjectCard({required this.subject, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = subject.isStrong ? AppColors.accent : AppColors.error;
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    final score = subject.isStrong ? 0.75 + (subject.name.length % 4) * 0.06 : 0.25 + (subject.name.length % 3) * 0.08;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassFill : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withAlpha(subject.isStrong ? 70 : 60), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(subject.isStrong ? Icons.star_rounded : Icons.warning_amber_rounded, color: color, size: 20),
                  Text('${(score * 100).round()}%', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.name, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: score,
                      backgroundColor: isDark ? Colors.white.withAlpha(12) : Colors.black.withAlpha(10),
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subject.isStrong ? 'نقطة قوة' : 'يحتاج تطوير',
                    style: TextStyle(color: textSecondary, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
