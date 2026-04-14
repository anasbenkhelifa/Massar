import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

/// A tappable glass card that acts as a toggle (true/false)
class GlassToggleCard extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final void Function(bool) onChanged;
  final Widget? leading;

  const GlassToggleCard({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: value ? AppColors.accent.withOpacity(0.1) : AppColors.glassFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value ? AppColors.accent : AppColors.glassBorder,
            width: value ? 1.5 : 1,
          ),
          boxShadow: value
              ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 12, spreadRadius: 0)]
              : null,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: value ? AppColors.accent : AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: 200.ms,
              child: Icon(
                value ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                key: ValueKey(value),
                color: value ? AppColors.accent : AppColors.textHint,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    ).animate().scaleXY(
          begin: 1,
          end: 0.97,
          duration: 100.ms,
        );
  }
}

/// A glass Switch row (not a card — just label + switch)
class GlassSwitchRow extends StatelessWidget {
  final String label;
  final String? microcopy;
  final bool value;
  final void Function(bool) onChanged;

  const GlassSwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.microcopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.accent,
              activeTrackColor: AppColors.accentGlow,
              inactiveThumbColor: AppColors.textHint,
              inactiveTrackColor: AppColors.glassBorder,
            ),
          ],
        ),
        if (microcopy != null && !value) ...[
          const SizedBox(height: 4),
          Text(microcopy!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ],
    );
  }
}

/// Horizontal row of 3 gender-style toggle cards
class GlassToggleGroup extends StatelessWidget {
  final List<ToggleOption> options;
  final String? selected;
  final void Function(String) onSelect;

  const GlassToggleGroup({
    super.key,
    required this.options,
    required this.onSelect,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.asMap().entries.map((e) {
        final i = e.key;
        final opt = e.value;
        final isSelected = opt.id == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < options.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onSelect(opt.id),
              child: AnimatedContainer(
                duration: 200.ms,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent.withOpacity(0.12) : AppColors.glassFill,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.glassBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 10)]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(opt.icon, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 6),
                    Text(
                      opt.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? AppColors.accent : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ToggleOption {
  final String id;
  final String label;
  final String icon;

  const ToggleOption({required this.id, required this.label, required this.icon});
}
