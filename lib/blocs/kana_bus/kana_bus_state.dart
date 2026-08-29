part of 'kana_bus_bloc.dart';

enum KanaBusStatus {
  initial,
  loaded,
  loading,
  error,
  translating,
  updated,
  updating,
}

class KanaBusState extends Equatable {
  final BusRide currentRide;
  final KanaBusStatus status;
  final List<BusRide> busRides;
  final TranslationResult? translation;
  final TranslationType currentType;

  const KanaBusState({
    required this.busRides,
    required this.currentRide,
    required this.currentType,
    required this.status,
    this.translation,
  });

  @override
  List<Object?> get props => [
    busRides,
    currentRide,
    currentType,
    status,
    translation,
  ];

  factory KanaBusState.initial() {
    return const KanaBusState(
      busRides: [],
      currentRide: BusRide.emptyBusRide,
      currentType: TranslationType.japanese,
      status: KanaBusStatus.initial,
    );
  }

  KanaBusState copyWith({
    BusRide? currentRide,
    List<BusRide>? busRides,
    KanaBusStatus? status,
    TranslationResult? translation,
    TranslationType? currentType,
  }) {
    return KanaBusState(
      busRides: busRides ?? this.busRides,
      currentRide: currentRide ?? this.currentRide,
      currentType: currentType ?? this.currentType,
      status: status ?? this.status,
      translation: translation ?? this.translation,
    );
  }

  factory KanaBusState.fromJson(Map<String, dynamic> json) {
    return KanaBusState(
      busRides: (json['busRides'] as List)
          .map((ride) => BusRide.fromJson(ride))
          .toList(),
      currentRide: BusRide.fromJson(json['currentRide']),
      currentType: TranslationType.values.firstWhere(
        (type) => type.name.toString() == json['currentType'],
      ),
      status: KanaBusStatus.values.firstWhere(
        (status) => status.name.toString() == json['status'],
      ),
      translation: json['translation'] != null
          ? TranslationResult.fromJson(json['translation'])
          : null,
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
      'currentType': currentType.name,
      'status': status.name,
      'translation': translation?.toJson(),
    };
  }
}
