import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class RadioOption {
  final String id;
  final String label;
  final String? description;
  final String? icon;

  const RadioOption({
    required this.id,
    required this.label,
    this.description,
    this.icon,
  });
}

/// Vertical list of glass radio cards (single-select)
class GlassRadioCards extends StatelessWidget {
  final String? label;
  final List<RadioOption> options;
  final String? selected;
  final void Function(String) onSelect;

  const GlassRadioCards({
    super.key,
    this.label,
    required this.options,
    required this.onSelect,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
        ],
        ...options.asMap().entries.map((e) {
          final i = e.key;
          final opt = e.value;
          final isSelected = opt.id == selected;
          return Padding(
            padding: EdgeInsets.only(bottom: i < options.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onSelect(opt.id),
              child: AnimatedContainer(
                duration: 200.ms,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent.withOpacity(0.1) : AppColors.glassFill,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.glassBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 12)]
                      : null,
                ),
                child: Row(
                  children: [
                    if (opt.icon != null) ...[
                      Text(opt.icon!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opt.label,
                            style: TextStyle(
                              color: isSelected ? AppColors.accent : AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                          if (opt.description != null) ...[
                            const SizedBox(height: 3),
                            Text(
                              opt.description!,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: 200.ms,
                      child: Icon(
                        isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                        key: ValueKey(isSelected),
                        color: isSelected ? AppColors.accent : AppColors.textHint,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
