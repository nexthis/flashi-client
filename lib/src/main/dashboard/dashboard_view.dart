import 'package:flashi_client/src/services/webrtc.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DashboardView'),
      ),
      body: Container(
        child: MaterialButton(
            onPressed: () async {
              var testService = WebRtcService();
              await testService.initPeerConnection();
              await testService.connect();
            },
            child: const Text("Test")),
      ),
    );
  }
}
