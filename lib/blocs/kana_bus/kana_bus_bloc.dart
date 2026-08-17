import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kana_bus/barrel.dart';
import 'package:logger/logger.dart';

part 'kana_bus_event.dart';
part 'kana_bus_state.dart';

class KanaBusBloc extends HydratedBloc<KanaBusEvent, KanaBusState> {
  final DatabaseRepository databaseRepository;
  final Logger? log;

  KanaBusBloc({required this.databaseRepository, this.log})
    : super(KanaBusState.initial()) {
    on<AddBusm>(_onAddBusm);
    on<GetBusRides>(_onGetBusRides);
    on<RemoveBusm>(_onRemoveBusm);
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
