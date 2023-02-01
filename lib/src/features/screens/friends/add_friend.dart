import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({
    Key? key,
  }) : super(key: key);


  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {

  final TextEditingController _usernameController = TextEditingController();
  final _auth = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    final _user = _auth.firebaseUser.value;
    return Material(
      child: SafeArea(
        child: Container(
          child: Column(
            children: <Widget> [

              IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),

              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),

              TextButton(
                onPressed: () async {
                  U.User? user = await _userRepo.getUserByUsername(_usernameController.text);
                  if (user?.userId == _user?.uid){
                    print("this user");
                  } else if(user != null){
                    U.User? thisUser = await _userRepo.getUserById(_user?.uid ?? "");
                    // if (notInFriendList){
                    //   if (userKey == -1){
                        await _userRepo.addFriendRequest(thisUser!, user);
                    //   } else {
                    //     print("already in the friend Requests");
                    //   }
                    // } else {
                    //   print("already in the friend list");
                    // }
                  } else {
                    print("user null");
                  }
                },
                child: const Text(
                  "Add Friend",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
