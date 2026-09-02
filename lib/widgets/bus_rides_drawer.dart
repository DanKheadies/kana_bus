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
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth - 150;

            return ListView(
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
                Center(
                  child: Text('Bus Rides', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 15),
                ListTile(
                  title: Text(
                    'New',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  leading: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
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
                        state.isNewestAtTop
                            ? Icons.toggle_on
                            : Icons.toggle_off,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: toggleOrder,
                      hoverColor: Theme.of(context).primaryColor.withAlpha(30),
                    );
                  },
                ),
                const SizedBox(height: 15),
                BlocBuilder<KanaBusBloc, KanaBusState>(
                  builder: (context, state) {
                    List<BusRide> previousRides = [];
                    for (var ride in state.busRides) {
                      if (ride.lastRide != null && !ride.isArchived!) {
                        previousRides.add(ride);
                      }
                    }
                    previousRides.sort(
                      (a, b) => b.lastRide!.compareTo(a.lastRide!),
                    );

                    return ExpansionTile(
                      title: Text('Last Acessed'),
                      children: [
                        for (int i = 0; i < previousRides.length; i++) ...[
                          BusRideRow(
                            calcWidth: width,
                            isDrawer: true,
                            ride: previousRides[i],
                            status: state.status,
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 15),
                BlocBuilder<KanaBusBloc, KanaBusState>(
                  builder: (context, state) {
                    List<BusRide> favRides = [];
                    for (var ride in state.busRides) {
                      if (ride.isFavorite && !ride.isArchived!) {
                        favRides.add(ride);
                      }
                    }
                    favRides.sort(
                      (a, b) => a.updatedOn!.compareTo(b.updatedOn!),
                    );

                    return ExpansionTile(
                      title: Text('Favorites'),
                      children: [
                        for (int i = 0; i < favRides.length; i++) ...[
                          BusRideRow(
                            calcWidth: width,
                            isDrawer: true,
                            ride: favRides[i],
                            status: state.status,
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
