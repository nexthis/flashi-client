import 'dart:developer';

import 'package:flashi_client/src/providers/webrtc.dart';
import 'package:flashi_client/src/services/auth.dart';

class LoginController {
  LoginController(this._authService);

  final AuthService _authService;

  Future<void> login(
      String email, String password, WebRtcProvider provider) async {
    log("dane: $email $password");
    try {
      await _authService.login(email, password);
      if (!provider.isInit) {
        provider.initPeerConnection();
      }
    } on Exception catch (e) {
      log("błąd: ${e.hashCode}");
    }
  }
}
