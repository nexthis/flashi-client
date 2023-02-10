import 'package:flashi_client/src/controlers/mause_view.dart';
import 'package:flashi_client/src/controlers/music_view.dart';
import 'package:flashi_client/src/controlers/presentation_view.dart';
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
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        primary: false,
        children: const [ControlCard(), PresentationCard(), MusicCard()],
      ),
    );
  }
}

class PresentationCard extends StatelessWidget {
  const PresentationCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orangeAccent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(PresentationControl.routeName);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.co_present_rounded,
              size: 50,
            ),
            Text(
              "Presentation",
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }
}

class MusicCard extends StatelessWidget {
  const MusicCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purpleAccent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(MusicControl.routeName);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.video_settings_sharp,
              size: 50,
            ),
            Text(
              "Music",
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }
}

class ControlCard extends StatelessWidget {
  const ControlCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
