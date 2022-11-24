import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Macro {
  String name;
  String code;
  Macro({this.name = '', this.code = ''});
  factory Macro.fromJson(Map<String, dynamic> json) => _$MacroFromJson(json);
  Map<String, dynamic> toJson() => _$MacroToJson(this);
}

@JsonSerializable()
class WebRtcConnectionMark {
  String sdp;
  String type;
  WebRtcConnectionMark({this.sdp = '', this.type = ''});
  factory WebRtcConnectionMark.fromJson(Map<String, dynamic> json) =>
      _$WebRtcConnectionMarkFromJson(json);
  Map<String, dynamic> toJson() => _$WebRtcConnectionMarkToJson(this);
}

@JsonSerializable()
class WebRtcIceCandidate {
  String candidate;
  int sdpMLineIndex;
  String sdpMid;
  WebRtcIceCandidate(
      {this.candidate = '', this.sdpMid = '', this.sdpMLineIndex = 0});
  factory WebRtcIceCandidate.fromJson(Map<String, dynamic> json) =>
      _$WebRtcIceCandidateFromJson(json);
  Map<String, dynamic> toJson() => _$WebRtcIceCandidateToJson(this);
}
