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
    on<CycleType>(_onCycleType);
    on<DeleteBusRide>(_onDeleteBusRide);
    on<EditBusRide>(_onEditBusRide);
    on<GetBusRides>(_onGetBusRides);
    on<LoadCurrentRide>(_onLoadCurrentRide);
    on<LoadScheduledRide>(_onLoadScheduledRide);
    on<RemoveBusm>(_onRemoveBusm);
    on<ResetTranslator>(_onResetTranslator);
    on<ToggleFavorite>(_onToggleFavorite);
    on<Translate>(_onTranslate);
    on<TriggerLoading>(_onTriggerLoading);
    on<UpdateBusRide>(_onUpdateBusRide);
  }

  Future<void> _onDeleteBusRide(
    DeleteBusRide event,
    Emitter<KanaBusState> emit,
  ) async {
    if (state.status == KanaBusStatus.updating) return;
    emit(state.copyWith(status: KanaBusStatus.updating));

    BusRide currentBusRide = state.currentRide.id == event.id
        ? BusRide.emptyBusRide
        : state.currentRide;
    List<BusRide> ridesList = state.busRides.toList();
    ridesList.removeWhere((ride) => ride.id == event.id);

    await Future.delayed(Duration(milliseconds: 500));

    emit(
      state.copyWith(
        busRides: ridesList,
        currentRide: currentBusRide,
        status: KanaBusStatus.updated,
      ),
    );
  }

  Future<void> _onTranslate(Translate event, Emitter<KanaBusState> emit) async {
    if (state.status == KanaBusStatus.translating) return;
    emit(state.copyWith(status: KanaBusStatus.translating));

    TranslationResult translation = TranslationResult(
      original: '',
      english: '',
      japanese: '',
      romaji: '',
    );

    translation = await databaseRepository.translateWord(
      event.input,
      event.type,
    );
    // print('translation: ');
    // print(translation.original);
    // print(translation.english);
    // print(translation.japanese);
    // print(translation.romaji);

    emit(
      state.copyWith(status: KanaBusStatus.loaded, translation: translation),
    );
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

    bool isFirebaseAccount = 1 + 1 == 3;
    if (isFirebaseAccount) {
      var response = 'callFirebaseToGetSetDocument';
      // var response = await databaseRepository.getRideById(
      //   id: ride.id,
      // );
      // ride = BusRide.fromJson(response['data']);
      if (ride.id.contains('-')) {
        // TODO: update id to use Firebase id now
        ride = ride.copyWith(id: response);
      }
    } else {}

    int index = rides.indexWhere((bs) => bs.id == event.currentRide.id);
    if (index >= 0) {
      // print('index: $index');
      rides[index] = ride;
      // } else {
      //   print('not in list');
    }

    emit(
      state.copyWith(
        busRides: rides,
        currentRide: ride,
        status: KanaBusStatus.updated,
      ),
    );
  }

  void _onAddBusm(AddBusm event, Emitter<KanaBusState> emit) {
    BusRide currentBusRide = state.currentRide;
    List<Busm> busmList = currentBusRide.kanaBusms.toList();
    busmList.add(event.newBusm);

    add(EditBusRide(currentRide: currentBusRide.copyWith(kanaBusms: busmList)));
  }

  void _onEditBusRide(EditBusRide event, Emitter<KanaBusState> emit) {
    BusRide ride = event.currentRide;
    List<BusRide> rides = state.busRides.toList();

    // No id, add local / uuid and instantiate
    if (ride.id == '') {
      DateTime now = DateTime.now();
      ride = ride.copyWith(
        createdOn: now,
        flags: event.currentRide.flags,
        id: UuidV4().generate(),
        kanaBusms: event.currentRide.kanaBusms,
        title: event.currentRide.title,
        updatedOn: now,
      );
      // print('ride: $ride');
    } else {
      // print('update: ${ride.id}');
      ride = ride.copyWith(
        flags: event.currentRide.flags?.toList(),
        isArchived: event.currentRide.isArchived,
        kanaBusms: event.currentRide.kanaBusms.toList(),
        title: event.currentRide.title,
        updatedOn: DateTime.now(),
      );
    }

    int index = rides.indexWhere((bs) => bs.id == ride.id);
    if (index >= 0) {
      // print('index: $index');
      rides[index] = ride;
    } else {
      // print('not in list');
      rides.add(ride);
    }

    if (event.andUpdate ?? false) {
      // print('and update');
      emit(state.copyWith(busRides: rides));
      add(UpdateBusRide(currentRide: ride));
    } else {
      // print('just edit');
      emit(
        state.copyWith(
          busRides: rides,
          currentRide: ride,
          // status: KanaBusStatus.updated,
        ),
      );
    }
  }

  void _onCycleType(CycleType event, Emitter<KanaBusState> emit) {
    emit(
      state.copyWith(
        currentType: event.type != null
            ? event.type!
            : state.currentType == TranslationType.english
            ? TranslationType.japanese
            : state.currentType == TranslationType.japanese
            ? TranslationType.romaji
            : TranslationType.english,
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

  void _onLoadCurrentRide(LoadCurrentRide event, Emitter<KanaBusState> emit) {
    BusRide currentRide = BusRide.emptyBusRide;
    List<BusRide> rides = state.busRides.toList();

    int index = rides.indexWhere((bs) => bs.id == event.id);
    if (index >= 0) {
      currentRide = rides[index].copyWith(lastRide: DateTime.now());
      rides[index] = currentRide;
    }

    emit(state.copyWith(busRides: rides, currentRide: currentRide));
  }

  void _onLoadScheduledRide(
    LoadScheduledRide event,
    Emitter<KanaBusState> emit,
  ) {
    BusRide currentRide = BusRide.emptyBusRide.copyWith(
      createdOn: DateTime.now(),
      id: UuidV4().generate(),
      kanaBusms: event.ride.busms.toList(),
      title: event.ride.title,
    );
    List<BusRide> rides = state.busRides.toList();
    rides.add(currentRide);

    emit(state.copyWith(currentRide: currentRide, busRides: rides));
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

  void _onResetTranslator(ResetTranslator event, Emitter<KanaBusState> emit) {
    emit(state.copyWith(status: KanaBusStatus.loaded));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<KanaBusState> emit) {
    BusRide currentBusRide = state.currentRide;
    List<BusRide> ridesList = state.busRides.toList();

    int index = ridesList.indexWhere((ride) => ride.id == currentBusRide.id);
    if (index >= 0) {
      currentBusRide = currentBusRide.copyWith(
        isFavorite: !currentBusRide.isFavorite,
      );
      ridesList[index] = currentBusRide;
    }

    emit(state.copyWith(busRides: ridesList, currentRide: currentBusRide));
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
