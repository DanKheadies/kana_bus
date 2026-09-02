import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus/barrel.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

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
            return BlocBuilder<KanaBusBloc, KanaBusState>(
              builder: (context, state) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.busRides.length,
                  itemBuilder: (context, index) {
                    return BusRideRow(
                      calcWidth: calcWidth,
                      ride: state.busRides[index],
                      status: state.status,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
