import 'package:flutter/material.dart';
import 'package:kana_bus/barrel.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: SafeArea(child: Center(child: Text('TODO'))),
    );
  }
}
