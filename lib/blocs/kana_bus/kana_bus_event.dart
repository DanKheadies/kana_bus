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

class CycleType extends KanaBusEvent {
  final TranslationType? type;

  const CycleType({this.type});

  @override
  List<Object?> get props => [type];
}

class DeleteBusRide extends KanaBusEvent {
  final String id;

  const DeleteBusRide({required this.id});

  @override
  List<Object> get props => [id];
}

class EditBusRide extends KanaBusEvent {
  final bool? andUpdate;
  final BusRide currentRide;

  const EditBusRide({required this.currentRide, this.andUpdate = false});

  @override
  List<Object?> get props => [andUpdate, currentRide];
}

class GetBusRides extends KanaBusEvent {}

class LoadCurrentRide extends KanaBusEvent {
  final String id;

  const LoadCurrentRide({required this.id});

  @override
  List<Object> get props => [id];
}

class LoadScheduledRide extends KanaBusEvent {
  final ScheduledBusRide ride;

  const LoadScheduledRide({required this.ride});

  @override
  List<Object> get props => [ride];
}

class RemoveBusm extends KanaBusEvent {
  final bool? removeAll;
  final int index;

  const RemoveBusm({required this.index, this.removeAll = false});

  @override
  List<Object?> get props => [index, removeAll];
}

class ResetTranslator extends KanaBusEvent {}

class Translate extends KanaBusEvent {
  final String input;
  final TranslationType type;

  const Translate({required this.input, required this.type});

  @override
  List<Object> get props => [input, type];
}

class ToggleFavorite extends KanaBusEvent {}

class TriggerLoading extends KanaBusEvent {}

class UpdateBusRide extends KanaBusEvent {
  final BusRide currentRide;

  const UpdateBusRide({required this.currentRide});

  @override
  List<Object> get props => [currentRide];
}
