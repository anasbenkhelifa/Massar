import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class GlassSliderField extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String Function(double) valueLabel;
  final void Function(double) onChanged;

  const GlassSliderField({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.valueLabel,
    required this.onChanged,
    this.divisions = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent.withOpacity(0.4)),
              ),
              child: Text(
                valueLabel(value),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.glassBorder,
            thumbColor: AppColors.accent,
            overlayColor: AppColors.accentGlow,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            trackHeight: 4,
            valueIndicatorColor: AppColors.accent,
            valueIndicatorTextStyle: const TextStyle(color: Colors.black, fontSize: 12),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions > 0 ? divisions : null,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// 3-position discrete slider for low/medium/high
class SalaryPrioritySlider extends StatelessWidget {
  final String? value; // 'low' | 'medium' | 'high'
  final void Function(String) onChanged;
  final String lowLabel;
  final String medLabel;
  final String highLabel;

  const SalaryPrioritySlider({
    super.key,
    this.value,
    required this.onChanged,
    this.lowLabel = 'Not Priority',
    this.medLabel = 'Balanced',
    this.highLabel = 'Top Priority',
  });

  static const _positions = ['low', 'medium', 'high'];

  int get _index => value == null ? 1 : _positions.indexOf(value!);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.glassBorder,
            thumbColor: AppColors.accent,
            overlayColor: AppColors.accentGlow,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            trackHeight: 4,
          ),
          child: Slider(
            value: _index.toDouble(),
            min: 0,
            max: 2,
            divisions: 2,
            onChanged: (v) => onChanged(_positions[v.round()]),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [lowLabel, medLabel, highLabel].asMap().entries.map((e) {
            final isActive = e.key == _index;
            return Text(
              e.value,
              style: TextStyle(
                color: isActive ? AppColors.accent : AppColors.textHint,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
