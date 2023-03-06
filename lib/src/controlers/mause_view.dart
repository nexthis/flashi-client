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
  final TextEditingController _editingController = TextEditingController();
  late FocusNode _node;
  late Offset _lastPosition;
  int _lastLength = 0;
  bool isShowKeyboard = false;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(debugLabel: 'TextArea');
    _editingController.addListener(() {
      _onKeyPress();
    });
    _node.addListener(() {
      if (_node.hasFocus) {
        return;
      }
      _editingController.clear();
      _lastLength = 0;

      setState(() {
        isShowKeyboard = !isShowKeyboard;
      });
    });
  }

  @override
  void dispose() {
    _throttling.close();
    _node.dispose();
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control'),
        actions: <Widget>[
          IconButton(onPressed: () => true, icon: const Icon(Icons.settings)),
          IconButton(onPressed: () => true, icon: const Icon(Icons.fullscreen)),
          IconButton(
              onPressed: () {
                _editingController.clear();
                setState(() {
                  isShowKeyboard = !isShowKeyboard;
                });
                _node.requestFocus();
              },
              icon: const Icon(Icons.keyboard)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
              visible: isShowKeyboard,
              child: TextField(
                focusNode: _node,
                controller: _editingController,
              )),
          Expanded(
            child: GestureDetector(
              onScaleUpdate: ((details) =>
                  _throttling.throttle(() => _onScaleUpdate(details, context))),
              onScaleStart: _onScaleStart,
              onTap: () {
                _onButtonClick("left");
              },
              onDoubleTap: () {
                _onButtonClick("right");
              },
            ),
          ),
          _bottomNavigation(context),
        ],
      ),
    );
  }

  Widget _bottomNavigation(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Material(
              color: Theme.of(context).colorScheme.onPrimary,
              child: InkWell(
                onTapDown: (details) {
                  _onButtonDown('left');
                },
                onTapUp: (details) {
                  _onButtonUp('left');
                },
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Material(
              color: Theme.of(context).colorScheme.primary,
              child: InkWell(
                onTapDown: (details) {
                  _onButtonDown('middle');
                },
                onTapUp: (details) {
                  _onButtonUp('middle');
                },
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: Material(
              color: Theme.of(context).colorScheme.onPrimary,
              child: InkWell(
                onTapDown: (details) {
                  _onButtonDown('right');
                },
                onTapUp: (details) {
                  _onButtonUp('right');
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onScaleUpdate(ScaleUpdateDetails details, BuildContext context) {
    if (details.pointerCount == 2) {
      debugPrint("speed: ${details.scale}");
      return;
    }

    _mouseMove(details);
  }

  void _mouseMove(ScaleUpdateDetails details) {
    // double speedDx = (details.focalPoint.dx - _lastPosition.dx).abs() *
    //     0.3; //0.3 = sensitive
    // double speedDY = (details.focalPoint.dy - _lastPosition.dy).abs() *
    //     0.3; //0.3 = sensitive

    double speed = max((details.focalPoint.dx - _lastPosition.dx).abs(),
            (details.focalPoint.dy - _lastPosition.dy).abs()) *
        0.4;

    int x = ((details.focalPoint.dx - _lastPosition.dx) * speed).round();
    int y = ((details.focalPoint.dy - _lastPosition.dy) * speed).round();

    debugPrint("speed: $speed x: $x y: $y");
    if (x == 0 && y == 0) {
      return;
    }
    context.read<WebRtcProvider>().send("move_relative $x $y");
    _lastPosition = details.focalPoint;
  }

  void _onButtonDown(String key) {
    context.read<WebRtcProvider>().send("mouse_down $key");
  }

  void _onButtonUp(String key) {
    context.read<WebRtcProvider>().send("mouse_up $key");
  }

  void _onButtonClick(String key) {
    context.read<WebRtcProvider>().send("mouse_click $key");
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastPosition = details.focalPoint;
  }

  void _onKeyPress() {
    Characters characters = _editingController.text.characters;

    debugPrint("value: $_lastLength ${characters.length}");

    if (_lastLength > characters.length) {
      context.read<WebRtcProvider>().send('key_press backspace');
    } else {
      context.read<WebRtcProvider>().send('typing "${characters.last}"');
    }

    _lastLength = characters.length;
  }
}
