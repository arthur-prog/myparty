import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

final partysCollection = FirebaseFirestore.instance.collection('partys');

class Party {
  late String id;
  String userId;
  String name;
  List<String> guestList;

  Party({
    required this.userId,
    required this.name,
    required this.guestList,
  });

  factory Party.fromMap(Map<String, dynamic> map) {
    return Party(
        userId: map['userId'],
        name: map['name'],
        guestList: List<String>.from(map['guestList']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'guestList': guestList,
    };
  }

  Future<void> addParty(){
    final partyDoc = partysCollection.doc();
    return partyDoc.set(toMap())
        .then((value) => print("Party Added"))
        .catchError((error) => print("Failed to add party: $error"));
  }
}
