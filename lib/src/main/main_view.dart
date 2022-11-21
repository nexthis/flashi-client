import 'package:flashi_client/src/main/dashboard/dashboard_view.dart';
import 'package:flashi_client/src/main/macros/macros_view.dart';
import 'package:flashi_client/src/main/settings/settings_view.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const routeName = '/';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  final screes = [
    const DashboardView(),
    const MacrosView(),
    const SettingsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color PrimaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: screes,
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner),
              label: 'Macros',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: PrimaryColor,
          onTap: _onItemTapped,
        ));
  }
}
