import 'package:flashi_client/src/controlers/mause_view.dart';
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
      body: GridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        primary: false,
        children: [
          _controlCard(context),
          const Card(
            color: Colors.orangeAccent,
            child: Text("asd"),
          ),
          const Card(
            color: Colors.purpleAccent,
            child: Text("asd"),
          ),
        ],
      ),
    );
  }

  Widget _controlCard(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(MouseControl.routeName);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mouse,
              size: 50,
            ),
            Text(
              "Control",
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }
}
