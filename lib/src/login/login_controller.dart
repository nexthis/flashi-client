import 'dart:developer';

import 'package:flashi_client/src/services/auth.dart';

class LoginController {
  LoginController(this._authService);

  final AuthService _authService;

  Future<void> login(String email, String password) async {
    log("dane: $email $password");
    try {
      await _authService.login(email, password);
    } on Exception catch (e) {
      log("błąd: ${e.hashCode}");
    }
  }
}
