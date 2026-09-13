import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_bus/barrel.dart';

class ScheduledScreen extends StatelessWidget {
  const ScheduledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // double calcWidth = constraints.maxWidth < 850
            //     ? constraints.maxWidth - 300
            //     : 300;
            return ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: ScheduledBusRide.allScheduledRides.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    '${ScheduledBusRide.allScheduledRides[index].title} (${ScheduledBusRide.allScheduledRides[index].busms.length})',
                  ),
                  subtitle: Text(
                    ScheduledBusRide.allScheduledRides[index].subtitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.rebase_edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    tooltip: 'Load this ride',
                    onPressed: () {
                      context.read<KanaBusBloc>().add(
                        LoadScheduledRide(
                          ride: ScheduledBusRide.allScheduledRides[index],
                        ),
                      );

                      context.goNamed('home');
                    },
                  ),
                  childrenPadding: const EdgeInsets.only(left: 40),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: AlignmentGeometry.centerLeft,
                  children: [
                    for (var busm
                        in ScheduledBusRide.allScheduledRides[index].busms)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(busm.english),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
