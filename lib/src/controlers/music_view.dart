import 'dart:math';

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
        title: const Text('Music'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: const [],
      ),
    );
  }
}
