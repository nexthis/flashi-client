import 'package:flashi_client/src/components/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DashboardView'),
      ),
      body: Container(),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
