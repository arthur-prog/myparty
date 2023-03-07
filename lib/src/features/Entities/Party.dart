import 'package:cloud_firestore/cloud_firestore.dart';

class Party {
  late String id;
  String userId;
  String name;
  List<String> guestList;
  GeoPoint? location;
  String? date;

  Party(
      {required this.userId,
      required this.name,
      required this.guestList,
      this.location,
      this.date});

  factory Party.fromMap(Map<String, dynamic> map) {
    return Party(
        userId: map['userId'],
        name: map['name'],
        guestList: List<String>.from(map['guestList']),
        location: map["location"] != null
            ? GeoPoint(map['location'].latitude, map['location'].longitude)
            : null,
        date: map['date'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'guestList': guestList ?? [],
      'location': location,
      'date': date ?? ""
    };
  }
}
