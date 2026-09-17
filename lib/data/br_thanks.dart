import 'package:kana_bus/barrel.dart';
import 'package:uuid/v4.dart';

class BusRideThanks {
  static final List<Busm> thankYouVariations = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english:
          'I\'m very grateful / I truly appreciate it (super polite - business / formal)',
      romaji: 'kyoushuku desu',
      kana: 'きょうしゅく です',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english:
          'I\'m very grateful for your kindness / much appreciated (polite + humble - customer service vibe)',
      romaji: 'osore irimasu',
      kana: 'おそれ いります',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'that really helps (polite & useful - daily work)',
      romaji: 'tasukari masu',
      kana: 'たすかり ます',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'thanks (casual everyday)',
      romaji: 'doumo',
      kana: 'どうも',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'appreciate it! (very casual - friends)',
      romaji: 'maji kansha',
      kana: 'まじ かんしゃ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'you\'re a life saver! (slang - when someone saves your life)',
      romaji: 'kami',
      kana: 'かみ',
    ),
  ];

  static final List<Busm> moreThanArigato = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'that really helps (polite / normal)',
      romaji: 'tasukarimasu',
      kana: 'たすかります',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'thanks a lot (casual)',
      romaji: 'maji kansha',
      kana: 'きょしゅく です',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'I really appreciate it (formal)',
      romaji: 'kyoshuku desu',
      kana: 'きょしゅく です',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'thanks (polite / normal)',
      romaji: 'dōmo',
      kana: 'どうも',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'you\'re a lifesave, thanks a lot (casual)',
      romaji: 'gachi kami, maji kansha',
      kana: 'がち かみ まじ かんしゃ',
    ),
  ];
}
