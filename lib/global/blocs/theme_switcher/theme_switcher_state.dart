
class ThemeSwitcherState {}

class ThemeSwitcherInitial extends ThemeSwitcherState {}

class ThemelightModeState extends ThemeSwitcherState {
  final bool appTheme;
  ThemelightModeState({required this.appTheme});
}

class ThemeDarkModeState extends ThemeSwitcherState {
  final bool appTheme;
  ThemeDarkModeState({required this.appTheme});
}
