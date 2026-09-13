import 'package:kana_bus/barrel.dart';
import 'package:uuid/v4.dart';

class BusRidePronouns {
  static final List<Busm> mePronouns = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'I',
      romaji: 'watashi wa',
      kana: 'わたし わ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'my',
      romaji: 'watashi no',
      kana: 'わたし の',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'me',
      romaji: 'watashi ni',
      kana: 'わたし に',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'mine',
      romaji: 'watashi nomono',
      kana: 'わたし のもの',
    ),
  ];

  static final List<Busm> youPronouns = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'you',
      romaji: 'anata wa',
      kana: 'あなた わ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'your',
      romaji: 'anata no',
      kana: 'あなた の',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'you',
      romaji: 'anata ni',
      kana: 'あなた に',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'yours',
      romaji: 'anata nomono',
      kana: 'あなた のもの',
    ),
  ];

  static final List<Busm> himPronouns = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'he',
      romaji: 'kare wa',
      kana: 'かれ わ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'his',
      romaji: 'kare no',
      kana: 'かれ の',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'him',
      romaji: 'kare ni',
      kana: 'かれ に',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'his',
      romaji: 'kare nomono',
      kana: 'かれ のもの',
    ),
  ];

  static final List<Busm> herPronouns = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'she',
      romaji: 'kanojo wa',
      kana: 'かのじょ わ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'her',
      romaji: 'kanojo no',
      kana: 'かのじょ の',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'her',
      romaji: 'kanojo ni',
      kana: 'かのじょ に',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'his',
      romaji: 'kanojo nomono',
      kana: 'かのじょ のもの',
    ),
  ];
}
