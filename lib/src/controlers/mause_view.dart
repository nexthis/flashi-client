import 'dart:math';

import 'package:flashi_client/src/providers/webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

class MouseControl extends StatefulWidget {
  const MouseControl({super.key});

  static const routeName = '/controlers/mause';

  @override
  State<MouseControl> createState() => _MouseControlState();
}

class _MouseControlState extends State<MouseControl> {
  final throttling = Throttling(duration: const Duration(milliseconds: 2));
  late Offset _lastPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control'),
      ),
      body: GestureDetector(
        onPanUpdate: ((details) =>
            throttling.throttle(() => _onPanUpdate(details, context))),
        onPanStart: _onPanStart,
        onDoubleTapDown: _onDoubleTapDown,
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details, BuildContext context) {
    double speedDx =
        (details.localPosition.dx.abs() - _lastPosition.dx.abs()) / 0.8;
    double speedDY =
        (details.localPosition.dy.abs() - _lastPosition.dy.abs()) / 0.8;

    double x = (details.localPosition.dx - _lastPosition.dx) + speedDx;
    double y = (details.localPosition.dy - _lastPosition.dy) + speedDY;
    debugPrint("speed: $speedDx $speedDY");

    //context.read<WebRtcProvider>().send("move_relative $x $y");
    _lastPosition = details.localPosition;
  }

  void _onDoubleTapDown(TapDownDetails details) {
    debugPrint("index: XDD");
  }

  void _onPanStart(DragStartDetails details) {
    _lastPosition = details.localPosition;
  }
}
