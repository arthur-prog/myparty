import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_party/src/features/Entities/Party.dart';
import 'package:my_party/src/features/screens/party/add_party/add_party_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_party/src/features/screens/party/party_widget.dart';

class PartyScreen extends StatelessWidget {
  PartyScreen({
    Key? key,
  }) : super(key: key);

  User? user = FirebaseAuth.instance.currentUser;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            IconButton(
              icon: const Icon(Icons.add),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddParty()),
                );
              },
            ),

            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("partys").where('userId', isEqualTo: user!.uid).snapshots(),
                builder: (context, snapshot) {
                  List<Widget> children = [];
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      children = <Widget>[
                        Text("no partys"),
                      ];
                    } else {
                      snapshot.data!.docs.forEach((doc) {
                        Map<String, dynamic> partyJson = doc.data();
                        Party party = Party.fromMap(partyJson);
                        children.add(
                            PartyWidget(party: party)
                        );
                      });
                    }
                  } else {
                    children = <Widget>[
                      SpinKitFadingCube(
                        color: Theme.of(context).primaryColor,
                        size: 80.0,
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                }
            ),
            const SizedBox(height: 100),
            const Center(
              child: Text("Guested Parties"),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("partys").where('userId', isEqualTo: user!.uid).snapshots(),
                builder: (context, snapshot) {
                  List<Widget> children = [];
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      children = <Widget>[
                        Text("no partys"),
                      ];
                    } else {
                      snapshot.data!.docs.forEach((doc) {
                        Map<String, dynamic> partyJson = doc.data();
                        Party party = Party.fromMap(partyJson);
                        children.add(
                            PartyWidget(party: party)
                        );
                      });
                    }
                  } else {
                    children = <Widget>[
                      SpinKitFadingCube(
                        color: Theme.of(context).primaryColor,
                        size: 80.0,
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
