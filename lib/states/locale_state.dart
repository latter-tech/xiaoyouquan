
import 'package:flutter/material.dart';
import '../common/constants.dart';

class LocaleState extends ChangeNotifier {

  Locale? locale;

  Locale? getLocale() {
    if (locale == null) {
      return Constants.defaultLocale;
    } else {
      return locale;
    }
  }

  void setLocale(Locale? _locale) {
      locale = _locale;
      notifyListeners();
  }

}