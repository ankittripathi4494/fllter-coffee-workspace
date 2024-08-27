import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_event.dart';
import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_state.dart';
import 'package:filtercoffee/global/utils/shared_preferences_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitcherBloc extends Bloc<ThemeSwitcherEvent, ThemeSwitcherState> {
  SessionHelper sph = SessionHelper();
  ThemeSwitcherBloc() : super(ThemeSwitcherInitial()) {
    on<ThemeChanged>((event, emit) async {
      if (event.themeType == true) {
        sph.setBool("darkTheme", true);
        emit(ThemeDarkModeState(appTheme: true));
      } else if (event.themeType == false) {
        sph.setBool("darkTheme", false);
        emit(ThemelightModeState(appTheme: false));
      }
    });
  }
}
