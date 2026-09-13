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
  bool canUpdate = false;
  bool isFavorite = false;
  List<String> flagsList = [];
  TextEditingController flagCont = TextEditingController();
  TextEditingController titleCont = TextEditingController();

  @override
  void initState() {
    super.initState();

    flagsList = widget.currentRide.flags != null
        ? widget.currentRide.flags!.toList()
        : [];
    isFavorite = widget.currentRide.isFavorite;
    titleCont.text = widget.currentRide.title;
  }

  @override
  void dispose() {
    flagCont.dispose();
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
                  Navigator.of(context).pop(true);
                } else if (state.status == KanaBusStatus.error) {
                  KanaBusHelper.sendSnack(
                    context,
                    'There was an error saving your info.',
                  );
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
                            KanaBusHelper.sendSnack(
                              context,
                              'Please wait for [magic].',
                            );
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
                                  : buildContent(),
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

  Widget buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BusmPane(
          controller: titleCont,
          label: 'This Ride',
          onChanged: (value) => hasChanged(),
          isDisabled: false,
          textCapitalization: TextCapitalization.sentences,
        ),
        SizedBox(
          width: 450,
          child: Column(
            children: [
              const SizedBox(height: 8),
              ClickableDivider(
                text: 'Favorite',
                icon: isFavorite
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  hasChanged();
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: BusmPane(
                      controller: flagCont,
                      label: 'Flags',
                      onChanged: (value) {},
                      onEditingComplete: () =>
                          addFlag(context, widget.currentRide),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => addFlag(context, widget.currentRide),
                  ),
                ],
              ),
              if (flagsList.isNotEmpty) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: flagsList.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(flagsList[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        List<String> flags = flagsList.toList();
                        flags.remove(flags[index]);

                        setState(() {
                          flagsList = flags.toList();
                        });

                        hasChanged();
                      },
                    ),
                    contentPadding: const EdgeInsets.only(left: 16),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: canUpdate
              ? () {
                  context.read<KanaBusBloc>().add(
                    EditBusRide(
                      andUpdate: true,
                      currentRide: widget.currentRide.copyWith(
                        flags: flagsList,
                        isFavorite: isFavorite,
                        title: titleCont.text,
                      ),
                    ),
                  );
                }
              : null,
          child: Text('Update'),
        ),
      ],
    );
  }

  void addFlag(BuildContext context, BusRide ride) {
    if (flagCont.text != '') {
      List<String> flags = flagsList.toList();
      flags.add(flagCont.text);

      setState(() {
        flagsList = flags.toList();
        flagCont.clear();
      });

      hasChanged();
    }
  }

  void hasChanged() {
    setState(() {
      canUpdate =
          (flagsList != widget.currentRide.flags &&
              (flagsList.isNotEmpty || widget.currentRide.flags != null)) ||
          isFavorite != widget.currentRide.isFavorite ||
          titleCont.text != widget.currentRide.title;
    });
  }
}
