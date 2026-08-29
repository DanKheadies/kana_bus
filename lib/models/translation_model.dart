enum TranslationType { english, japanese, romaji }

class TranslationResult {
  final String original;
  final String english;
  final String japanese;
  final String romaji;

  TranslationResult({
    required this.original,
    required this.english,
    required this.japanese,
    required this.romaji,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    return TranslationResult(
      original: json['original'] as String,
      english: json['english'] as String,
      japanese: json['japanese'] as String,
      romaji: json['romaji'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original,
      'english': english,
      'japanese': japanese,
      'romaji': romaji,
    };
  }
}
