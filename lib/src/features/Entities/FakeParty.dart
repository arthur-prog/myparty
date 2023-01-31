import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';

import 'package:flutter/material.dart';


part 'Party.g.dart';

CollectionReference partyCollection = FirebaseFirestore.instance.collection('partys');

const firestoreSerializable = JsonSerializable(
  converters: firestoreJsonConverters,
  // The following values could alternatively be set inside your `build.yaml`
  explicitToJson: true,
  createFieldMap: true,
);

@firestoreSerializable
class Party {
  Party({
    required this.name,
    required this.userId,
    required this.guests
  });

  factory Party.fromJson(Map<String, Object?> json) => _$PartyFromJson(json);

  final String name;
  final String userId;
  final Map<String, Object?> guests;


  Map<String, Object?> toJson() => _$PartyToJson(this);

  Future<void> addParty(){
    return partyCollection.add(toJson())
        .then((value) => print("Party Added"))
        .catchError((error) => print("Failed to add party: $error"));
  }
}




@firestoreSerializable
class Guest {
  Guest({
    required this.userId,
  });

  factory Guest.fromJson(Map<String, Object?> json) => _$GuestFromJson(json);

  final String userId;


  Map<String, Object?> toJson() => _$GuestToJson(this);
}

@Collection<Party>('partys')
final partysRef = PartyCollectionReference();


class PartysList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirestoreBuilder<PartyQuerySnapshot>(
        ref: partysRef,
        builder: (context, AsyncSnapshot<PartyQuerySnapshot> snapshot, Widget? child) {
          if (snapshot.hasError) return Text('Something went wrong!');
          if (!snapshot.hasData) return Text('Loading partys...');

          // Access the QuerySnapshot
          PartyQuerySnapshot querySnapshot = snapshot.requireData;

          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              // Access the Party instance
              Party party = querySnapshot.docs[index].data;
              Map<String, Object?> guests = party.guests;


              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  children: [
                    Text('Party name: ${party.name}, userid ${party.userId}'),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: guests.length,
                      itemBuilder: (context, index) {

                        // Access the User instance
                        Map<String, Object?> guestJson = guests[index.toString()] as Map<String, Object?>;
                        Guest guest = Guest.fromJson(guestJson);


                      return Text('Guest: ${guest.userId}');
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }
}