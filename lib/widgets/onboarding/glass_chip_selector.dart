import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class ChipOption {
  final String id;
  final String label;
  final String? icon;

  const ChipOption({required this.id, required this.label, this.icon});
}

class GlassChipSelector extends StatelessWidget {
  final String? label;
  final List<ChipOption> options;
  final List<String> selected;
  final void Function(String id, bool isSelected) onToggle;
  final int? maxSelections;
  final List<String> disabledIds;
  final bool wrap; // false = horizontal scroll

  const GlassChipSelector({
    super.key,
    this.label,
    required this.options,
    required this.selected,
    required this.onToggle,
    this.maxSelections,
    this.disabledIds = const [],
    this.wrap = true,
  });

  @override
  Widget build(BuildContext context) {
    final chipWidgets = options.map((opt) {
      final isSelected = selected.contains(opt.id);
      final isDisabled = disabledIds.contains(opt.id);
      return _Chip(
        option: opt,
        isSelected: isSelected,
        isDisabled: isDisabled,
        onTap: isDisabled
            ? null
            : () {
                if (isSelected) {
                  onToggle(opt.id, false);
                } else if (maxSelections == null || selected.length < maxSelections!) {
                  onToggle(opt.id, true);
                }
              },
      );
    }).toList();

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
        if (wrap)
          Wrap(spacing: 8, runSpacing: 8, children: chipWidgets)
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chipWidgets
                  .map((c) => Padding(padding: const EdgeInsets.only(right: 8), child: c))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final ChipOption option;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _Chip({
    required this.option,
    required this.isSelected,
    required this.isDisabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withOpacity(0.15) : AppColors.glassFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.glassBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 10, spreadRadius: 0)]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              Text(option.icon!, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
            ],
            Text(
              option.label,
              style: TextStyle(
                color: isDisabled
                    ? AppColors.textHint
                    : isSelected
                        ? AppColors.accent
                        : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ).animate(target: isSelected ? 1 : 0).scaleXY(begin: 1, end: 0.97, duration: 100.ms);
  }
}
