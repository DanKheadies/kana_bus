import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:kana_bus/barrel.dart';

/// A KanaBus Ride (BusRide) is a collection of busm based on context. A ride is
/// a planned or impromtu trip, schedule, journey, and/or route. The BusRide
/// serves as a quick reference or cheat sheet, a "day-in-the-life," an event,
/// dialogue, or window of time that is better served as a continuously connected
/// series. Futher information can be provide to help with referencing, ease of
/// recall, and general organization.
class BusRide extends Equatable {
  final bool? isArchived;
  final DateTime? createdOn;
  final DateTime? updatedOn;
  final List<Busm> kanaBusms;
  final List<String>? flags;
  // final List<String>? folders;
  final String id;
  final String? title;

  const BusRide({
    required this.kanaBusms,
    required this.id,
    this.createdOn,
    this.flags,
    this.isArchived = false,
    this.title,
    this.updatedOn,
  });

  @override
  List<Object?> get props => [
    createdOn,
    flags,
    id,
    isArchived,
    kanaBusms,
    title,
    updatedOn,
  ];

  BusRide copyWith({
    bool? isArchived,
    DateTime? createdOn,
    DateTime? updatedOn,
    List<Busm>? kanaBusms,
    List<String>? flags,
    String? id,
    String? title,
  }) {
    return BusRide(
      createdOn: createdOn ?? this.createdOn,
      flags: flags ?? this.flags,
      id: id ?? this.id,
      isArchived: isArchived ?? this.isArchived,
      kanaBusms: kanaBusms ?? this.kanaBusms,
      title: title ?? this.title,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  factory BusRide.fromSnapshot(DocumentSnapshot snap) {
    dynamic data = snap.data();
    return BusRide.fromJson(data).copyWith(id: snap.id);
  }

  factory BusRide.fromJson(Map<String, dynamic> json) {
    DateTime? createdOnDT = json['createdOn'] != null
        ? DateTime.tryParse(json['createdOn'])
        : null;
    DateTime? updatedOnDT = json['updatedOn'] != null
        ? DateTime.tryParse(json['updatedOn'])
        : null;

    return BusRide(
      createdOn: createdOnDT,
      flags: json['flags'] != null
          ? (json['flags'] as List).map((flag) => flag as String).toList()
          : null,
      id: json['id'],
      isArchived: json['isArchived'],
      kanaBusms: (json['kanaBusms'] as List)
          .map((busm) => Busm.fromJson(busm))
          .toList(),
      title: json['title'],
      updatedOn: updatedOnDT,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> kanaBusmsList = [];
    if (kanaBusms.isNotEmpty) {
      for (var busm in kanaBusms) {
        kanaBusmsList.add(busm.toJson());
      }
    }

    return {
      'createdOn': createdOn?.toUtc().toIso8601String(),
      'flags': flags,
      'id': id,
      'isArchived': isArchived,
      'kanaBusms': kanaBusmsList,
      'title': title,
      'updatedOn': updatedOn?.toUtc().toIso8601String(),
    };
  }

  static const BusRide emptyBusRide = BusRide(id: '', kanaBusms: []);
}
