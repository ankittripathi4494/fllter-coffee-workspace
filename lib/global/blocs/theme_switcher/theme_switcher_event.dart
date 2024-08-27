class ThemeSwitcherEvent {}

class ThemeChanged extends ThemeSwitcherEvent {
  final bool themeType;

  ThemeChanged({required this.themeType});
}
