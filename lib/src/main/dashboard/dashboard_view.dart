import 'package:flashi_client/src/widgets/connect_button.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const <Widget>[
          ConnectionButton(),
        ],
      ),
      body: Container(),
    );
  }
}
