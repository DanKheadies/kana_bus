import 'package:kana_bus/barrel.dart';
import 'package:uuid/v4.dart';

class BusRideBaeb {
  static final List<Busm> baebBasics = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'I like you',
      romaji: 'suki dayo',
      kana: 'すき だよ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'I really like you',
      romaji: 'daisuki dayo',
      kana: 'だいすき だよ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'I love you',
      romaji: 'aishiteru',
      kana: 'あいしてる',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'I love you (exclamation / emphasis)',
      romaji: 'aishiteruyo',
      kana: 'あいしてるよ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'I love you (polite / formal)',
      romaji: 'aishitemasu',
      kana: 'あいしてます',
    ),
  ];
}
