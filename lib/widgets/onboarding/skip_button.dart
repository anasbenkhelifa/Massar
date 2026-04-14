import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onSkip;
  final String label;

  const SkipButton({
    super.key,
    required this.onSkip,
    this.label = 'Skip',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSkip,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
