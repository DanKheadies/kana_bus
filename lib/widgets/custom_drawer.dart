import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_bus/barrel.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GestureDetector(
              onTap: () {
                context.read<SettingsCubit>().toggleTheme();
              },
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
            Center(child: Text('かな Bus', style: TextStyle(fontSize: 18))),
            const SizedBox(height: 15),
            ListTile(
              title: Text(
                'Current Ride',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              leading: Icon(
                Icons.bus_alert,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                context.goNamed('home');
                Navigator.of(context).pop();
              },
              hoverColor: Theme.of(context).primaryColor.withAlpha(30),
            ),
            ListTile(
              title: Text(
                'All Rides',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              leading: Icon(Icons.route, color: Theme.of(context).primaryColor),
              onTap: () => context.goNamed('rides'),
              hoverColor: Theme.of(context).primaryColor.withAlpha(30),
            ),
            ListTile(
              title: Text(
                'Transit Guide',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              leading: Icon(Icons.map, color: Theme.of(context).primaryColor),
              onTap: () => print('TODO'), // context.goNamed('contact'),
              hoverColor: Theme.of(context).primaryColor.withAlpha(30),
            ),
            ListTile(
              title: Text(
                'Bus Simulator',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              leading: Icon(
                Icons.grid_on,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () => context.goNamed('practice'),
              hoverColor: Theme.of(context).primaryColor.withAlpha(30),
            ),
            ListTile(
              title: Text(
                'Contact',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              leading: Icon(
                Icons.help_outline_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () => print('TODO'), // context.goNamed('contact'),
              hoverColor: Theme.of(context).primaryColor.withAlpha(30),
            ),
            // if (context.read<AuthCubit>().state.status ==
            //     AuthStatus.authenticated) ...[
            //   ListTile(
            //     title: Text(
            //       'Backstage',
            //       style: TextStyle(
            //         fontSize: 18,
            //         color: Theme.of(context).primaryColor,
            //       ),
            //     ),
            //     leading: Icon(
            //       Icons.temple_buddhist,
            //       color: Theme.of(context).primaryColor,
            //     ),
            //     onTap: () => context.goNamed('stage'),
            //     hoverColor: Theme.of(context).primaryColor.withAlpha(30),
            //   ),
            // ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
