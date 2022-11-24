import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'models.dart';

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

class WebRtcService {
  final _db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;
  late RTCDataChannel _dataChannel;
  late RTCPeerConnection _connection;
  late RTCSessionDescription _sdp;
  String _serverKey = "";

  Future<void> initPeerConnection() async {
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
        "client": "clientKey",
        "createdAt": FieldValue.serverTimestamp(),
      };
      _db.collection("users/${_user!.uid}/server").add(data);
    };

    // On data chanel open
    _connection.onDataChannel = (channel) {
      debugPrint("onDataChannel");
    };
  }

  Future<void> connect() async {
    _serverKey =
        "690a9efd319b827598386ce3be6eefd49a1fb01ed3d747426838859888b9b0fc";

    await _createDataChannel();
    await _createOffer();
    var collection = _db.collection("users/${_user!.uid}/client");

    collection
        .where("client", isEqualTo: "clientKey")
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

  Future<void> _createOffer() async {
    RTCSessionDescription offer =
        await _connection.createOffer(_offerAnswerConstraints);

    await _connection.setLocalDescription(offer);

    var data = {
      "sdp": offer.sdp,
      "type": offer.type,
      "server": _serverKey,
      "client": "clientKey",
      "createdAt": FieldValue.serverTimestamp(),
    };

    _db.collection("users/${_user!.uid}/server").add(data);
  }

  Future<void> _createDataChannel() async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit();
    _dataChannel = await _connection.createDataChannel("data", dataChannelDict);

    _dataChannel.onMessage = (data) {
      debugPrint("onMessage ${data.text}");
    };

    _dataChannel.onDataChannelState = (state) {
      debugPrint("Data channel state: $state");
    };
  }
}
