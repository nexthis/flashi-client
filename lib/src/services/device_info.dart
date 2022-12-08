import 'dart:convert';
import 'dart:io';

import 'package:flashi_client/src/services/models.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';

class DeviceInfo {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<Device> registry() async {
    if (Platform.isAndroid) {
      var info = await deviceInfo.androidInfo;

      var bytes = utf8.encode(info.fingerprint);
      var digest = sha256.convert(bytes);

      return Device(key: digest.toString(), name: info.display, os: "android");
    }

    if (Platform.isIOS) {
      var info = await deviceInfo.iosInfo;

      var bytes = utf8.encode("${info.utsname.machine} ${info.model}");
      var digest = sha256.convert(bytes);

      return Device(
          key: digest.toString(), name: info.name ?? "Ios system", os: "ios");
    }

    throw ErrorDescription("Current os is not supported");
  }
}
