import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_bus/barrel.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? clearInputs;

  const CustomAppBar({super.key, this.clearInputs});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () => context.goNamed('home'),
        onDoubleTap: () => context.read<SettingsCubit>().toggleTheme(),
        child: Text('かな Bus'),
      ),
      actions: [
        BlocBuilder<KanaBusBloc, KanaBusState>(
          builder: (context, state) {
            if (state.status == KanaBusStatus.translating) {
              return GestureDetector(
                onDoubleTap: () {
                  context.read<KanaBusBloc>().add(ResetTranslator());
                  clearInputs;
                },
                child: CircularProgressIndicator(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20, // 5,
                    vertical: 20, // 0,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        BlocBuilder<KanaBusBloc, KanaBusState>(
          builder: (context, state) {
            if (state.currentRide.kanaBusms.isNotEmpty) {
              return IconButton(
                tooltip: 'New Ride',
                icon: Icon(Icons.fiber_new),
                onPressed: () {
                  KanaBusHelper.sendSnack(
                    context,
                    'Long press for a new ride.',
                  );
                },
                onLongPress: () {
                  context.read<KanaBusBloc>().add(LoadCurrentRide(id: ''));
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
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
