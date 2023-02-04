import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/common_widgets/profile_line/profile_line_widget.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/user_repository/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFriendsController extends GetxController {
  static AddFriendsController get instance => Get.find();

  TextEditingController usernameController = TextEditingController();
  StreamController<String> usernameStream = StreamController<String>();

  final _userRepo = Get.put(UserRepository());

  Future<void> addFriend(U.User user, User thisFireUser) async {
    final thisUser = await _userRepo.getUserById(thisFireUser.uid ?? "");
    await _userRepo.addFriendRequest(thisUser!, user);
  }

  FutureBuilder<List<String>> futureBuilderFriends(User? thisFireUser, AsyncSnapshot<List<U.User>> snapshotUsers) {
    return FutureBuilder(
      future: _userRepo.getFriendsId(thisFireUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshotFriends) {
        if (snapshotFriends.connectionState == ConnectionState.done) {
          if(snapshotFriends.hasData){
            return futureBuilderMyFriendRequests(thisFireUser, snapshotFriends.data!, snapshotUsers);
          } else {
            return futureBuilderMyFriendRequests(thisFireUser, [], snapshotUsers);
          }
        } else {
          return Container();
        }
      },
    );
  }

  FutureBuilder<List<String>> futureBuilderMyFriendRequests(User thisFireUser, List<String> friends, AsyncSnapshot<List<U.User>> snapshotUsers) {
    return FutureBuilder(
      future: _userRepo.getFriendRequestsId(thisFireUser.uid),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshotFriendRequests) {
        if (snapshotFriendRequests.connectionState == ConnectionState.done) {
          if(snapshotFriendRequests.hasData){
            return buildAddFriends(context, snapshotUsers.data!, thisFireUser, friends, snapshotFriendRequests.data!);
          } else {
            return buildAddFriends(context, snapshotUsers.data!, thisFireUser, friends, []);
          }
        } else {
          return Container();
        }
      },
    );
  }

  FutureBuilder<List<String>> futureBuilderHisFriendRequests(U.User user, User thisFireUser) {
    return FutureBuilder(
        future: _userRepo.getFriendRequestsId(user.userId),
        builder: (context, snapshotHisFriendRequests){
          if (snapshotHisFriendRequests.connectionState == ConnectionState.done) {
            if(snapshotHisFriendRequests.hasData){
              if (!snapshotHisFriendRequests.data!.contains(thisFireUser.uid)) { // check if I am in user's friendRequests
                return ProfileLineWidget(
                  user: user,
                  iconOnPressed: () => addFriend(user, thisFireUser),
                  icon: Icons.add,
                );
              } else {
                return ProfileLineWidget(
                  user: user,
                  icon: Icons.check,
                );
              }
            } else {
              return ProfileLineWidget(
                user: user,
                iconOnPressed: () => addFriend(user, thisFireUser),
                icon: Icons.add,
              );
            }
          } else {
            return Container();
          }
        }
    );
  }

  SingleChildScrollView buildAddFriends(
      BuildContext context,
      List<U.User> users,
      User thisFireUser,
      List<String> friendsId,
      List<String> friendRequestsId) {
    List<Widget> children = [];

    children.add(
      Text(
        AppLocalizations.of(context)!.addFriends,
        style: Theme.of(context).textTheme.headline4,
      ),
    );

    children.add(const SizedBox(height: 10.0));
    children.add(const Divider());

    users.forEach((user) {
      if (user.userId != thisFireUser.uid) {
        // don't show yourself
        if (!friendsId.contains(user.userId)) {
          // check if user is in friends
          if (!friendRequestsId.contains(user.userId)) {
            // check if user is in my friendRequests
            children.add(futureBuilderHisFriendRequests(user, thisFireUser));
            children.add(const Divider());
          }
        }
      }
    });
    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }
}
