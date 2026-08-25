part of 'kana_bus_bloc.dart';

sealed class KanaBusEvent extends Equatable {
  const KanaBusEvent();

  @override
  List<Object?> get props => [];
}

class AddBusm extends KanaBusEvent {
  final Busm newBusm;

  const AddBusm({required this.newBusm});

  @override
  List<Object> get props => [newBusm];
}

class EditBusRide extends KanaBusEvent {
  final bool? andUpdate;
  final BusRide currentRide;

  const EditBusRide({required this.currentRide, this.andUpdate = false});

  @override
  List<Object?> get props => [andUpdate, currentRide];
}

class GetBusRides extends KanaBusEvent {
  const GetBusRides();

  @override
  List<Object?> get props => [];
}

class RemoveBusm extends KanaBusEvent {
  final bool? removeAll;
  final int index;

  const RemoveBusm({required this.index, this.removeAll = false});

  @override
  List<Object?> get props => [index, removeAll];
}

class TriggerLoading extends KanaBusEvent {
  const TriggerLoading();
  @override
  List<Object> get props => [];
}

class UpdateBusRide extends KanaBusEvent {
  final BusRide currentRide;

  const UpdateBusRide({required this.currentRide});

  @override
  List<Object> get props => [currentRide];
}
