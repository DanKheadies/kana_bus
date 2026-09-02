import 'package:flutter/material.dart';

class CustomRadio extends StatelessWidget {
  final bool condition;
  final bool? isDisabled;
  final double? padding;

  const CustomRadio({
    super.key,
    required this.condition,
    this.isDisabled = false,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding!),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDisabled!
            ? Theme.of(context).colorScheme.surface.withAlpha(155)
            : Theme.of(context).primaryColor.withAlpha(200),
      ),
      child: condition
          ? Icon(Icons.circle, color: Theme.of(context).scaffoldBackgroundColor)
          : Icon(Icons.check, color: Theme.of(context).scaffoldBackgroundColor),
    );
  }
}
