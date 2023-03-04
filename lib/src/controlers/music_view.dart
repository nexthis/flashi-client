import 'dart:math';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flashi_client/src/providers/webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

class MusicControl extends StatefulWidget {
  const MusicControl({super.key});

  static const routeName = '/controllers/music';

  @override
  State<MusicControl> createState() => _MusicControlState();
}

class _MusicControlState extends State<MusicControl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/test.png",
              fit: BoxFit.cover, alignment: Alignment.topCenter),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  Theme.of(context).colorScheme.background.withOpacity(0.5),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _onButtonClick("181");
                      },
                      iconSize: 40,
                      icon: const Icon(MdiIcons.music),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: () {
                        _onButtonClick("173");
                      },
                      iconSize: 40,
                      icon: const Icon(MdiIcons.volumeMute),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: () {
                        _onButtonClick("174");
                      },
                      iconSize: 40,
                      icon: const Icon(MdiIcons.volumeLow),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: () {
                        _onButtonClick("175");
                      },
                      iconSize: 40,
                      icon: const Icon(MdiIcons.volumeHigh),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                const _BaseNavigation()
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onButtonClick(String key) {
    context.read<WebRtcProvider>().send("key_press $key");
  }
}

class _BaseNavigation extends StatelessWidget {
  const _BaseNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                context.read<WebRtcProvider>().send("key_press 177");
              },
              iconSize: 35,
              icon: const Icon(MdiIcons.chevronLeft),
            ),
            IconButton(
              onPressed: () {
                context.read<WebRtcProvider>().send("key_press 179");
              },
              iconSize: 40,
              icon: Icon(Icons.play_arrow,
                  color: Theme.of(context).colorScheme.surface),
              style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary),
            ),
            IconButton(
              onPressed: () {
                context.read<WebRtcProvider>().send("key_press 176");
              },
              iconSize: 35,
              icon: const Icon(MdiIcons.chevronRight),
            ),
          ],
        ),
      ),
    );
  }
}
