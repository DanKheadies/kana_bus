import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_bus/barrel.dart';

class BusRidesDrawer extends StatelessWidget {
  final Function()? clearBus;
  final Function()? toggleOrder;

  const BusRidesDrawer({super.key, this.clearBus, this.toggleOrder});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GestureDetector(
              onDoubleTap: () {
                context.goNamed('auth');
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Image(
                  image: AssetImage('assets/images/splash/launch.png'),
                ),
              ),
            ),
            Center(child: Text('Bus Rides', style: TextStyle(fontSize: 18))),
            const SizedBox(height: 15),
            ListTile(
              title: Text(
                'New',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              leading: Icon(Icons.add, color: Theme.of(context).primaryColor),
              onTap: () {
                if (clearBus != null) clearBus!();
                context.goNamed('home');
                Navigator.of(context).pop();
              },
              hoverColor: Theme.of(context).primaryColor.withAlpha(30),
            ),
            const SizedBox(height: 15),
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return ListTile(
                  title: Text(
                    'Bus Order (Newest at ${state.isNewestAtTop ? 'Bottom' : 'Top'})',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  leading: Icon(
                    state.isNewestAtTop ? Icons.toggle_on : Icons.toggle_off,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: toggleOrder,
                  hoverColor: Theme.of(context).primaryColor.withAlpha(30),
                );
              },
            ),
            const SizedBox(height: 15),
            ExpansionTile(title: Text('Last Acessed')),
            const SizedBox(height: 15),
            ExpansionTile(title: Text('Favorites')),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
