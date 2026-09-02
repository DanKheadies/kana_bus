import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus/barrel.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      height: 45,
      padding: EdgeInsets.zero,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 50,
            child: IconButton(
              tooltip: 'Bus Rides',
              icon: Icon(
                Icons.line_style,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                // SystemChannels.textInput.invokeMethod('TextInput.hide');
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          const SizedBox(),
          const SizedBox(),
          BlocListener<KanaBusBloc, KanaBusState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == KanaBusStatus.updated) {
                KanaBusHelper.sendSnack(context, 'Your ride has been saved.');
              }
            },
            child: SizedBox(
              width: 50,
              child: BlocBuilder<KanaBusBloc, KanaBusState>(
                builder: (context, state) {
                  return state.status == KanaBusStatus.updating
                      ? CircularProgressIndicator(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                        )
                      : IconButton(
                          tooltip: 'Save',
                          icon: Icon(
                            Icons.save,
                            color: Theme.of(context).primaryColor.withAlpha(
                              state.currentRide.kanaBusms.isEmpty ? 100 : 255,
                            ),
                            size: 30,
                          ),
                          onPressed: state.currentRide.kanaBusms.isEmpty
                              ? null
                              : () {
                                  context.read<KanaBusBloc>().add(
                                    EditBusRide(
                                      andUpdate: true,
                                      currentRide: state.currentRide.copyWith(
                                        lastRide: DateTime.now(),
                                      ),
                                    ),
                                  );
                                },
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
