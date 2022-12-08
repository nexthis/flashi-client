import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashi_client/src/services/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

import '../providers/webrtc.dart';
import '../services/database.dart';

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<WebRtcProvider>();
    if (value.state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
      return IconButton(
        icon: const Icon(Icons.close),
        color: Colors.red,
        onPressed: () {
          value.disconnect();
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.connect_without_contact),
        color: Colors.green,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return _dialogList(context);
              });
        },
      );
    }
  }

  Widget _dialogList(BuildContext context) {
    return Dialog(
      child: FutureBuilder<List<Device>>(
        future: DatabaseService().deviceList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const FractionallySizedBox(
              heightFactor: 0.7,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const FractionallySizedBox(
              heightFactor: 0.7,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            var devices = snapshot.data!;
            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Select device",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        var item = devices[index];
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.os),
                          // leading: const Icon(Icons.computer),
                          trailing: Icon(Icons.connected_tv_rounded,
                              color: (item.active ?? false)
                                  ? Colors.green
                                  : Colors.red),
                          onTap: (item.active ?? false)
                              ? () {
                                  Navigator.pop(context);
                                  context.read<WebRtcProvider>().connect(item);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return _dialogConnect(context, item);
                                      });
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"),
                  )
                ],
              ),
            );
          } else {
            return const Text('No device found in account. Check your pc app');
          }
        },
      ),
    );
  }

  Widget _dialogConnect(BuildContext context, Device device) {
    final value = context.watch<WebRtcProvider>();
    String text = "Waiting";
    if (value.state ==
        RTCPeerConnectionState.RTCPeerConnectionStateConnecting) {
      text = "Connecting";
    }
    if (value.state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
      text = "Failed";
    }
    if (value.state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
      text = "Connected";
    }

    return Dialog(
      child: Text(text),
    );
  }
}
