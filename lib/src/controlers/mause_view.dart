import 'dart:math';

import 'package:flashi_client/src/providers/webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

class MouseControl extends StatefulWidget {
  const MouseControl({super.key});

  static const routeName = '/controllers/mouse';

  @override
  State<MouseControl> createState() => _MouseControlState();
}

class _MouseControlState extends State<MouseControl> {
  final _throttling = Throttling(duration: const Duration(milliseconds: 2));
  late Offset _lastPosition;
  int _lastTap = DateTime.now().millisecondsSinceEpoch;
  int _lastDoubleTap = DateTime.now().millisecondsSinceEpoch;
  int _consecutiveTaps = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control'),
      ),
      body: GestureDetector(
        onScaleUpdate: ((details) =>
            _throttling.throttle(() => _onScaleUpdate(details, context))),
        onScaleStart: _onScaleStart,
      ),
    );
  }

  void _onScaleUpdate(ScaleUpdateDetails details, BuildContext context) {
    double speedDx = (details.focalPoint.dx.abs() - _lastPosition.dx.abs()) /
        0.8; //0.8 = sensitive
    double speedDY = (details.focalPoint.dy.abs() - _lastPosition.dy.abs()) /
        0.8; //0.8 = sensitive

    double x = (details.focalPoint.dx - _lastPosition.dx) + speedDx;
    double y = (details.focalPoint.dy - _lastPosition.dy) + speedDY;
    //debugPrint("speed: $speedDx $speedDY");

    //context.read<WebRtcProvider>().send("move_relative $x $y");
    _lastPosition = details.focalPoint;
  }

  void _onScaleStart(ScaleStartDetails details) {
    int now = DateTime.now().millisecondsSinceEpoch;
    //check if user tap faster that 300ms
    if (now - _lastTap < 300) {
      _consecutiveTaps++;

      //Recognize is one or two fingers
      if (details.pointerCount >= 2) {
        _lastDoubleTap = DateTime.now().millisecondsSinceEpoch;
        _onDoubleTapTwoFingers(details);
      }
      if (_consecutiveTaps == 1 &&
          _lastDoubleTap - now < 300 &&
          details.pointerCount == 1) {
        _onDoubleTap(details);
      }

      //clear counter <- is good for now, remember to change this if you needed
      _consecutiveTaps = 0;
    } else {
      _consecutiveTaps = 0;
    }

    _lastPosition = details.focalPoint;
    _lastTap = now;
  }

  void _onDoubleTap(ScaleStartDetails details) {
    debugPrint("_onDoubleTap");
    // context.read<WebRtcProvider>().send("move_click left");
  }

  void _onDoubleTapTwoFingers(ScaleStartDetails details) {
    debugPrint("_onDoubleTapTwoFingers");
    // context.read<WebRtcProvider>().send("move_click right");
  }
}
