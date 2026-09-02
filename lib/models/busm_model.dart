import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// A KanaBus Milestone (Bus Milestone aka Busm) represents a point in time when
/// specific characters on a trip, schedule, journey and/or route join the bus
/// ride. A busm contains input, i.e. text and/or image, with the associated
/// translations, i.e. English, Japanese Kana/Kanji, and Romanji.
class Busm extends Equatable {
  final DateTime createdAt;
  // final List<dynamic>? images;
  final String english;
  final String id;
  final String input;
  final String kana;
  final String romaji;

  const Busm({
    required this.createdAt,
    required this.english,
    required this.id,
    required this.input,
    required this.kana,
    required this.romaji,
  });

  @override
  List<Object> get props => [createdAt, english, id, input, kana, romaji];

  Busm copyWith({
    DateTime? createdAt,
    String? english,
    String? id,
    String? input,
    String? kana,
    String? romaji,
  }) {
    return Busm(
      createdAt: createdAt ?? this.createdAt,
      english: english ?? this.english,
      id: id ?? this.id,
      input: input ?? this.input,
      kana: kana ?? this.kana,
      romaji: romaji ?? this.romaji,
    );
  }

  factory Busm.fromSnapshot(DocumentSnapshot snap) {
    dynamic data = snap.data();
    return Busm.fromJson(data).copyWith(id: snap.id);
  }

  factory Busm.fromJson(Map<String, dynamic> json) {
    // DateTime? created = json['created'] != null
    //     ? DateTime.parse(json['createdAt'])
    //     : null;
    DateTime created = DateTime.tryParse(json['createdAt']) ?? DateTime.now();

    if (created.isUtc) {
      created = created.toLocal();
    }

    return Busm(
      createdAt: created,
      english: json['english'],
      id: json['id'],
      input: json['input'],
      kana: json['kana'],
      romaji: json['romaji'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toUtc().toIso8601String(),
      'english': english,
      'id': id,
      'input': input,
      'kana': kana,
      'romaji': romaji,
    };
  }

  static final emptyBusm = Busm(
    createdAt: DateTime(2000),
    english: '',
    id: '',
    input: '',
    kana: '',
    romaji: '',
  );
}
