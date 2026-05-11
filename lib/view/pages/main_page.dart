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
  // Add your ViewModel here
  final _navigationViewModel = NavigationViewModel(); 

  // Define your pages here in the same order as the items list
  final List<Widget> _pages = [
    const DashboardPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack maintains the state of all pages and only shows the selected one
      body: ValueListenableBuilder<NavigationState>(
        valueListenable: _navigationViewModel,
        builder: (context, state, _) {
          return IndexedStack(
            index: state.selectedIndex,
            children: _pages,
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