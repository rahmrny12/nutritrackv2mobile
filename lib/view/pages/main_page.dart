import 'package:flutter/material.dart';
import 'package:nutritrack/view/pages/dashboard_page.dart';
import 'package:nutritrack/view/pages/log_food/history_page.dart';
import 'package:nutritrack/view/pages/profile_page.dart';
import 'package:nutritrack/view/pages/widgets/bottom_nav.dart';
import 'package:nutritrack/view/viewmodel/navigation_state.dart';
import 'package:nutritrack/view/viewmodel/navigation_viewmodel.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final NavigationViewModel _navigationViewModel;
  late final List<Widget?> _pages;

  @override
  void initState() {
    super.initState();
    _navigationViewModel = NavigationViewModel();
    _pages = [
      const DashboardPage(),
      null,
      ProfilePage(
        onTabSelected: (index) => _navigationViewModel.selectIndex(index),
      ),
    ];
  }

  Widget _pageForIndex(int index) {
    return _pages[index] ?? const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<NavigationState>(
        valueListenable: _navigationViewModel,
        builder: (context, state, _) {
          if (_pages[state.selectedIndex] == null) {
            switch (state.selectedIndex) {
              case 1:
                _pages[state.selectedIndex] = const HistoryPage();
                break;
              default:
                _pages[state.selectedIndex] = const SizedBox.shrink();
            }
          }

          return IndexedStack(
            index: state.selectedIndex,
            children: [_pageForIndex(0), _pageForIndex(1), _pageForIndex(2)],
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<NavigationState>(
        valueListenable: _navigationViewModel,
        builder: (context, state, _) {
          return BottomNav(
            selectedIndex: state.selectedIndex,
            onIndexChanged: (index) {
              _navigationViewModel.selectIndex(index);
            },
          );
        },
      ),
    );
  }
}
