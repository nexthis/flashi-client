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
  bool isShowKeyboard = false;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(debugLabel: 'TextArea');
    _editingController.addListener(() {
      final TextEditingValue value = _editingController.value;
      _onKeyPress(value);
    });
    _node.addListener(() {
      if (_node.hasFocus) {
        return;
      }
      _editingController.clear();
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
              onTap: _onLeftButtonClick,
              onDoubleTap: _onRightButtonClick,
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
                onTap: _onLeftButtonClick,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Material(
              color: Theme.of(context).colorScheme.primary,
              child: InkWell(
                onTap: _onMiddleButtonClick,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: Material(
              color: Theme.of(context).colorScheme.onPrimary,
              child: InkWell(
                onTap: _onRightButtonClick,
              ),
            ),
          )
        ],
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
    debugPrint("speed: $speedDx $speedDY");

    context.read<WebRtcProvider>().send("move_relative $x $y");
    _lastPosition = details.focalPoint;
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastPosition = details.focalPoint;
  }

  void _onLeftButtonClick() {
    context.read<WebRtcProvider>().send("move_click left");
  }

  void _onMiddleButtonClick() {
    context.read<WebRtcProvider>().send("move_click middle");
  }

  void _onRightButtonClick() {
    context.read<WebRtcProvider>().send("move_click right");
  }

  void _onKeyPress(TextEditingValue value) {
    debugPrint("value: ${value.text[value.text.length - 1]}");
    context
        .read<WebRtcProvider>()
        .send("press ${value.text[value.text.length - 1]}");
  }
}
