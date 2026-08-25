part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isDarkTheme;
  final bool isFirstCome;

  const SettingsState({required this.isDarkTheme, required this.isFirstCome});

  @override
  List<Object> get props => [isDarkTheme, isFirstCome];

  factory SettingsState.initial() {
    return SettingsState(isDarkTheme: false, isFirstCome: true);
  }

  SettingsState copyWith({bool? isDarkTheme, bool? isFirstCome}) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isFirstCome: isFirstCome ?? this.isFirstCome,
    );
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      isDarkTheme: json['isDarkTheme'],
      isFirstCome: json['isFirstCome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'isDarkTheme': isDarkTheme, 'isFirstCome': isFirstCome};
  }
}
