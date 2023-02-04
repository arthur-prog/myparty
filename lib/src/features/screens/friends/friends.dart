import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:my_party/src/common_widgets/profile_line/profile_line_widget.dart';
import 'package:my_party/src/constants/colors.dart';
import 'package:my_party/src/constants/image_strings.dart';

import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/features/controllers/friends/friends_controller.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_friend.dart';

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
    final controller = Get.put(FriendsController());
    final _auth = Get.put(AuthenticationRepository());
    final _user = _auth.firebaseUser.value;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).canvasColor,
              centerTitle: true,
              elevation: 0,
              title: Text(
                AppLocalizations.of(context)!.friends,
                style: Theme.of(context).textTheme.headline2,
              ),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, size: 30, color: isDark ? lightColor : darkColor,)),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(() => const AddFriend());
                    },
                    icon: Icon(Icons.add, size: 30, color: isDark ? lightColor : darkColor,)),
              ]
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("users/${_user?.uid}/friends").snapshots(),
                      builder: (context, snapshot) {
                        List<Widget> children = [];
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(AppLocalizations.of(context)!.noFriends)),
                            );
                          } else {
                            print(snapshot.data!.docs);
                            snapshot.data!.docs.forEach((doc) {
                              Map<String, dynamic> userJson = doc.data();
                              U.User user = U.User.fromMap(userJson);
                              children.add(
                                  ProfileLineWidget(user: user, buttonOnPressed: () => controller.deleteFriend(user, _user!.uid), buttonTitle: AppLocalizations.of(context)!.delete,)
                              );
                            });
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            );
                          }
                        } else {
                          children = <Widget>[
                            SpinKitFadingCube(
                              color: Theme.of(context).primaryColor,
                              size: 80.0,
                            ),
                          ];
                        }
                        return Container();
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
