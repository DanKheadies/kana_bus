import 'package:flutter/material.dart';
import 'package:kana_bus/barrel.dart';

class KanaBusHelper {
  static void sendSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  static String showTranslationType(TranslationType type) {
    return type == TranslationType.english
        ? 'English'
        : type == TranslationType.japanese
        ? 'Kana/ji'
        : type == TranslationType.romaji
        ? 'Romaji'
        : 'n_n';
  }
}

// void sendSnack(BuildContext context, String text) {
//   ScaffoldMessenger.of(context)
//     ..clearSnackBars()
//     ..showSnackBar(SnackBar(content: Text(text)));
// }
