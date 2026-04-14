import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';

class InternshipScreen extends ConsumerStatefulWidget {
  const InternshipScreen({super.key});

  @override
  ConsumerState<InternshipScreen> createState() => _InternshipScreenState();
}

class _InternshipScreenState extends ConsumerState<InternshipScreen> {
  String? _selectedDomain;
  int? _expandedTip;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final profile = ref.watch(onboardingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final bg2 = isDark ? AppColors.background2 : const Color(0xFFE8EEF8);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    final domains = profile.interestDomains.isNotEmpty
        ? profile.interestDomains.take(4).toList()
        : ['technology', 'business', 'science'];

    _selectedDomain ??= domains.first;

    final domainLabel = {
      'technology': 'تكنولوجيا', 'business': 'أعمال', 'engineering': 'هندسة',
      'science': 'علوم', 'medicine': 'طب', 'law': 'قانون',
      'arts': 'فنون', 'education': 'تعليم',
    };

    final internships = _getInternships(_selectedDomain!, profile.homeWilayaCode);

    final tips = [
      _Tip('كيف تتقدم للتربص؟', 'ابحث في موقع ANEM أو LinkedIn. حضّر CV بالفرنسية، وكتابة تحفيزية مخصصة. تقدم 3 أشهر مسبقاً.'),
      _Tip('ما الذي تحضره؟', 'CV محدّث، كتابة تحفيزية، شهادات الدراسة، صورة احترافية، ووثيقة هوية.'),
      _Tip('أخطاء شائعة', 'التأخر في التقديم، CV عام غير مخصص، عدم المتابعة بعد الإرسال، أو إهمال التدريب المهني.'),
    ];

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
                      Text(l.homeServiceInternship, style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Domain filter
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: domains.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final d = domains[i];
                      final isActive = d == _selectedDomain;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDomain = d),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.accent.withAlpha(30) : (isDark ? AppColors.glassFill : Colors.white),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isActive ? AppColors.accent : (isDark ? AppColors.glassBorder : Colors.black.withAlpha(18))),
                          ),
                          child: Text(
                            domainLabel[d] ?? d,
                            style: TextStyle(
                              color: isActive ? AppColors.accent : textSecondary,
                              fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...internships.asMap().entries.map((e) =>
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _InternshipCard(internship: e.value, isDark: isDark)
                                .animate(delay: Duration(milliseconds: 100 + e.key * 80))
                                .fadeIn(duration: 300.ms)
                                .slideY(begin: 0.04, end: 0),
                          )
                        ),

                        const SizedBox(height: 8),
                        Text('نصائح مهنية', style: TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8))
                            .animate(delay: 300.ms).fadeIn(),
                        const SizedBox(height: 12),

                        ...tips.asMap().entries.map((e) =>
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _TipCard(
                              tip: e.value,
                              isExpanded: _expandedTip == e.key,
                              isDark: isDark,
                              onTap: () => setState(() => _expandedTip = _expandedTip == e.key ? null : e.key),
                            ).animate(delay: Duration(milliseconds: 360 + e.key * 70)).fadeIn(duration: 300.ms),
                          )
                        ),
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

  List<_Internship> _getInternships(String domain, int? wilayaCode) {
    final city = wilayaCode != null && wilayaCode <= 5 ? 'الجزائر العاصمة' : (wilayaCode != null && wilayaCode <= 15 ? 'وهران' : 'قسنطينة');
    return [
      _Internship('🏢', 'شركة ناشئة في $domain', city, '2 أشهر', 'مدفوع - 15,000 دج/شهر', ['CV', 'دافعية عالية']),
      _Internship('🏛️', 'إدارة حكومية', 'متاح في كل الولايات', '3 أشهر', 'غير مدفوع', ['طلب رسمي', 'شهادة التسجيل']),
      _Internship('🌐', 'شركة دولية - عن بعد', 'عن بعد', '1-3 أشهر', 'مدفوع - 300-500\$', ['إنجليزية', 'مهارات تقنية']),
    ];
  }
}

class _Internship {
  final String icon, title, location, duration, stipend;
  final List<String> requires;
  const _Internship(this.icon, this.title, this.location, this.duration, this.stipend, this.requires);
}

class _Tip {
  final String question, answer;
  const _Tip(this.question, this.answer);
}

class _InternshipCard extends StatelessWidget {
  final _Internship internship;
  final bool isDark;
  const _InternshipCard({required this.internship, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassFill : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(internship.icon, style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(internship.title, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Row(children: [
                          Icon(Icons.location_on_rounded, size: 12, color: textSecondary),
                          const SizedBox(width: 3),
                          Text(internship.location, style: TextStyle(color: textSecondary, fontSize: 12)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _InfoChip('⏱ ${internship.duration}', AppColors.secondary, isDark),
                  const SizedBox(width: 8),
                  _InfoChip(internship.stipend.contains('مدفوع') && !internship.stipend.contains('غير')
                    ? '💰 ${internship.stipend}' : '🔓 ${internship.stipend}',
                    internship.stipend.contains('غير') ? AppColors.textHint : AppColors.accent, isDark),
                ],
              ),
              const SizedBox(height: 12),
              Text('المتطلبات:', style: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6, runSpacing: 6,
                children: internship.requires.map((r) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accent.withAlpha(50)),
                  ),
                  child: Text(r, style: const TextStyle(color: AppColors.accent, fontSize: 11)),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;
  const _InfoChip(this.label, this.color, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

class _TipCard extends StatelessWidget {
  final _Tip tip;
  final bool isExpanded, isDark;
  final VoidCallback onTap;
  const _TipCard({required this.tip, required this.isExpanded, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.glassFill : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isExpanded ? AppColors.accent.withAlpha(80) : (isDark ? AppColors.glassBorder : Colors.black.withAlpha(18))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(tip.question, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w600))),
                Icon(isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: textSecondary, size: 20),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              Text(tip.answer, style: TextStyle(color: textSecondary, fontSize: 13, height: 1.6)),
            ],
          ],
        ),
      ),
    );
  }
}
