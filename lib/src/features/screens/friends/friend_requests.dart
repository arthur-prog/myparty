import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/common_widgets/profile_line/profile_line_widget.dart';

import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/features/controllers/friends/friend_requets_controller.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  final _auth = Get.put(AuthenticationRepository());
  final controller = Get.put(FriendRequestsController());

    @override
    Widget build(BuildContext context) {
      final _user = _auth.firebaseUser.value;
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users/${_user?.uid}/friendRequests")
              .snapshots(),
          builder: (context, snapshot) {
            List<Widget> children = [];
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                children.add(const Divider());
                children.add(Text(
                  AppLocalizations.of(context)!.friendRequests,
                  style: Theme.of(context).textTheme.headline4,
                ));
                children.add(const SizedBox(height: 10));
                snapshot.data!.docs.forEach((doc) {
                  Map<String, dynamic> userJson = doc.data();
                  U.User user = U.User.fromMap(userJson);
                  children.add(ProfileLineWidget(
                    user: user,
                    buttonTitle: AppLocalizations.of(context)!.accept,
                    buttonOnPressed: () => controller.acceptFriendRequest(user, _user!),
                    icon: Icons.delete_outlined,
                    iconOnPressed: () => controller.deleteFriendRequest(user, _user!),
                  ));
                });
                children.add(const Divider());
              }
            }
            return Column(
              children: children,
            );
          });
    }
  }
