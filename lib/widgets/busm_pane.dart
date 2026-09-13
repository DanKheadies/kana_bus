import 'package:flutter/material.dart';

class BusmPane extends StatelessWidget {
  final bool? autocorrect;
  final bool? isDisabled;
  final Color? textColor;
  final FocusNode? focusInput;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String label;
  final TextCapitalization? textCapitalization;
  final TextEditingController controller;
  final Widget? labelWidget;

  const BusmPane({
    super.key,
    required this.label,
    required this.controller,
    this.autocorrect = true,
    this.focusInput,
    this.isDisabled = false,
    this.labelWidget,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
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
      onTapOutside: (_) {
        focusInput?.unfocus();
        if (onSubmitted != null) {
          // print('not null');
          onSubmitted!('');
        }
      },
      focusNode: focusInput,
      readOnly: isDisabled!,
      enabled: !isDisabled!,
      autocorrect: autocorrect,
      textCapitalization: textCapitalization!,
      decoration: InputDecoration(
        label: labelWidget,
        labelText: labelWidget != null ? null : label,
      ), // labelText: label),
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: textColor ?? Theme.of(context).colorScheme.surfaceBright,
      ),
    );
  }
}
