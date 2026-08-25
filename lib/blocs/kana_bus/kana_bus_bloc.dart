import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kana_bus/barrel.dart';
import 'package:logger/logger.dart';
import 'package:uuid/v4.dart';

part 'kana_bus_event.dart';
part 'kana_bus_state.dart';

class KanaBusBloc extends HydratedBloc<KanaBusEvent, KanaBusState> {
  final DatabaseRepository databaseRepository;
  final Logger? log;

  KanaBusBloc({required this.databaseRepository, this.log})
    : super(KanaBusState.initial()) {
    on<AddBusm>(_onAddBusm);
    on<EditBusRide>(_onEditBusRide);
    on<GetBusRides>(_onGetBusRides);
    on<RemoveBusm>(_onRemoveBusm);
    on<TriggerLoading>(_onTriggerLoading);
    on<UpdateBusRide>(_onUpdateBusRide);
  }

  void _onEditBusRide(EditBusRide event, Emitter<KanaBusState> emit) {
    BusRide ride = state.currentRide;
    List<BusRide> rides = state.busRides.toList();

    // if id == '', then just save locally
    if (ride.id == '') {
      print('no id');
      DateTime now = DateTime.now().toUtc();
      ride = ride.copyWith(
        createdOn: now,
        flags: event.currentRide.flags,
        id: UuidV4().generate(),
        kanaBusms: state.currentRide.kanaBusms,
        title: event.currentRide.title,
        updatedOn: now,
      );
      print('ride: $ride');
      // } else if () {}
      // else, should check if is FirebaseId vs UUID to know if we save online or
      // just continue to save locally
    } else {
      print('update: ${ride.id}');
      ride = ride.copyWith(
        flags: event.currentRide.flags,
        title: event.currentRide.title,
        updatedOn: DateTime.now().toUtc(),
      );
    }

    int index = rides.indexWhere((bs) => bs.id == ride.id);
    if (index >= 0) {
      print('index: $index');
      rides[index] = ride;
    } else {
      print('not in list');
      rides.add(ride);
    }

    if (event.andUpdate ?? false) {
      print('and update');
      emit(state.copyWith(busRides: rides));
      add(UpdateBusRide(currentRide: ride));
    } else {
      print('just edit');
      emit(
        state.copyWith(
          busRides: rides,
          currentRide: ride,
          // status: KanaBusStatus.updated,
        ),
      );
    }
  }

  Future<void> _onTriggerLoading(
    TriggerLoading event,
    Emitter<KanaBusState> emit,
  ) async {
    if (state.status == KanaBusStatus.loading) return;
    emit(state.copyWith(status: KanaBusStatus.loading));

    await Future.delayed(Duration(milliseconds: 1000));

    emit(state.copyWith(status: KanaBusStatus.loaded));
  }

  Future<void> _onUpdateBusRide(
    UpdateBusRide event,
    Emitter<KanaBusState> emit,
  ) async {
    if (state.status == KanaBusStatus.updating) return;
    emit(state.copyWith(status: KanaBusStatus.updating));

    BusRide ride = event.currentRide;
    List<BusRide> rides = state.busRides.toList();

    // TODO: check if we have connection to Firebase and save; else save locally
    // if to Firebase, should replace Ids
    await Future.delayed(Duration(milliseconds: 1000));

    // var response = 'derp';

    // // if id isUuid, then sub the Firebase id and update the list
    // if (ride.id == isUuid()) {
    //   ride = ride.copyWith(id: response);

    //   int index = rides.indexWhere((bs) => bs.id == ride.id);
    //   if (index >= 0) {
    //     print('index: $index');
    //     rides[index] = ride;
    //   } else {
    //     print('not in list');
    //   }
    // }

    emit(
      state.copyWith(
        busRides: rides,
        currentRide: ride,
        status: KanaBusStatus.updated,
      ),
    );
  }

  void _onAddBusm(AddBusm event, Emitter<KanaBusState> emit) {
    if (state.status == KanaBusStatus.updating) return;
    emit(state.copyWith(status: KanaBusStatus.updating));

    BusRide currentBusRide = state.currentRide;
    List<Busm> busmList = currentBusRide.kanaBusms.toList();
    busmList.add(event.newBusm);

    emit(
      state.copyWith(
        currentRide: currentBusRide.copyWith(kanaBusms: busmList),
        status: KanaBusStatus.updated,
      ),
    );
  }

  void _onGetBusRides(GetBusRides event, Emitter<KanaBusState> emit) {
    if (state.status == KanaBusStatus.loading) return;
    emit(state.copyWith(status: KanaBusStatus.loading));

    List<BusRide> ridesList = [];
    // TODO: get rides from Firebase

    emit(state.copyWith(busRides: ridesList, status: KanaBusStatus.loaded));
  }

  void _onRemoveBusm(RemoveBusm event, Emitter<KanaBusState> emit) {
    if (state.status == KanaBusStatus.updating) return;
    emit(state.copyWith(status: KanaBusStatus.updating));

    BusRide currentBusRide = state.currentRide;
    List<Busm> busmList = currentBusRide.kanaBusms.toList();
    if (busmList.isNotEmpty) {
      if (event.removeAll!) {
        busmList = [];
      } else {
        busmList.removeAt(event.index);
      }
    }

    emit(
      state.copyWith(
        currentRide: currentBusRide.copyWith(kanaBusms: busmList),
        status: KanaBusStatus.updated,
      ),
    );
  }

  @override
  KanaBusState? fromJson(Map<String, dynamic> json) {
    return KanaBusState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(KanaBusState state) {
    return state.toJson();
  }
}
