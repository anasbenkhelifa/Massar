import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep; // 1-based

  const OnboardingProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final filled = i < currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: filled ? AppColors.accent : AppColors.glassBorder,
              boxShadow: filled
                  ? [
                      BoxShadow(
                        color: AppColors.accentGlow,
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
