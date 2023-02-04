import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:my_party/src/common_widgets/profile_line/profile_line_widget.dart';
import 'package:my_party/src/constants/colors.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/features/controllers/friends/add_friends_controller.dart';
import 'package:my_party/src/features/screens/friends/friend_requests.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({
    Key? key,
  }) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final _auth = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());
  final controller = Get.put(AddFriendsController());

  @override
  void initState() {
    controller.usernameController.addListener(() {
      controller.usernameStream.add(controller.usernameController.text);
    });
    super.initState();
  }

  void dispose() {
    controller.usernameStream.close();
    controller.usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thisFireUser = _auth.firebaseUser.value;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, size: 30, color: isDark ? lightColor : darkColor,)),
          title: Text(
            AppLocalizations.of(context)!.addFriends,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.username,
                  ),
                ),

                const FriendRequests(),

                const SizedBox(height: 20.0),

                StreamBuilder(
                  stream: controller.usernameStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      String usernameSearched = snapshot.data!;
                      return FutureBuilder(
                        future: _userRepo.getUsersStartsByUsername(usernameSearched),
                        builder: (context, snapshotUsers){
                          if(snapshotUsers.connectionState == ConnectionState.done){
                            if (snapshotUsers.hasData){
                              return controller.futureBuilderFriends(thisFireUser, snapshotUsers);
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text(AppLocalizations.of(context)!.noUsers)),
                              );
                            }
                          }
                          return Container();
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
