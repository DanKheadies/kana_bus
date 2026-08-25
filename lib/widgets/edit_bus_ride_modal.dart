import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus/barrel.dart';

class EditBusRideModal extends StatefulWidget {
  final BusRide currentRide;

  const EditBusRideModal({super.key, required this.currentRide});

  @override
  State<EditBusRideModal> createState() => _EditBusRideModalState();
}

class _EditBusRideModalState extends State<EditBusRideModal> {
  bool hasChanged = false;
  TextEditingController flagCont = TextEditingController();
  TextEditingController titleCont = TextEditingController();

  @override
  void initState() {
    super.initState();

    titleCont.text = widget.currentRide.title ?? '';
  }

  @override
  void dispose() {
    titleCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withAlpha(20),
            body: BlocListener<KanaBusBloc, KanaBusState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == KanaBusStatus.updated) {
                  sendSnack(context, 'Your changes have been saved.');
                } else if (state.status == KanaBusStatus.error) {
                  sendSnack(context, 'There was an error saving your info.');
                }
              },
              child: BlocBuilder<KanaBusBloc, KanaBusState>(
                builder: (context, state) {
                  bool isWorking =
                      state.status == KanaBusStatus.loading ||
                      state.status == KanaBusStatus.updating;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: isWorking
                        ? () {
                            sendSnack(context, 'Please wait for [magic].');
                          }
                        : () => Navigator.of(context).pop(),
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          isWorking ? 150 : 20,
                        ),
                      ),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        child: GestureDetector(
                          onTap:
                              () {}, // Avoid clicking the modal to dismiss it.
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
            ),
          );
        },
      ),
    );
  }

  void sendSnack(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(content)));
  }

  Widget buildContent(KanaBusState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BusmPane(
          controller: titleCont,
          label: 'This Ride',
          onChanged: (value) {
            setState(() {
              hasChanged = true;
            });
          },
          isDisabled: false,
        ),
        const SizedBox(height: 15),
        SizedBox(
          // padding: rowPadding,
          // width: widget.width < 850 ? widget.width : 500,
          width: 450,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: BusmPane(
                      controller: flagCont,
                      label: 'Flags',
                      onChanged: (value) {},
                      // onEnter: (_) =>
                      onEditingComplete: () =>
                          addFlag(context, state.currentRide),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => addFlag(context, state.currentRide),
                  ),
                ],
              ),
              if (state.currentRide.flags != null) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.currentRide.flags!.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(state.currentRide.flags![index]),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        List<String> flagsList = state.currentRide.flags!
                            .toList();
                        flagsList.remove(state.currentRide.flags![index]);

                        context.read<KanaBusBloc>().add(
                          EditBusRide(
                            currentRide: state.currentRide.copyWith(
                              flags: flagsList,
                            ),
                          ),
                        );
                      },
                    ),
                    contentPadding: const EdgeInsets.only(left: 16),
                    // onLongPress: () {},
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed:
              // (widget.currentRide.title == titleCont.text ||
              // TODO: logic; adding / removing flags edits auto and could ignore
              // the restriction here (currently does), but UX seems off..
              titleCont.text == '' || !hasChanged
              ? null
              : () {
                  context.read<KanaBusBloc>().add(
                    EditBusRide(
                      currentRide: state.currentRide.copyWith(
                        title: titleCont.text,
                      ),
                    ),
                  );
                  setState(() {
                    hasChanged = false;
                  });
                },
          child: Text('Update'),
        ),
      ],
    );
  }

  void addFlag(BuildContext context, BusRide ride) {
    if (flagCont.text != '') {
      List<String> flagsList = (ride.flags ?? []).toList();
      flagsList.add(flagCont.text);

      context.read<KanaBusBloc>().add(
        EditBusRide(currentRide: ride.copyWith(flags: flagsList)),
      );

      setState(() {
        flagCont.clear();
        hasChanged = true;
      });
    }
  }
}
