import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class GuideScreen extends ConsumerStatefulWidget {
  final bool standalone;
  const GuideScreen({super.key, this.standalone = true});

  @override
  ConsumerState<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends ConsumerState<GuideScreen> {
  String _category = 'skills';
  String _query = '';

  static const _categories = [
    ('skills', 'مهارات'),
    ('majors', 'تخصصات'),
    ('jobs', 'توظيف'),
    ('tools', 'أدوات'),
  ];

  static const _resources = [
    _Resource('💻', 'تعلم Python من الصفر', 'Coursera', '8 ساعات', 'skills', 'دورة شاملة لتعلم Python تشمل البيانات والمنح. مناسبة للمبتدئين والمتوسطين. تتوفر بشهادة مجانية عبر طلب مساعدة مالية.'),
    _Resource('🔗', 'Git & GitHub للمبتدئين', 'YouTube', '2 ساعات', 'tools', 'تعلم التحكم في الإصدار وإدارة المشاريع البرمجية باستخدام Git وGitHub بشكل احترافي.'),
    _Resource('📊', 'Excel للتحليل', 'Microsoft Learn', '4 ساعات', 'tools', 'دورة مجانية لإتقان Excel للاستخدام التحليلي والتقارير المهنية. تناسب طلاب الأعمال والعلوم.'),
    _Resource('🎓', 'دليل التخصصات الجزائرية', 'وزارة التعليم', '30 دقيقة', 'majors', 'دليل شامل ومحدث لكل التخصصات المتاحة في الجامعات الجزائرية مع خصائص كل مسار.'),
    _Resource('💼', 'LinkedIn للطلاب', 'LinkedIn Learning', '1 ساعة', 'jobs', 'كيف تبني حضوراً مهنياً على LinkedIn كطالب وتجذب الشركات والتربصات.'),
    _Resource('🗣️', 'تحسين اللغة الإنجليزية', 'Duolingo / BBC', '3 ساعات', 'skills', 'برنامج يومي لتحسين لغتك الإنجليزية مع تركيز على اللغة التقنية والمهنية.'),
    _Resource('🏛️', 'اختيار التخصص الصح', 'مسار+', '15 دقيقة', 'majors', 'مقال شامل يساعدك على اختيار تخصصك الجامعي بناءً على ميولاتك وسوق العمل الجزائري.'),
    _Resource('📄', 'كتابة CV احترافي', 'Canva / Novoresume', '1 ساعة', 'jobs', 'تعلم كتابة CV مؤثر خطوة بخطوة، مع قوالب مجانية مثالية للتقدم للتربصات والوظائف.'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final bg2 = isDark ? AppColors.background2 : const Color(0xFFE8EEF8);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    final filtered = _resources.where((r) =>
      r.category == _category &&
      (_query.isEmpty || r.title.contains(_query) || r.source.contains(_query))
    ).toList();

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
                      if (widget.standalone) ...[
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
                      Text(l.homeNavGuide, style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.glassFill : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded, color: textSecondary, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                onChanged: (v) => setState(() => _query = v),
                                style: TextStyle(color: textPrimary, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'ابحث عن مورد...',
                                  hintStyle: TextStyle(color: textSecondary, fontSize: 14),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 14),

                // Category tabs
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: _categories.map((c) {
                      final isActive = c.$1 == _category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _category = c.$1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.accent.withAlpha(30) : (isDark ? AppColors.glassFill : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isActive ? AppColors.accent : (isDark ? AppColors.glassBorder : Colors.black.withAlpha(18))),
                            ),
                            child: Text(c.$2,
                              style: TextStyle(
                                color: isActive ? AppColors.accent : textSecondary,
                                fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                              )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ).animate(delay: 80.ms).fadeIn(duration: 300.ms),
                const SizedBox(height: 16),

                // Resource list
                Expanded(
                  child: filtered.isEmpty
                    ? Center(child: Text('لا توجد نتائج', style: TextStyle(color: textSecondary, fontSize: 14)))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _ResourceCard(
                          resource: filtered[i], isDark: isDark,
                          onTap: () => _showDetail(context, filtered[i], isDark),
                        ).animate(delay: Duration(milliseconds: 80 + i * 70)).fadeIn(duration: 280.ms).slideY(begin: 0.03, end: 0),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, _Resource r, bool isDark) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xED0D1425) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(15))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18), borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(r.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.title, style: TextStyle(color: textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${r.source} · ${r.duration}', style: TextStyle(color: textSecondary, fontSize: 12)),
                    ])),
                  ],
                ),
                const SizedBox(height: 16),
                Text(r.description, style: TextStyle(color: textSecondary, fontSize: 14, height: 1.6)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('حفظ في القائمة', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Resource {
  final String emoji, title, source, duration, category, description;
  const _Resource(this.emoji, this.title, this.source, this.duration, this.category, this.description);
}

class _ResourceCard extends StatelessWidget {
  final _Resource resource;
  final bool isDark;
  final VoidCallback onTap;
  const _ResourceCard({required this.resource, required this.isDark, required this.onTap});

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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.glassFill : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.accent.withAlpha(40)),
                  ),
                  child: Center(child: Text(resource.emoji, style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(resource.title, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Row(children: [
                        Text(resource.source, style: TextStyle(color: textSecondary, fontSize: 12)),
                        Text(' · ', style: TextStyle(color: textSecondary, fontSize: 12)),
                        Text(resource.duration, style: const TextStyle(color: AppColors.accent, fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
