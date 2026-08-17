import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_bus/barrel.dart';

class KanaBusApp extends StatefulWidget {
  const KanaBusApp({super.key});

  @override
  State<KanaBusApp> createState() => _KanaBusAppState();
}

class _KanaBusAppState extends State<KanaBusApp> {
  late final GoRouter appRouter;

  @override
  void initState() {
    super.initState();
    appRouter = AppRouter(context).router;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          // theme: state == Brightness.dark ? darkTheme() : lightTheme(),
          theme: darkTheme(),
        );
      },
    );
  }
}
