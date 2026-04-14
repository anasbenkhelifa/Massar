import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';

class CareerPathScreen extends ConsumerWidget {
  const CareerPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final profile = ref.watch(onboardingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final bg2 = isDark ? AppColors.background2 : const Color(0xFFE8EEF8);
    final cardColor = isDark ? AppColors.glassFill : Colors.white;
    final borderColor = isDark ? AppColors.glassBorder : Colors.black.withAlpha(18);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    // Derive top career from interests
    final domains = profile.interestDomains;
    final primaryDomain = domains.isNotEmpty ? domains.first : 'technology';

    final careerMap = {
      'technology':   _Career('مهندس برمجيات', '💻', 87, ['Python', 'Flutter', 'Cloud'], 'مهاراتك التقنية ومجالات اهتمامك تشير إلى مسار تطوير البرمجيات.'),
      'medicine':     _Career('طبيب عام', '🏥', 91, ['بيولوجيا', 'كيمياء', 'فيزياء'], 'نتائجك الأكاديمية القوية تجعلك مرشحًا ممتازًا للطب.'),
      'engineering':  _Career('مهندس مدني', '🔧', 83, ['رياضيات', 'فيزياء', 'CAD'], 'ميلك للتطبيق العملي يتوافق مع الهندسة المدنية.'),
      'business':     _Career('مدير مشاريع', '💼', 79, ['Excel', 'قيادة', 'تسويق'], 'تفضيلاتك في العمل الجماعي والإدارة مناسبة للأعمال.'),
      'law':          _Career('محامي', '⚖️', 82, ['قانون', 'تحليل', 'تفاوض'], 'دقتك واهتمامك بالتفاصيل تلائم مهنة القانون.'),
      'arts':         _Career('مصمم جرافيك', '🎨', 85, ['Figma', 'تصميم', 'إبداع'], 'موهبتك الإبداعية تجعلك مرشحًا ممتازًا في عالم التصميم.'),
      'science':      _Career('باحث علمي', '🔬', 80, ['إحصاء', 'كتابة علمية', 'تجارب'], 'فضولك العلمي يجعلك مناسبًا للبحث الأكاديمي.'),
      'architecture': _Career('مهندس معماري', '🏛️', 84, ['AutoCAD', 'جماليات', 'هندسة'], 'إحساسك الجمالي والهندسي يناسب العمارة.'),
    };

    final topCareer = careerMap[primaryDomain] ?? careerMap['technology']!;
    final alts = careerMap.entries
        .where((e) => e.key != primaryDomain)
        .take(3)
        .map((e) => e.value)
        .toList();

    final year = profile.currentYear;
    final major = profile.currentMajor ?? 'تخصصك الحالي';

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
          if (isDark) ...[
            Positioned(
              top: -60, right: -40,
              child: Container(
                width: 260, height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [AppColors.accent.withAlpha(18), Colors.transparent]),
                ),
              ),
            ),
          ],
          SafeArea(
            child: Column(
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
                            color: cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor),
                          ),
                          child: Icon(Icons.arrow_back_ios_new_rounded, color: textSecondary, size: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(l.homeServiceCareer,
                        style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Top Match Card ──
                        _glassCard(
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(topCareer.icon, style: const TextStyle(fontSize: 36)),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('أفضل مسار لك', style: TextStyle(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 2),
                                        Text(topCareer.title, style: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withAlpha(30),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: AppColors.accent.withAlpha(80)),
                                    ),
                                    child: Text('${topCareer.match}%', style: const TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: topCareer.match / 100,
                                  backgroundColor: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(10),
                                  valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(topCareer.reason, style: TextStyle(color: textSecondary, fontSize: 13, height: 1.5)),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8, runSpacing: 8,
                                children: topCareer.skills.map((s) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withAlpha(25),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.secondary.withAlpha(60)),
                                  ),
                                  child: Text(s, style: const TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w500)),
                                )).toList(),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () => context.push('/chat'),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: const LinearGradient(colors: [Color(0xFF00D68F), Color(0xFF00B87A)]),
                                    boxShadow: [BoxShadow(color: AppColors.accentGlow, blurRadius: 16)],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.auto_awesome_rounded, color: Colors.black, size: 18),
                                      SizedBox(width: 8),
                                      Text('اسأل الذكاء الاصطناعي عن هذا المسار', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.04, end: 0),

                        const SizedBox(height: 20),

                        // ── Alternatives ──
                        Text('مسارات بديلة', style: TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8))
                            .animate(delay: 100.ms).fadeIn(),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 130,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: alts.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, i) => _AltCard(career: alts[i], isDark: isDark)
                                .animate(delay: Duration(milliseconds: 150 + i * 80))
                                .fadeIn(duration: 300.ms)
                                .slideX(begin: 0.05, end: 0),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Timeline ──
                        Text('مسار زمني لمسيرتك', style: TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8))
                            .animate(delay: 200.ms).fadeIn(),
                        const SizedBox(height: 14),
                        _glassCard(
                          isDark: isDark,
                          child: Column(
                            children: [
                              _TimelineStep(isDark: isDark, icon: '🎓', label: 'الآن', desc: '$major · ${year ?? 'L1'}', isFirst: true),
                              _TimelineStep(isDark: isDark, icon: '📚', label: 'السنة 3', desc: 'تقوية المهارات التقنية وتربص صيفي'),
                              _TimelineStep(isDark: isDark, icon: '💡', label: 'ماستر', desc: 'تخصص متعمق في ${topCareer.title}'),
                              _TimelineStep(isDark: isDark, icon: '🚀', label: 'سوق العمل', desc: 'انطلاق المسيرة المهنية', isLast: true),
                            ],
                          ),
                        ).animate(delay: 280.ms).fadeIn(duration: 350.ms),
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

Widget _glassCard({required bool isDark, required Widget child}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.glassFill : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
        ),
        child: child,
      ),
    ),
  );
}

class _Career {
  final String title, icon, reason;
  final int match;
  final List<String> skills;
  const _Career(this.title, this.icon, this.match, this.skills, this.reason);
}

class _AltCard extends StatelessWidget {
  final _Career career;
  final bool isDark;
  const _AltCard({required this.career, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassFill : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(career.icon, style: const TextStyle(fontSize: 26)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(career.title, style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 30, height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(60),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: career.match / 100,
                          child: Container(
                            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('${career.match}%', style: TextStyle(color: textSecondary, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String icon, label, desc;
  final bool isDark, isFirst, isLast;
  const _TimelineStep({required this.isDark, required this.icon, required this.label, required this.desc, this.isFirst = false, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    final lineColor = isDark ? AppColors.glassBorder : Colors.black.withAlpha(20);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: isFirst ? AppColors.accent.withAlpha(30) : (isDark ? AppColors.glassFill : Colors.grey.withAlpha(30)),
                  shape: BoxShape.circle,
                  border: Border.all(color: isFirst ? AppColors.accent : lineColor),
                ),
                child: Center(child: Text(icon, style: const TextStyle(fontSize: 14))),
              ),
              if (!isLast)
                Expanded(child: Container(width: 1.5, color: lineColor, margin: const EdgeInsets.symmetric(vertical: 4))),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(label, style: TextStyle(color: isFirst ? AppColors.accent : textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(desc, style: TextStyle(color: textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
