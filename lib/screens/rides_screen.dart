import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
                    String flags = state.busRides[index].id;
                    String genericTitle =
                        'This Ride (${state.busRides[index].kanaBusms.length})';
                    if (state.busRides[index].flags != null &&
                        state.busRides[index].flags!.isNotEmpty) {
                      // String flagsCommas
                      flags = state.busRides[index].flags!.join(', ');
                      // flags = flagsCommas.substring(0, flagsCommas.length);
                    }

                    return ExpansionTile(
                      title: Text(
                        state.busRides[index].title ??
                            state.busRides[index].createdOn
                                ?.toIso8601String() ??
                            genericTitle,
                      ),
                      subtitle: Text(flags, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.rebase_edit,
                          color: Theme.of(context).primaryColor,
                        ),
                        tooltip: 'Load this ride',
                        onPressed: () {
                          // KanaBusHelper.sendSnack(context, 'TODO: edit');
                          context.read<KanaBusBloc>().add(
                            LoadCurrentRide(id: state.busRides[index].id),
                          );
                          context.goNamed('home');
                        },
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      children: [
                        BusRideRow(
                          label: 'id',
                          value: state.busRides[index].id,
                          width: calcWidth,
                        ),
                        BusRideRow(
                          label: 'title',
                          value: genericTitle,
                          width: calcWidth,
                        ),
                        BusRideRow(
                          isArchived: state.busRides[index].isArchived,
                          onHyperlink: state.status == KanaBusStatus.updating
                              ? null
                              : () {
                                  KanaBusHelper.sendSnack(
                                    context,
                                    'TODO: archive',
                                  );
                                  // context.read<StoryBloc>().add(
                                  //   UpdateStory(
                                  //     editedStory: state.stories[index]
                                  //         .copyWith(
                                  //           isArchived:
                                  //               state
                                  //                       .stories[index]
                                  //                       .isArchived ==
                                  //                   null
                                  //               ? true
                                  //               : !state
                                  //                     .stories[index]
                                  //                     .isArchived!,
                                  //         ),
                                  //   ),
                                  // );
                                },
                          label: 'isArchived',
                          value: state.status == KanaBusStatus.updating
                              ? 'Updating..'
                              : '',
                          width: calcWidth,
                        ),
                        BusRideRow(
                          label: 'created',
                          value: state.busRides[index].createdOn != null
                              ? DateFormat(
                                  'MM/dd/yyyy',
                                ).format(state.busRides[index].createdOn!)
                              : '',
                          width: calcWidth,
                        ),
                        BusRideRow(
                          label: 'updated',
                          value: state.busRides[index].updatedOn != null
                              ? DateFormat(
                                  'MM/dd/yyyy',
                                ).format(state.busRides[index].updatedOn!)
                              : '',
                          width: calcWidth,
                        ),
                        if (state.busRides[index].flags != null &&
                            state.busRides[index].flags!.isNotEmpty) ...[
                          BusRideRow(
                            label: 'flags',
                            value: '',
                            values: state.busRides[index].flags,
                            width: calcWidth,
                          ),
                        ],
                      ],
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
