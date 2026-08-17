import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:kana_bus/barrel.dart';

class BusRidesDrawer extends StatelessWidget {
  final Function()? clearBus;

  const BusRidesDrawer({super.key, this.clearBus});

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
            // ExpansionTile(title: Text('+ New')),
            ListTile(
              title: Text(
                'New',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              leading: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {
                if (clearBus != null) clearBus!();
                context.goNamed('home');
                Navigator.of(context).pop();
              },
              hoverColor: Theme.of(context).colorScheme.primary.withAlpha(30),
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
