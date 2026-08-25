import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  final Logger log;

  SettingsCubit() : log = Logger(), super(SettingsState.initial());

  void toggleOrder() {
    emit(state.copyWith(isFirstCome: !state.isFirstCome));
  }

  void toggleTheme() {
    emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }
}
