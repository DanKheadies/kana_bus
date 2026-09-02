import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus/barrel.dart';

class DeleteBusRideModal extends StatefulWidget {
  final BusRide currentRide;

  const DeleteBusRideModal({super.key, required this.currentRide});

  @override
  State<DeleteBusRideModal> createState() => _DeleteBusRideModalState();
}

class _DeleteBusRideModalState extends State<DeleteBusRideModal> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withAlpha(20),
            body: BlocBuilder<KanaBusBloc, KanaBusState>(
              builder: (context, state) {
                bool isWorking =
                    state.status == KanaBusStatus.loading ||
                    state.status == KanaBusStatus.updating;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: isWorking
                      ? () {
                          KanaBusHelper.sendSnack(
                            context,
                            'Please wait for [magic].',
                          );
                        }
                      : () => Navigator.of(context).pop(),
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isWorking ? 150 : 20),
                    ),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastEaseInToSlowEaseOut,
                      child: GestureDetector(
                        // Avoid clicking the modal to dismiss it.
                        onTap: () {},
                        child: Container(
                          width: isWorking ? null : 450,
                          constraints: isWorking
                              ? BoxConstraints.tight(Size(275, 275))
                              : null,
                          padding: isWorking
                              ? EdgeInsets.zero
                              : EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              isWorking ? 150 : 20,
                            ),
                          ),
                          child: Container(
                            decoration: isWorking
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(150),
                                  )
                                : BoxDecoration(),
                            child: isWorking
                                ? Center(child: CustomLoadingWidget())
                                : buildContent(state),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildContent(KanaBusState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Are you sure you want to delete this ride?'),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Nevermind'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<KanaBusBloc>().add(
                  DeleteBusRide(id: widget.currentRide.id),
                );
                Navigator.of(context).pop();
              },
              child: Text('Do It!'),
            ),
          ],
        ),
      ],
    );
  }
}
