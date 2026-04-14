import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class GlassDropdown<T> extends StatefulWidget {
  final String label;
  final String placeholder;
  final List<DropdownItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;
  final bool searchable;
  final bool optional;

  const GlassDropdown({
    super.key,
    required this.label,
    required this.placeholder,
    required this.items,
    required this.onChanged,
    this.value,
    this.searchable = false,
    this.optional = false,
  });

  @override
  State<GlassDropdown<T>> createState() => _GlassDropdownState<T>();
}

class _GlassDropdownState<T> extends State<GlassDropdown<T>> {
  void _openSheet() {
    // Hard-dismiss the keyboard before opening the sheet so it doesn't
    // re-appear when the modal closes and Flutter tries to restore focus.
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DropdownSheet<T>(
        items: widget.items,
        value: widget.value,
        onChanged: (v) {
          widget.onChanged(v);
          Navigator.pop(context);
        },
        searchable: widget.searchable,
      ),
    ).then((_) {
      // Also unfocus after the sheet closes in case focus was restored.
      FocusScope.of(context).unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.items.where((i) => i.value == widget.value).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.optional) ...[
              const SizedBox(width: 6),
              const Text('(optional)', style: TextStyle(color: AppColors.textHint, fontSize: 11)),
            ],
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _openSheet,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.glassFill,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected != null ? AppColors.accent : AppColors.glassBorder,
                    width: selected != null ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected?.label ?? widget.placeholder,
                        style: TextStyle(
                          color: selected != null ? AppColors.textPrimary : AppColors.textHint,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownSheet<T> extends StatefulWidget {
  final List<DropdownItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;
  final bool searchable;

  const _DropdownSheet({
    required this.items,
    required this.onChanged,
    this.value,
    this.searchable = false,
  });

  @override
  State<_DropdownSheet<T>> createState() => _DropdownSheetState<T>();
}

class _DropdownSheetState<T> extends State<_DropdownSheet<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.items
        : widget.items.where((i) => i.label.toLowerCase().contains(_query.toLowerCase())).toList();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: const BoxDecoration(
            color: Color(0xE60D1425),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: AppColors.glassBorder),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              if (widget.searchable)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textHint, size: 18),
                      filled: true,
                      fillColor: AppColors.glassFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.glassBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.glassBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    autofocus: false,
                  ),
                ),
              if (widget.searchable) const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final item = filtered[i];
                    final isSelected = item.value == widget.value;
                    return ListTile(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        widget.onChanged(item.value);
                      },
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? AppColors.accent : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded, color: AppColors.accent, size: 18)
                          : null,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownItem<T> {
  final T value;
  final String label;

  const DropdownItem({required this.value, required this.label});
}
