import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus/barrel.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Kana Bus'),
      actions: [
        BlocBuilder<KanaBusBloc, KanaBusState>(
          builder: (context, state) {
            if (state.currentRide.kanaBusms.isNotEmpty) {
              return IconButton(
                tooltip: 'Delete All',
                icon: Icon(Icons.delete),
                onPressed: () {
                  context.read<KanaBusBloc>().add(
                    RemoveBusm(index: 0, removeAll: true),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        IconButton(
          tooltip: 'Info',
          icon: Icon(Icons.info),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return InfoDialog();
              },
            );
          },
        ),
        IconButton(
          tooltip: 'Menu',
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
