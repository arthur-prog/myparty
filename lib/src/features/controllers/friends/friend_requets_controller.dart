import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class FriendRequestsController extends GetxController{
  static FriendRequestsController get instance => Get.find();

  final _userRepo = Get.put(UserRepository());

  acceptFriendRequest(U.User user, User _user) async {
    final U.User? thisUser =
    await _userRepo.getUserById(_user.uid);

    await _userRepo.addFriend(user, thisUser!);
    await _userRepo.addBackFriend(user, thisUser);
    await _userRepo.deleteFriendRequest(user, thisUser);
  }

  deleteFriendRequest(U.User user, User _user) async {
    final U.User? thisUser = await _userRepo.getUserById(_user.uid);
    await _userRepo.deleteFriendRequest(user, thisUser!);
  }

}