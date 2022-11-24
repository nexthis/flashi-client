// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Macro _$MacroFromJson(Map<String, dynamic> json) => Macro(
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );

Map<String, dynamic> _$MacroToJson(Macro instance) => <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
    };

WebRtcConnectionMark _$WebRtcConnectionMarkFromJson(
        Map<String, dynamic> json) =>
    WebRtcConnectionMark(
      sdp: json['sdp'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$WebRtcConnectionMarkToJson(
        WebRtcConnectionMark instance) =>
    <String, dynamic>{
      'sdp': instance.sdp,
      'type': instance.type,
    };

WebRtcIceCandidate _$WebRtcIceCandidateFromJson(Map<String, dynamic> json) =>
    WebRtcIceCandidate(
      candidate: json['candidate'] as String? ?? '',
      sdpMid: json['sdpMid'] as String? ?? '',
      sdpMLineIndex: json['sdpMLineIndex'] as int? ?? 0,
    );

Map<String, dynamic> _$WebRtcIceCandidateToJson(WebRtcIceCandidate instance) =>
    <String, dynamic>{
      'candidate': instance.candidate,
      'sdpMLineIndex': instance.sdpMLineIndex,
      'sdpMid': instance.sdpMid,
    };
