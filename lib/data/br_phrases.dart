import 'package:kana_bus/barrel.dart';
import 'package:uuid/v4.dart';

class BusRidePhrases {
  static final List<Busm> mariExpressivePhrases = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'That\'s so cool',
      romaji: 'suge',
      kana: 'すげー',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'Wait!!',
      romaji: 'mate',
      kana: 'まて',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'This can\'t be...',
      romaji: 'masaka',
      kana: 'まさか',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'Damnit!!',
      romaji: 'chikushō',
      kana: 'ちくしょう',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'Idiot!',
      romaji: 'baka',
      kana: 'ばか',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'Phew (relieved)',
      romaji: 'yareyare',
      kana: 'やれやれ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'For real?',
      romaji: 'majikayo',
      kana: 'まじかよ',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'Absolutely!',
      romaji: 'zettai',
      kana: 'ぜったい',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'Do your best!',
      romaji: 'ganbatte',
      kana: 'がんばって',
    ),
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'Let\'s gooooooo',
      romaji: 'ikuzo',
      kana: 'いくぞ',
    ),
  ];

  static final List<Busm> hardcorePhrases = [
    Busm(
      createdAt: DateTime.now(),
      id: UuidV4().generate(),
      input: '',
      english: 'what a dumb bitch',
      romaji: 'nanda kono bakaonna',
      kana: 'なんだ この このバ力女',
    ),
  ];
}
