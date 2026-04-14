import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../providers/onboarding_provider.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  const ProcessingScreen({super.key});

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  late List<_Task> _tasks;
  bool _tasksInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_tasksInitialized) {
      final l = AppLocalizations.of(context);
      _tasks = [
        _Task(emoji: '🎓', label: l.processingMajors),
        _Task(emoji: '🗺️', label: l.processingTravel),
        _Task(emoji: '💼', label: l.processingInternships),
        _Task(emoji: '📚', label: l.processingResources),
        _Task(emoji: '📅', label: l.processingPlan),
      ];
      _tasksInitialized = true;
      _startProcessing();
    }
  }

  Future<void> _startProcessing() async {
    // TODO: POST /api/ai/process with full profile payload (ref.read(onboardingProvider).toJson())
    // TODO: poll GET /api/ai/result/{job_id} every 2-3s until complete
    for (var i = 0; i < _tasks.length; i++) {
      await Future.delayed(Duration(milliseconds: 600 + i * 150));
      if (mounted) setState(() => _tasks[i].isComplete = true);
    }
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      await ref.read(onboardingProvider.notifier).markOnboardingComplete();
      if (mounted) context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background1, AppColors.background2],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100, right: -80,
              child: Container(
                width: 300, height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [AppColors.accent.withAlpha(31), Colors.transparent]),
                ),
              ),
            ),
            Positioned(
              bottom: -120, left: -60,
              child: Container(
                width: 260, height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [AppColors.secondary.withAlpha(26), Colors.transparent]),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    _PulsingIcon()
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .scaleXY(begin: 0.7, end: 1, duration: 500.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 28),
                    Text(l.processingTitle, style: AppTextStyles.headline, textAlign: TextAlign.center)
                        .animate(delay: 200.ms).fadeIn(duration: 400.ms),
                    const SizedBox(height: 8),
                    Text(l.processingSubtitle, style: AppTextStyles.caption, textAlign: TextAlign.center)
                        .animate(delay: 300.ms).fadeIn(duration: 400.ms),
                    const Spacer(flex: 1),
                    if (_tasksInitialized)
                      ..._tasks.asMap().entries.map((e) {
                        final i = e.key;
                        final task = e.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _TaskCard(task: task)
                              .animate(delay: Duration(milliseconds: 400 + i * 100))
                              .fadeIn(duration: 400.ms)
                              .slideX(begin: -0.08, end: 0, duration: 400.ms, curve: Curves.easeOut),
                        );
                      }),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Task {
  final String emoji;
  final String label;
  bool isComplete = false;
  _Task({required this.emoji, required this.label});
}

class _TaskCard extends StatelessWidget {
  final _Task task;
  const _TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: task.isComplete ? AppColors.accent.withAlpha(20) : AppColors.glassFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: task.isComplete ? AppColors.accent.withAlpha(100) : AppColors.glassBorder,
              width: task.isComplete ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(task.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.label,
                  style: TextStyle(
                    color: task.isComplete ? AppColors.accent : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: task.isComplete ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: task.isComplete
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 22, key: ValueKey('check'))
                    : const _ShimmerDot(key: ValueKey('loading')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerDot extends StatefulWidget {
  const _ShimmerDot({super.key});
  @override
  State<_ShimmerDot> createState() => _ShimmerDotState();
}

class _ShimmerDotState extends State<_ShimmerDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        width: 10, height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.textHint.withAlpha((77 + (_ctrl.value * 128)).round()),
        ),
      ),
    );
  }
}

class _PulsingIcon extends StatefulWidget {
  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        width: 90, height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withAlpha((20 + (_ctrl.value * 15)).round()),
          boxShadow: [BoxShadow(color: AppColors.accent.withAlpha((38 + (_ctrl.value * 51)).round()), blurRadius: 30 + _ctrl.value * 20, spreadRadius: 4)],
          border: Border.all(color: AppColors.accent.withAlpha((77 + (_ctrl.value * 51)).round()), width: 1.5),
        ),
        child: const Center(child: Text('🤖', style: TextStyle(fontSize: 42))),
      ),
    );
  }
}
