import 'package:flutter/material.dart';
import 'navigation_state.dart';

class NavigationViewModel extends ValueNotifier<NavigationState> {
  NavigationViewModel() : super(NavigationState());

  void selectIndex(int index) {
    value = value.copyWith(selectedIndex: index);
  }

  int get selectedIndex => value.selectedIndex;
  List<NavigationItem> get items => value.items;
}
