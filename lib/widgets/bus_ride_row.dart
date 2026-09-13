import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kana_bus/barrel.dart';

class BusRideRow extends StatelessWidget {
  final bool? isDrawer;
  final BusRide ride;
  final double calcWidth;
  final KanaBusStatus status;

  const BusRideRow({
    super.key,
    required this.calcWidth,
    required this.ride,
    required this.status,
    this.isDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    String flags = ride.id;
    String genericTitle = 'This Ride (${ride.kanaBusms.length})';
    if (ride.flags != null && ride.flags!.isNotEmpty) {
      flags = ride.flags!.join(', ');
    }

    return ExpansionTile(
      title: Text(
        ride.title != ''
            ? ride.title
            : ride.createdOn?.toIso8601String() ?? genericTitle,
      ),
      subtitle: Text(flags, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        icon: Icon(Icons.rebase_edit, color: Theme.of(context).primaryColor),
        tooltip: 'Load this ride',
        onPressed: () {
          context.read<KanaBusBloc>().add(LoadCurrentRide(id: ride.id));

          if (isDrawer!) {
            Navigator.of(context).pop();
          } else {
            context.goNamed('home');
          }
        },
      ),
      childrenPadding: const EdgeInsets.only(left: 16),
      children: [
        BusRideSeat(label: 'id', value: ride.id, width: calcWidth),
        BusRideSeat(label: 'title', value: genericTitle, width: calcWidth),
        if (isDrawer!) ...[
          BusRideSeat(
            label: 'last accessed',
            value: ride.createdOn != null
                ? DateFormat('MM/dd/yyyy @ HH:mm').format(ride.createdOn!)
                : '',
            width: calcWidth,
          ),
        ],
        if (!isDrawer!) ...[
          BusRideSeat(
            isArchived: ride.isArchived,
            onHyperlink: status == KanaBusStatus.updating
                ? null
                : () {
                    context.read<KanaBusBloc>().add(
                      EditBusRide(
                        currentRide: ride.copyWith(
                          isArchived: !ride.isArchived!,
                        ),
                      ),
                    );
                  },
            onLongPress: status == KanaBusStatus.updating
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          DeleteBusRideModal(currentRide: ride),
                    );
                  },
            label: 'isArchived',
            value: status == KanaBusStatus.updating ? 'Updating..' : '',
            width: calcWidth,
          ),
          BusRideSeat(
            label: 'created',
            value: ride.createdOn != null
                ? DateFormat('MM/dd/yyyy @ HH:mm').format(ride.createdOn!)
                : '',
            width: calcWidth,
          ),
          BusRideSeat(
            label: 'updated',
            value: ride.updatedOn != null
                ? DateFormat('MM/dd/yyyy @ HH:mm').format(ride.updatedOn!)
                : '',
            width: calcWidth,
          ),
          if (ride.flags != null && ride.flags!.isNotEmpty) ...[
            BusRideSeat(
              label: 'flags',
              value: '',
              values: ride.flags,
              width: calcWidth,
            ),
          ],
        ],
      ],
    );
  }
}
