import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashi_client/src/services/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../services/models.dart';

Map<String, dynamic> _connectionConfiguration = {
  'iceServers': [
    {'url': 'stun:stun.l.google.com:19302'},
  ]
};

const _offerAnswerConstraints = {
  'mandatory': {
    'OfferToReceiveAudio': false,
    'OfferToReceiveVideo': false,
  },
  'optional': [],
};

class WebRtcProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;
  late RTCDataChannel _dataChannel;
  late RTCPeerConnection _connection;
  late RTCSessionDescription _sdp;
  String _serverKey = "";
  String _clientKey = "";
  RTCPeerConnectionState _state =
      RTCPeerConnectionState.RTCPeerConnectionStateNew;

  RTCPeerConnectionState get state => _state;

  Future<void> initPeerConnection() async {
    var device = await DeviceInfo().registry();
    _clientKey = device.key;

    var collection = _db.collection("users/${_user!.uid}/client");

    collection
        .where("client", isEqualTo: _clientKey)
        .where("createdAt", isGreaterThan: Timestamp.now())
        .snapshots()
        .listen((event) {
      for (var element in event.docChanges) {
        if (element.type != DocumentChangeType.added) {
          debugPrint("webrtc snapshots: ${element.type}");
          break;
        }

        var data = element.doc.data();
        debugPrint("webrtc snapshots: ${data!["type"]}");
        switch (data["type"]) {
          case "answer":
            var answer = WebRtcConnectionMark.fromJson(data!);
            debugPrint("connection_pool EVENT: ${answer.type} ${answer.sdp}");
            _connection.setRemoteDescription(
                RTCSessionDescription(answer.sdp, answer.type));
            break;
          case "ice":
            var ice = WebRtcIceCandidate.fromJson(data!);
            debugPrint(
                "Add ice candidate EVENT: ${ice.sdpMLineIndex} ${ice.sdpMid}");
            _connection.addCandidate(
                RTCIceCandidate(ice.candidate, ice.sdpMid, ice.sdpMLineIndex));
            break;
          default:
        }
      }
    });
  }

  Future<void> connect(Device device) async {
    _serverKey = device.key;
    await _createPerrConnection();
    await _createDataChannel();
    await _createOffer();
  }

  Future<void> disconnect() async {
    await _dataChannel.close();
    await _connection.close();
  }

  Future<void> send(String text) async {
    _dataChannel.send(RTCDataChannelMessage.fromBinary(
        Uint8List.fromList(utf8.encode(text))));
  }

  Future<void> _createPerrConnection() async {
    _connection = await createPeerConnection(_connectionConfiguration);

    // On local ice candidate add
    _connection.onIceCandidate = (candidate) {
      debugPrint("onIceCandidate: ${candidate.sdpMid}");

      var data = {
        "candidate": candidate.candidate,
        "sdpMLineIndex": candidate.sdpMLineIndex,
        "sdpMid": candidate.sdpMid,
        "type": "ice",
        "server": _serverKey,
        "client": _clientKey,
        "createdAt": FieldValue.serverTimestamp(),
      };
      _db.collection("users/${_user!.uid}/server").add(data);
    };

    // On data chanel open
    _connection.onDataChannel = (channel) {
      debugPrint("onDataChannel");
    };

    _connection.onConnectionState = (state) {
      _state = state;
      notifyListeners();
    };
  }

  Future<void> _createOffer() async {
    RTCSessionDescription offer =
        await _connection.createOffer(_offerAnswerConstraints);

    await _connection.setLocalDescription(offer);

    var data = {
      "sdp": offer.sdp,
      "type": offer.type,
      "server": _serverKey,
      "client": _clientKey,
      "createdAt": FieldValue.serverTimestamp(),
    };

    _db.collection("users/${_user!.uid}/server").add(data);
  }

  Future<void> _createDataChannel() async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit();
    debugPrint("onMessage ${_connection.toString()}");
    _dataChannel = await _connection.createDataChannel("data", dataChannelDict);

    _dataChannel.onMessage = (data) {
      debugPrint("onMessage ${data.text}");
    };

    _dataChannel.onDataChannelState = (state) {
      debugPrint("Data channel state: $state");
    };
  }
}
