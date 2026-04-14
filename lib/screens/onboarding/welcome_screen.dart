import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background1, AppColors.background2],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),

                _LogoMark()
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scaleXY(begin: 0.8, end: 1, duration: 600.ms, curve: Curves.easeOutBack),

                const SizedBox(height: 40),

                Column(
                  children: [
                    Text(
                      'مسار+',
                      style: AppTextStyles.displayAr.copyWith(
                        fontSize: 48,
                        color: AppColors.accent,
                        letterSpacing: 2,
                        shadows: [Shadow(color: AppColors.accentGlow, blurRadius: 24)],
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOut),

                    const SizedBox(height: 12),

                    Text(
                      'المرشد المهني بالذكاء الاصطناعي',
                      style: AppTextStyles.title.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    )
                        .animate(delay: 350.ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOut),

                    const SizedBox(height: 16),

                    Text(
                      'مسارك المهني يبدأ هنا',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, height: 1.6),
                      textAlign: TextAlign.center,
                    )
                        .animate(delay: 450.ms)
                        .fadeIn(duration: 500.ms),
                  ],
                ),

                const Spacer(flex: 3),

                _GetStartedButton(
                  label: 'ابدأ الآن',
                  onTap: () => context.go('/onboarding/language'),
                )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.5, end: 0, duration: 500.ms, curve: Curves.easeOut),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () => context.go('/home'),
                  child: const Text(
                    'تخطى الآن',
                    style: TextStyle(color: AppColors.textHint, fontSize: 14),
                  ),
                )
                    .animate(delay: 750.ms)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 110, height: 110,
          decoration: BoxDecoration(
            color: AppColors.accent.withAlpha(26),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.accent.withAlpha(77), width: 1.5),
            boxShadow: [BoxShadow(color: AppColors.accentGlow, blurRadius: 30, spreadRadius: 4)],
          ),
          child: const Center(child: Text('🎓', style: TextStyle(fontSize: 52))),
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GetStartedButton({required this.label, required this.onTap});

  @override
  State<_GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<_GetStartedButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.elasticOut,
        child: Container(
          width: double.infinity, height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(colors: [Color(0xFF00D68F), Color(0xFF00B87A)]),
            boxShadow: [BoxShadow(color: AppColors.accentGlow, blurRadius: 24, spreadRadius: 2)],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}
