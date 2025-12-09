import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {

  bool? _isBusy = false;

  bool get isbusy => _isBusy!;

  int _tabIndex = 0;

  int _refresh = 0;

  int get refresh => _refresh;

  set refresh(int x) {
    _refresh = x;
    notifyListeners();
  }

  set loading(bool value){
    _isBusy = value;
    notifyListeners();
  }

  int get tabIndex {
    return _tabIndex;
  }

  set setTabIndex(int index){
    _tabIndex = index;
    notifyListeners();
  }

}