import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';
import 'chat_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  late PageController _pageController;
  late AnimationController _fabPulse;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabPulse.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final bg2 = isDark ? AppColors.background2 : const Color(0xFFE8EEF8);

    return Scaffold(
      backgroundColor: bg1,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bg1, bg2],
              ),
            ),
          ),

          // Ambient glows (dark mode only)
          if (isDark) ...[
            Positioned(
              top: -80, right: -60,
              child: Container(
                width: 280, height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.accent.withAlpha(20), Colors.transparent,
                  ]),
                ),
              ),
            ),
            Positioned(
              bottom: 100, left: -80,
              child: Container(
                width: 240, height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.secondary.withAlpha(18), Colors.transparent,
                  ]),
                ),
              ),
            ),
          ],

          // PageView — seamless swipe between tabs
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => setState(() => _navIndex = i),
            children: const [
              _HomeDashboard(),
              ChatScreen(standalone: false),
              MapScreen(standalone: false),
              ProfileScreen(standalone: false),
            ],
          ),

          // Bottom nav
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _BottomNav(
              index: _navIndex,
              onTap: _onNavTap,
              l: l,
              isDark: isDark,
            ).animate(delay: 500.ms).fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0),
          ),

          // FAB — only on home tab
          if (_navIndex == 0)
            Positioned(
              right: 20,
              bottom: 90,
              child: _ChatFab(
                pulseCtrl: _fabPulse,
                onTap: () => _onNavTap(1),
              )
                .animate(delay: 600.ms)
                .fadeIn(duration: 400.ms)
                .scaleXY(begin: 0.6, end: 1, duration: 400.ms, curve: Curves.easeOutBack),
            ),
        ],
      ),
    );
  }
}

// ─── Home Dashboard Page ─────────────────────────────────────────────────────

class _HomeDashboard extends ConsumerWidget {
  const _HomeDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final profile = ref.watch(onboardingProvider);
    final firstName = (profile.fullName ?? '').split(' ').first;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GreetingRow(name: firstName, l: l, isDark: isDark)
                      .animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),
                  const SizedBox(height: 24),
                  _StatsRow(l: l, isDark: isDark)
                      .animate(delay: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0),
                  const SizedBox(height: 28),
                  _QuickActions(l: l, isDark: isDark)
                      .animate(delay: 180.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 28),
                  Text(
                    l.homeServices,
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ).animate(delay: 220.ms).fadeIn(duration: 300.ms),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ..._serviceCards(l).asMap().entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ServiceCard(
                      data: e.value,
                      isDark: isDark,
                      onTap: () => context.push(e.value.route),
                    )
                      .animate(delay: Duration(milliseconds: 260 + e.key * 70))
                      .fadeIn(duration: 350.ms)
                      .slideX(begin: -0.04, end: 0, duration: 350.ms, curve: Curves.easeOut),
                  );
                }),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<_ServiceData> _serviceCards(AppLocalizations l) => [
    _ServiceData(icon: Icons.explore_rounded,      color: AppColors.accent,    title: l.homeServiceCareer,     description: l.homeServiceCareerDesc,     route: '/career-path'),
    _ServiceData(icon: Icons.grid_view_rounded,    color: AppColors.secondary, title: l.homeServiceMatrix,     description: l.homeServiceMatrixDesc,     route: '/subject-matrix'),
    _ServiceData(icon: Icons.bar_chart_rounded,    color: AppColors.accent,    title: l.homeServiceSkills,     description: l.homeServiceSkillsDesc,     route: '/skills-gap'),
    _ServiceData(icon: Icons.work_rounded,         color: AppColors.secondary, title: l.homeServiceInternship, description: l.homeServiceInternshipDesc,  route: '/internship'),
    _ServiceData(icon: Icons.calendar_month_rounded, color: AppColors.accent,  title: l.homeServicePlan,       description: l.homeServicePlanDesc,       route: '/study-plan'),
  ];
}

// ─── Greeting Row ────────────────────────────────────────────────────────────

class _GreetingRow extends StatelessWidget {
  final String name;
  final AppLocalizations l;
  final bool isDark;
  const _GreetingRow({required this.name, required this.l, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final displayName = name.isEmpty ? '...' : name;
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.homeGreeting(displayName),
                style: AppTextStyles.headline.copyWith(fontSize: 22, color: textPrimary),
              ),
              const SizedBox(height: 4),
              Text('مسار+', style: AppTextStyles.displayAr.copyWith(fontSize: 15, color: AppColors.accent, letterSpacing: 1)),
            ],
          ),
        ),
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent.withAlpha(31),
            border: Border.all(color: AppColors.accent.withAlpha(77), width: 1.5),
          ),
          child: const Center(child: Text('🎓', style: TextStyle(fontSize: 22))),
        ),
      ],
    );
  }
}

