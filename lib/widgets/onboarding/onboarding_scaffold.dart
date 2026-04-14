import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import 'progress_bar.dart';
import 'skip_button.dart';

class OnboardingScaffold extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final VoidCallback? onContinue;
  final bool canContinue;
  final String continueLabel;
  final Widget body;
  final bool isLastStep;

  const OnboardingScaffold({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.body,
    this.onBack,
    this.onSkip,
    this.onContinue,
    this.canContinue = true,
    this.continueLabel = 'Continue',
    this.isLastStep = false,
  });

  @override
  Widget build(BuildContext context) {
    // Button height + its vertical padding (8 top + 32 bottom + 56 button)
    const double buttonAreaHeight = 96;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // No bottomNavigationBar — Scaffold always paints an opaque surface
        // behind it which causes the "black background" issue.
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // ── Background gradient ───────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.background1, AppColors.background2],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // ── Top bar ────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        children: [
                          if (onBack != null)
                            GestureDetector(
                              onTap: onBack,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.glassFill,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.glassBorder),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new_rounded,
                                    color: AppColors.textSecondary, size: 16),
                              ),
                            )
                          else
                            const SizedBox(width: 38),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OnboardingProgressBar(
                              totalSteps: totalSteps,
                              currentStep: currentStep,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (onSkip != null)
                            SkipButton(onSkip: onSkip!)
                          else
                            const SizedBox(width: 38),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Scrollable body ────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        // Extra bottom padding so content doesn't hide under button
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, buttonAreaHeight + 8),
                        physics: const BouncingScrollPhysics(),
                        child: body
                            .animate()
                            .fadeIn(duration: 200.ms)
                            .slideY(begin: 0.03, end: 0, duration: 200.ms, curve: Curves.easeOut),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Floating continue button (no background) ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _ContinueBar(
                label: continueLabel,
                enabled: canContinue,
                onTap: onContinue,
                isLast: isLastStep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueBar extends StatefulWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final bool isLast;

  const _ContinueBar({
    required this.label,
    required this.enabled,
    this.onTap,
    this.isLast = false,
  });

  @override
  State<_ContinueBar> createState() => _ContinueBarState();
}

class _ContinueBarState extends State<_ContinueBar> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          if (widget.enabled) widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed && widget.enabled ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.elasticOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: widget.enabled
                  ? const Color(0xFF00D68F)
                  : const Color(0xFF00D68F).withAlpha(89), // 0.35 opacity
              boxShadow: widget.enabled
                  ? [const BoxShadow(color: Color(0x4400D68F), blurRadius: 20)]
                  : [],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.enabled
                          ? Colors.black
                          : Colors.black.withAlpha(153),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (widget.enabled) ...[
                    const SizedBox(width: 8),
                    Icon(
                      widget.isLast
                          ? Icons.auto_awesome_rounded
                          : Icons.arrow_forward_rounded,
                      color: Colors.black,
                      size: 18,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 150.ms).slideY(
          begin: 0.4,
          end: 0,
          duration: 300.ms,
          delay: 150.ms,
          curve: Curves.easeOut,
        );
  }
}
