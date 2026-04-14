import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';

class SkillsGapScreen extends ConsumerWidget {
  const SkillsGapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final profile = ref.watch(onboardingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final bg2 = isDark ? AppColors.background2 : const Color(0xFFE8EEF8);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    final acquired = [
      ...profile.strongSubjects.take(4),
      ...profile.likedActivities.take(3),
    ].toSet().toList();
    if (acquired.isEmpty) acquired.addAll(['تحليل البيانات', 'رياضيات', 'إعلام آلي']);

    final gaps = ['مشاريع عملية', 'Git & DevOps', 'لغة إنجليزية تقنية', 'تواصل مهني', 'قواعد بيانات'];
    final matchPct = min(95, ((acquired.length / (acquired.length + gaps.length)) * 100).round());

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
                      Text(l.homeServiceSkills, style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Match Ring ──
                        Center(
                          child: _MatchRing(percent: matchPct, isDark: isDark),
                        ).animate().fadeIn(duration: 400.ms).scaleXY(begin: 0.85, end: 1),

                        const SizedBox(height: 28),

                        // ── Acquired ──
                        Row(
                          children: [
                            const Text('✅', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text('المهارات المكتسبة', style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                          ],
                        ).animate(delay: 150.ms).fadeIn(),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: acquired.asMap().entries.map((e) => _SkillChip(
                            label: e.value, color: AppColors.accent, isDark: isDark,
                          ).animate(delay: Duration(milliseconds: 180 + e.key * 50)).fadeIn().slideX(begin: -0.05, end: 0)).toList(),
                        ),

                        const SizedBox(height: 24),

                        // ── Gaps ──
                        Row(
                          children: [
                            const Text('🎯', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text('فجوات المهارات', style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                          ],
                        ).animate(delay: 250.ms).fadeIn(),
                        const SizedBox(height: 12),
                        ...gaps.asMap().entries.map((e) => _GapRow(
                          label: e.value, priority: e.key < 3, isDark: isDark,
                        ).animate(delay: Duration(milliseconds: 280 + e.key * 70)).fadeIn().slideX(begin: 0.05, end: 0)),

                        const SizedBox(height: 28),

                        // ── CTA ──
                        GestureDetector(
                          onTap: () => context.push('/guide'),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(colors: [AppColors.secondary, Color(0xFF7C3AED)]),
                              boxShadow: [BoxShadow(color: AppColors.secondary.withAlpha(60), blurRadius: 16)],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.school_rounded, color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text('ابحث عن دورات لسد الفجوات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                              ],
                            ),
                          ),
                        ).animate(delay: 400.ms).fadeIn(),
                      ],
                    ),
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

class _MatchRing extends StatelessWidget {
  final int percent;
  final bool isDark;
  const _MatchRing({required this.percent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return SizedBox(
      width: 180, height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(180, 180),
            painter: _RingPainter(percent / 100, isDark),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$percent%', style: TextStyle(color: textPrimary, fontSize: 36, fontWeight: FontWeight.w800)),
              Text('مكتمل', style: TextStyle(color: textSecondary, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final bool isDark;
  const _RingPainter(this.value, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 14.0;

    final bgPaint = Paint()
      ..color = isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..shader = const LinearGradient(colors: [Color(0xFF00D68F), Color(0xFF00B87A)]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * value,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SkillChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;
  const _SkillChip({required this.label, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}

class _GapRow extends StatelessWidget {
  final String label;
  final bool priority, isDark;
  const _GapRow({required this.label, required this.priority, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.glassFill : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: priority ? AppColors.warning.withAlpha(80) : (isDark ? AppColors.glassBorder : Colors.black.withAlpha(15))),
            ),
            child: Row(
              children: [
                Icon(Icons.circle, color: priority ? AppColors.warning : AppColors.error, size: 8),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500))),
                if (priority)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.warning.withAlpha(70)),
                    ),
                    child: const Text('أولوية', style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
