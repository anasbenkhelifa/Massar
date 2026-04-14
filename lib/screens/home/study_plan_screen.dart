import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';

class StudyPlanScreen extends ConsumerWidget {
  const StudyPlanScreen({super.key});

  static const _days = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final profile = ref.watch(onboardingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final bg2 = isDark ? AppColors.background2 : const Color(0xFFE8EEF8);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    final hours = profile.studyHoursPerDay ?? 3;
    final subjects = profile.strongSubjects.isNotEmpty
        ? profile.strongSubjects
        : ['رياضيات', 'فيزياء', 'خوارزميات'];

    // Generate a plan from subjects
    final plan = List.generate(7, (i) {
      final subject = subjects[i % subjects.length];
      return _DayPlan(
        day: _days[i],
        blocks: i < 6 ? [
          _Block(subject, hours, _blockColor(i)),
          if (i % 2 == 0) _Block('مراجعة', 1, AppColors.secondary),
        ] : [],
        isRest: i == 6,
      );
    });

    final completedDays = plan.where((d) => !d.isRest).length;
    final completedPct = DateTime.now().weekday / 7;

    return Scaffold(
      backgroundColor: bg1,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [bg1, bg2]),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      Expanded(
                        child: Text(l.homeServicePlan, style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.accent.withAlpha(70)),
                        ),
                        child: Text('$hours ساعة/يوم', style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Week progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('تقدم الأسبوع', style: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                          Text('${(completedPct * 100).round()}%', style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: completedPct,
                          backgroundColor: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(10),
                          valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 20),

                // Day cards horizontal scroll
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: plan.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => _DayCard(plan: plan[i], isDark: isDark, isToday: i == (DateTime.now().weekday - 1) % 7)
                        .animate(delay: Duration(milliseconds: 80 + i * 60))
                        .fadeIn(duration: 280.ms)
                        .slideX(begin: 0.05, end: 0),
                  ),
                ),
                const SizedBox(height: 24),

                // Subject breakdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('توزيع المواد', style: TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                ).animate(delay: 300.ms).fadeIn(),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    physics: const BouncingScrollPhysics(),
                    children: subjects.asMap().entries.map((e) {
                      final sessionsPerWeek = (7 / subjects.length).ceil();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SubjectRow(name: e.value, sessions: sessionsPerWeek, color: _blockColor(e.key), isDark: isDark)
                            .animate(delay: Duration(milliseconds: 350 + e.key * 60))
                            .fadeIn(duration: 280.ms),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _blockColor(int i) {
    const colors = [AppColors.accent, AppColors.secondary, Color(0xFFFF8C42), Color(0xFF3B82F6)];
    return colors[i % colors.length];
  }
}

class _DayPlan {
  final String day;
  final List<_Block> blocks;
  final bool isRest;
  const _DayPlan({required this.day, required this.blocks, this.isRest = false});
}

class _Block {
  final String subject;
  final int hours;
  final Color color;
  const _Block(this.subject, this.hours, this.color);
}

class _DayCard extends StatelessWidget {
  final _DayPlan plan;
  final bool isDark, isToday;
  const _DayCard({required this.plan, required this.isDark, required this.isToday});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: 130,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? (isToday ? AppColors.accent.withAlpha(25) : AppColors.glassFill) : (isToday ? AppColors.accent.withAlpha(15) : Colors.white),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isToday ? AppColors.accent : (isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)), width: isToday ? 1.5 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plan.day, style: TextStyle(color: isToday ? AppColors.accent : textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
              if (isToday) ...[
                const SizedBox(height: 2),
                Text('اليوم', style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w500)),
              ],
              const SizedBox(height: 12),
              if (plan.isRest)
                Expanded(child: Center(child: Text('😴\nراحة', textAlign: TextAlign.center, style: TextStyle(color: textSecondary, fontSize: 13))))
              else
                ...plan.blocks.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: b.color.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: b.color.withAlpha(60)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.subject, style: TextStyle(color: b.color, fontSize: 11, fontWeight: FontWeight.w600)),
                        Text('${b.hours}h', style: TextStyle(color: b.color.withAlpha(180), fontSize: 10)),
                      ],
                    ),
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  final String name;
  final int sessions;
  final Color color;
  final bool isDark;
  const _SubjectRow({required this.name, required this.sessions, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassFill : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(15)),
          ),
          child: Row(
            children: [
              Container(width: 4, height: 36, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('$sessions حصص / أسبوع', style: TextStyle(color: textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: color.withAlpha(25), shape: BoxShape.circle),
                child: Center(child: Text('$sessions', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
