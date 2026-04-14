import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/locale_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    const languages = [
      _LangOption(code: 'ar', label: 'العربية', nativeLabel: 'Arabic', flag: '🇩🇿'),
      _LangOption(code: 'fr', label: 'Français', nativeLabel: 'French', flag: '🇫🇷'),
      _LangOption(code: 'en', label: 'English', nativeLabel: 'English', flag: '🇬🇧'),
    ];

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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 48),

                // ── Header ──────────────────────────────
                Column(
                  children: [
                    Text(
                      '🌐',
                      style: const TextStyle(fontSize: 48),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .scaleXY(begin: 0.7, end: 1, duration: 400.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 20),
                    Text(
                      'Choose your language',
                      style: AppTextStyles.headline,
                      textAlign: TextAlign.center,
                    )
                        .animate(delay: 100.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, duration: 400.ms),
                    const SizedBox(height: 8),
                    Text(
                      'اختر لغتك  •  Choisissez votre langue',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    )
                        .animate(delay: 180.ms)
                        .fadeIn(duration: 400.ms),
                  ],
                ),

                const SizedBox(height: 48),

                // ── Language cards ───────────────────────
                ...languages.asMap().entries.map((e) {
                  final i = e.key;
                  final lang = e.value;
                  final isSelected = state.language == lang.code;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LangCard(
                      option: lang,
                      isSelected: isSelected,
                      onTap: () {
                        notifier.setLanguage(lang.code);
                        ref.read(localeProvider.notifier).setLocale(lang.code);
                      },
                    )
                        .animate(delay: Duration(milliseconds: 250 + i * 80))
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -0.1, end: 0, duration: 400.ms, curve: Curves.easeOut),
                  );
                }),

                const Spacer(),

                // ── Continue button ───────────────────────
                _ContinueButton(
                  enabled: state.language != null,
                  onTap: state.language != null
                      ? () => context.go('/onboarding/step1')
                      : null,
                )
                    .animate(delay: 550.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.4, end: 0, duration: 400.ms, curve: Curves.easeOut),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangOption {
  final String code;
  final String label;
  final String nativeLabel;
  final String flag;

  const _LangOption({
    required this.code,
    required this.label,
    required this.nativeLabel,
    required this.flag,
  });
}

class _LangCard extends StatefulWidget {
  final _LangOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangCard({required this.option, required this.isSelected, required this.onTap});

  @override
  State<_LangCard> createState() => _LangCardState();
}

class _LangCardState extends State<_LangCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.elasticOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppColors.accent.withAlpha(31)
                    : AppColors.glassFill,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected ? AppColors.accent : AppColors.glassBorder,
                  width: widget.isSelected ? 1.5 : 1,
                ),
                boxShadow: widget.isSelected
                    ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 16, spreadRadius: 0)]
                    : null,
              ),
              child: Row(
                children: [
                  Text(widget.option.flag, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.option.label,
                          style: TextStyle(
                            color: widget.isSelected ? AppColors.accent : AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.option.nativeLabel,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      key: ValueKey(widget.isSelected),
                      color: widget.isSelected ? AppColors.accent : AppColors.textHint,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback? onTap;

  const _ContinueButton({required this.enabled, this.onTap});

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed && widget.enabled ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.elasticOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: widget.enabled
                ? const LinearGradient(colors: [Color(0xFF00D68F), Color(0xFF00B87A)])
                : null,
            color: widget.enabled ? null : AppColors.glassBorder,
            boxShadow: widget.enabled
                ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 20, spreadRadius: 2)]
                : null,
          ),
          child: Center(
            child: Text(
              'Continue',
              style: TextStyle(
                color: widget.enabled ? Colors.black : AppColors.textHint,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
