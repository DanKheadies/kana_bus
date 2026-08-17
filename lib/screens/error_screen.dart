import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emergency Stop')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Uh oh, something has gone wrong.'),
          const SizedBox(height: 50, width: double.infinity),
          TextButton(
            onPressed: () {
              context.goNamed('home');
            },
            child: Text('Home Please'),
          ),
        ],
      ),
    );
  }
}