// ─── Stats Row ───────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final AppLocalizations l;
  final bool isDark;
  const _StatsRow({required this.l, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(label: l.homeCareerMatch,  value: '78%',  color: AppColors.accent,    isDark: isDark),
        const SizedBox(width: 10),
        _StatCard(label: l.homeSkillsFilled, value: '4/12', color: AppColors.secondary, isDark: isDark),
        const SizedBox(width: 10),
        _StatCard(label: l.homePlanProgress, value: '23%',  color: AppColors.accent,    isDark: isDark),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  final bool isDark;
  const _StatCard({required this.label, required this.value, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.glassFill : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
            ),
            child: Column(
              children: [
                Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(label, textAlign: TextAlign.center, style: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Quick Actions ───────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final AppLocalizations l;
  final bool isDark;
  const _QuickActions({required this.l, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final chips = [
      (label: l.homeAskAi,           icon: Icons.auto_awesome_rounded, onTap: () => context.push('/chat')),
      (label: l.homeViewPlan,        icon: Icons.route_rounded,        onTap: () => context.push('/study-plan')),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: chips.asMap().entries.map((e) {
          return Padding(
            padding: EdgeInsets.only(right: e.key < chips.length - 1 ? 10 : 0),
            child: _QuickChip(label: e.value.label, icon: e.value.icon, onTap: e.value.onTap, isDark: isDark),
          );
        }).toList(),
      ),
    );
  }
}

class _QuickChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  const _QuickChip({required this.label, required this.icon, required this.onTap, required this.isDark});

  @override
  State<_QuickChip> createState() => _QuickChipState();
}

class _QuickChipState extends State<_QuickChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textSecondary = widget.isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.glassFill : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: widget.isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: AppColors.accent, size: 16),
                  const SizedBox(width: 7),
                  Text(widget.label, style: TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Service Card ────────────────────────────────────────────────────────────

class _ServiceData {
  final IconData icon;
  final Color color;
  final String title, description, route;
  const _ServiceData({required this.icon, required this.color, required this.title, required this.description, required this.route});
}

class _ServiceCard extends StatefulWidget {
  final _ServiceData data;
  final VoidCallback onTap;
  final bool isDark;
  const _ServiceCard({super.key, required this.data, required this.onTap, required this.isDark});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textPrimary = widget.isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = widget.isDark ? AppColors.textSecondary : const Color(0xFF64748B);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.glassFill : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: widget.isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: widget.data.color.withAlpha(26),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: widget.data.color.withAlpha(60)),
                    ),
                    child: Icon(widget.data.icon, color: widget.data.color, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.data.title, style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 3),
                        Text(widget.data.description, style: TextStyle(color: textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: textSecondary, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int index;
  final void Function(int) onTap;
  final AppLocalizations l;
  final bool isDark;
  const _BottomNav({required this.index, required this.onTap, required this.l, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      (icon: Icons.home_rounded,        label: l.homeNavHome),
      (icon: Icons.chat_bubble_rounded, label: l.homeNavChat),
      (icon: Icons.map_rounded,         label: l.homeNavGuide),
      (icon: Icons.person_rounded,      label: l.homeNavProfile),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.glassFill : Colors.white.withAlpha(220),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18), width: 1.2),
              boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 20, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((e) {
                final isActive = e.key == index;
                final activeColor = AppColors.accent;
                final inactiveColor = isDark ? AppColors.textHint : const Color(0xFFB0B8C8);
                return GestureDetector(
                  onTap: () => onTap(e.key),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.accent.withAlpha(26) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(e.value.icon, color: isActive ? activeColor : inactiveColor, size: 22),
                        const SizedBox(height: 2),
                        Text(e.value.label, style: TextStyle(color: isActive ? activeColor : inactiveColor, fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Chat FAB ─────────────────────────────────────────────────────────────────

class _ChatFab extends StatelessWidget {
  final AnimationController pulseCtrl;
  final VoidCallback onTap;
  const _ChatFab({required this.pulseCtrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseCtrl,
        builder: (_, child) => Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 64 + pulseCtrl.value * 12,
              height: 64 + pulseCtrl.value * 12,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.accent.withAlpha((20 + pulseCtrl.value * 18).round())),
            ),
            child!,
          ],
        ),
        child: Container(
          width: 56, height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF00D68F), Color(0xFF00B87A)]),
            boxShadow: [BoxShadow(color: AppColors.accentGlow, blurRadius: 20, spreadRadius: 2)],
          ),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.black, size: 24),
        ),
      ),
    );
  }
}
