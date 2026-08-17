part of 'kana_bus_bloc.dart';

enum KanaBusStatus { initial, loaded, loading, error, updated, updating }

class KanaBusState extends Equatable {
  final BusRide currentRide;
  final KanaBusStatus status;
  final List<BusRide> busRides;

  const KanaBusState({
    required this.busRides,
    required this.currentRide,
    required this.status,
  });

  @override
  List<Object> get props => [busRides, currentRide, status];

  factory KanaBusState.initial() {
    return const KanaBusState(
      busRides: [],
      currentRide: BusRide.emptyBusRide,
      status: KanaBusStatus.initial,
    );
  }

  KanaBusState copyWith({
    BusRide? currentRide,
    List<BusRide>? busRides,
    KanaBusStatus? status,
  }) {
    return KanaBusState(
      busRides: busRides ?? this.busRides,
      currentRide: currentRide ?? this.currentRide,
      status: status ?? this.status,
    );
  }

  factory KanaBusState.fromJson(Map<String, dynamic> json) {
    List<BusRide> ridesList = (json['busRides'] as List)
        .map((busm) => BusRide.fromJson(busm))
        .toList();

    return KanaBusState(
      busRides: ridesList,
      currentRide: BusRide.fromJson(json['currentRide']),
      status: KanaBusStatus.values.firstWhere(
        (status) => status.name.toString() == json['status'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    var ridesList = [];
    for (var ride in busRides) {
      ridesList.add(ride.toJson());
    }

    return {
      'busRides': ridesList,
      'currentRide': currentRide.toJson(),
      'status': status.name,
    };
  }
}
