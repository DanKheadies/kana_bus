import 'package:kana_bus/barrel.dart';
import 'package:uuid/v4.dart';

class BusRideConsumables {
  static final List<Busm> consumableDrinks = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'water',
      romaji: 'mizu',
      kana: 'みず',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'water (cold / iced)',
      romaji: 'ohiya',
      kana: 'おひや',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'black tea',
      romaji: 'koucha',
      kana: 'こうちゃ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'coffee',
      romaji: 'koohii',
      kana: 'こおひい',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'green tea',
      romaji: 'ocha',
      kana: 'おちゃ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'coke',
      romaji: 'koora',
      kana: 'こおら',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'milk',
      romaji: 'gyuunyuu',
      kana: 'ぎゅうにゅう',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'beer',
      romaji: 'biiru',
      kana: 'びいる',
    ),
  ];
}
