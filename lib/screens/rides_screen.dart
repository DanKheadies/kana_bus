import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus/barrel.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  bool showArchived = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double calcWidth = constraints.maxWidth < 850
                ? constraints.maxWidth - 300
                : 300;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        showArchived = !showArchived;
                      }),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Archived Rides'),
                          const SizedBox(width: 8),
                          Icon(
                            showArchived
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          const SizedBox(width: 5),
                          Switch(
                            value: showArchived,
                            onChanged: (value) {
                              setState(() {
                                showArchived = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<KanaBusBloc, KanaBusState>(
                    builder: (context, state) {
                      List<BusRide> visibileRides = state.busRides.toList();
                      if (!showArchived) {
                        visibileRides.removeWhere(
                          (br) => br.isArchived != null && br.isArchived!,
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: visibileRides.length,
                        itemBuilder: (context, index) {
                          return BusRideRow(
                            calcWidth: calcWidth,
                            ride: visibileRides[index],
                            status: state.status,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
