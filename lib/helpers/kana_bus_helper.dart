import 'package:flutter/material.dart';

class KanaBusHelper {
  static void sendSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
}

// void sendSnack(BuildContext context, String text) {
//   ScaffoldMessenger.of(context)
//     ..clearSnackBars()
//     ..showSnackBar(SnackBar(content: Text(text)));
// }
