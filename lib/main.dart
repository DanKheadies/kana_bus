import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kana_bus/barrel.dart';
import 'package:kana_bus/firebase_options.dart';
import 'package:kana_bus/kana_bus_app.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  Logger.level = Level.all;

  SystemChannels.textInput.invokeMethod('TextInput.hide');

  runApp(const KanaBus());
}

class KanaBus extends StatelessWidget {
  const KanaBus({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<DatabaseRepository>(
          create: (_) => DatabaseRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(create: (_) => SettingsCubit()),
          BlocProvider(
            create: (context) => KanaBusBloc(
              databaseRepository: context.read<DatabaseRepository>(),
            ),
          ),
        ],
        child: KanaBusApp(),
      ),
    );
  }
}
