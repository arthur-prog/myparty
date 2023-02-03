import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class FriendsController extends GetxController{
  static FriendsController get instance => Get.find();

  final _userRepo = Get.put(UserRepository());

  deleteFriend(U.User user, String thisUserId) async {
    final U.User? thisUser = await _userRepo.getUserById(thisUserId);
    await _userRepo.deleteFriend(user, thisUser!);
    await _userRepo.deleteFriendBack(user, thisUser);
  }
}