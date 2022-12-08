import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'device_info.dart';
import 'models.dart';

class DatabaseService {
  final db = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser;

  //List<Device>
  Future<List<Device>> deviceList() async {
    var result = List<Device>.empty(growable: true);

    final snapshot = await db.ref('status/${user!.uid}').get();
    if (!snapshot.exists) {
      return result;
    }

    var data = snapshot.children;

    for (var element in data) {
      var data = element.value as Map;
      var values = <String, dynamic>{};

      data.forEach((key, value) => values[key.toString()] = value);

      result.add(Device.fromJson(values));
    }

    return result;
  }
}
