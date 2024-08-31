
import 'package:flutter/material.dart';

abstract class LocaleState {
  final Locale locale;
  LocaleState(this.locale);
}

class SelectedLocale extends LocaleState {
  SelectedLocale(super.locale);
}
