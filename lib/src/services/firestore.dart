import 'package:flashi_client/src/services/models.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'device_info.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<List<Macro>> macros() async {
    var collection = await db.collection("users/${user!.uid}/macros").get();

    var data = collection.docs.map((s) => s.data());

    var result = data.map((e) => Macro.fromJson(e));

    return result.toList();
  }

  Future<void> registry() async {
    var device = await DeviceInfo().registry();
    var doc = db.doc("users/${user!.uid}/devices/${device.key}");

    doc.set(device.toJson());
  }
}
