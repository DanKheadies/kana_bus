part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isDarkTheme;
  final bool isNewestAtTop;

  const SettingsState({required this.isDarkTheme, required this.isNewestAtTop});

  @override
  List<Object> get props => [isDarkTheme, isNewestAtTop];

  factory SettingsState.initial() {
    return SettingsState(isDarkTheme: false, isNewestAtTop: true);
  }

  SettingsState copyWith({bool? isDarkTheme, bool? isNewestAtTop}) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isNewestAtTop: isNewestAtTop ?? this.isNewestAtTop,
    );
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      isDarkTheme: json['isDarkTheme'],
      isNewestAtTop: json['isNewestAtTop'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'isDarkTheme': isDarkTheme, 'isNewestAtTop': isNewestAtTop};
  }
}
