import 'package:flutter/material.dart';

class BusmPane extends StatelessWidget {
  final bool? isDisabled;
  final Color? textColor;
  final FocusNode? focusInput;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String label;
  final TextEditingController controller;

  const BusmPane({
    super.key,
    required this.label,
    required this.controller,
    this.focusInput,
    this.isDisabled = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onTap: onTap,
      onTapOutside: (_) => focusInput?.unfocus(),
      focusNode: focusInput,
      readOnly: isDisabled!,
      decoration: InputDecoration(labelText: label),
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: textColor ?? Theme.of(context).colorScheme.surfaceBright,
      ),
    );
  }
}
