import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kana_bus/barrel.dart';

class BusmRow extends StatelessWidget {
  final Busm busm;
  final Function(BuildContext) onDelete;
  final Function(BuildContext) onPhoto;
  final Function(BuildContext) onShare;
  final Function(BuildContext) toInput;
  final int busmListLength;
  final int index;

  const BusmRow({
    super.key,
    required this.busm,
    required this.busmListLength,
    required this.index,
    required this.onDelete,
    required this.onPhoto,
    required this.onShare,
    required this.toInput,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(busm.createdAt.toString()),
      closeOnScroll: true,
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        // dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            // flex: 2,
            flex: 1,
            onPressed: onDelete,
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).scaffoldBackgroundColor,
            icon: Icons.delete,
            label: 'Delete',
          ),
          // Flexible(flex: 1, child: const SizedBox()),
          SlidableAction(
            flex: 1,
            // Note: should share all 4 inputs (w/ labels); prob only 3, i.e.
            // no need to share the initial input
            onPressed: onShare,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).scaffoldBackgroundColor,
            icon: Icons.share,
            label: 'Share',
          ),
          const SizedBox(width: 10),
        ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          const SizedBox(width: 10),
          SlidableAction(
            flex: 1,
            onPressed: toInput,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            // foregroundColor: Theme.of(context).colorScheme.inverseSurface,
            foregroundColor: Theme.of(context).scaffoldBackgroundColor,
            icon: Icons.input,
            label: 'To Input',
          ),
          SlidableAction(
            flex: 1,
            onPressed: onPhoto,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).scaffoldBackgroundColor,
            icon: Icons.camera_alt,
            label: 'Photo',
          ),
        ],
      ),
      // TODO: if it contains picture(s), then convert to expansion tile, etc.
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                busm.input,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surfaceBright,
                ),
              ),
              Text(
                busm.english,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
              Text(
                busm.kana,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              Text(
                busm.romaji,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
