import 'package:filtercoffee/global/blocs/locale/locale_state.dart';
import 'package:filtercoffee/global/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<LocaleState> {
  SessionHelper sph = SessionHelper();
  // Passing an initial value (state) with a default 'Locale' to the super class.
  LocaleCubit() : super(SelectedLocale(const Locale('en'))) {
    checkLocale();
  }

  // Once we call this method, the BlocBuilder<LocaleCubit>
  // in the 'main.dart' will rebuild the entire app with
  // the new emitted state that holds the 'ar' locale.
  toHindi() {
    sph.setString('lang', 'hi');
    emit(SelectedLocale(const Locale('hi')));
  }

  // Same as the previous method, but with the 'en' locale.
  toEnglish() {
    sph.setString('lang', 'en');
    emit(SelectedLocale(const Locale('en')));
  }

  checkLocale() {
    if (sph.getString("lang") == "hi") {
      emit(SelectedLocale(const Locale('hi')));
    } else {
      emit(SelectedLocale(const Locale('en')));
    }
  }
}
