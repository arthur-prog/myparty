import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/features/screens/friends/add_friend.dart';
import 'package:my_party/src/features/screens/friends/friend_requests.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class Friends extends StatefulWidget {
  const Friends({
    Key? key,
  }) : super(key: key);


  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {

  @override
  Widget build(BuildContext context) {

    final _userRepo = Get.put(UserRepository());
    final _auth = Get.put(AuthenticationRepository());
    final _user = _auth.firebaseUser.value;

    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users/${_user?.uid}/friends").snapshots(),
                builder: (context, snapshot) {
                  List<Widget> children = [];
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      children = <Widget>[
                        Text("no friends"),
                      ];
                    } else {
                      snapshot.data!.docs.forEach((doc) {
                        Map<String, dynamic> userJson = doc.data();
                        U.User user = U.User.fromMap(userJson);
                        children.add(
                            Row(
                              children: <Widget>[
                                Text(user.userName),
                                TextButton(
                                    onPressed: () async {
                                      if(_user != null){
                                        final U.User? thisUser = await _userRepo.getUserById(_user.uid);
                                        await _userRepo.deleteFriend(user, thisUser!);
                                        await _userRepo.deleteFriendBack(user, thisUser);
                                      } else {
                                        throw Exception("User is null");
                                      }
                                    },
                                    child: Text("Delete")
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
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFriend()),
                );
              },
              child: Text("add friend"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendRequests()),
                );
              },
              child: Text("friend requests"),
            ),
          ],
        ),
      ),
    );
  }
}
