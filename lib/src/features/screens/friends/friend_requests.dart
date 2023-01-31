import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  final _auth = Get.put(AuthenticationRepository());

  @override
  Widget build(BuildContext context) {
    final _user = _auth.firebaseUser.value;
    return Material(
      child: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users/${_user?.uid}/friendRequests")
                .snapshots(),
            builder: (context, snapshot) {
              List<Widget> children = [];
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  children = <Widget>[
                    Text("no friend requests"),
                  ];
                } else {
                  snapshot.data!.docs.forEach((doc) {
                    Map<String, dynamic> userJson = doc.data();
                    U.User user = U.User.fromMap(userJson);
                    children.add(
                        // Text(user.firstName)
                        Row(
                      children: <Widget>[
                        Text(user.userName),
                        TextButton(
                            onPressed: () async {
                              if (_user != null) {
                                final U.User? thisUser =
                                    await U.User.getUserById(_user.uid);

                                await thisUser!.addFriend(user);
                                await thisUser!.addBackFriend(user);
                                await thisUser!.deleteFriendRequest(user);
                              } else {
                                throw Exception("User is null");
                              }
                            },
                            child: Text("Accept")),
                        TextButton(
                            onPressed: () async {
                              if (_user != null) {
                                final U.User? thisUser =
                                    await U.User.getUserById(_user.uid);
                                await thisUser!.deleteFriendRequest(user);
                              } else {
                                throw Exception("User is null");
                              }
                            },
                            child: Text("Delete"))
                      ],
                    ));
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
            }),
      ),
    );
  }
}
