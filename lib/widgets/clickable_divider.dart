import 'package:flutter/material.dart';

class ClickableDivider extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String text;

  const ClickableDivider({
    super.key,
    required this.icon,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap(),
        child: SizedBox(
          width: double.infinity,
          height: 30,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Divider(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 5),
              Icon(icon, color: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
