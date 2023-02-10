import 'dart:math';

import 'package:flashi_client/src/providers/webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

class PresentationControl extends StatefulWidget {
  const PresentationControl({super.key});

  static const routeName = '/controllers/presentationControl';

  @override
  State<PresentationControl> createState() => _PresentationControlState();
}

class _PresentationControlState extends State<PresentationControl> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presentation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: const [],
      ),
    );
  }
}
