import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:my_party/src/features/Entities/Party.dart';
import 'package:my_party/src/features/screens/party/add_party.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';

class PartyScreen extends StatefulWidget {
  PartyScreen({
    Key? key,
  }) : super(key: key);

  User? user = FirebaseAuth.instance.currentUser;

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            IconButton(
              icon: const Icon(Icons.add),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddParty(user: widget.user!,)),
                );
              },
            ),

            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("partys").where('userId', isEqualTo: widget.user!.uid).snapshots(),
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
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(party.name),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(party.userId),
                                )
                              ],
                            )
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
            SizedBox(height: 100),
            Center(
              child: Text("Guested Parties"),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("partys").where('userId', isEqualTo: widget.user!.uid).snapshots(),
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
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(party.name),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(party.userId),
                                )
                              ],
                            )
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
