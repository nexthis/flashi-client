import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<UserCredential> login(String email, String password) async {
    var test = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    debugPrint('movieTitle: $test');

    return test;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
