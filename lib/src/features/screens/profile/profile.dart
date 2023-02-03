import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:my_party/src/constants/colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_party/src/constants/image_strings.dart';
import 'package:my_party/src/features/screens/friends/friends.dart';
import 'package:my_party/src/features/screens/profile/edit_profile.dart';
import 'package:my_party/src/features/screens/profile/widgets/profile_menu.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class Profile extends StatefulWidget {
  Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final _user = _authRepo.firebaseUser.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: Theme.of(context).textTheme.headline2,
        ),
        actions: [
          IconButton(
              onPressed: () {
                AuthenticationRepository.instance.logOut();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: FutureBuilder<String>(
                        future: _userRepo.getProfilPicture(_user?.uid ?? ""),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done){
                            if (snapshot.hasData) {
                              return CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data!),
                                radius: 60.0,
                              );
                            }
                          }
                          return const CircleAvatar(
                            backgroundImage: NetworkImage(profilePicture),
                            radius: 60.0,
                          );
                        }),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: primaryColor),
                      child: Icon(
                        LineAwesomeIcons.alternate_pencil,
                        color: isDark ? darkColor : lightColor,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: _userRepo.getUserById(_user!.uid),
                builder: (BuildContext context, AsyncSnapshot<U.User?> snapshot) {
                  if (snapshot.hasData) {
                    U.User user = snapshot.data!;
                    return Column(
                      children: [
                        Text(
                          user.userName,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        user.firstName != "" && user.lastName != ""
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    user.firstName!,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  user.lastName!,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            )
                            : const SizedBox(),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const EditProfile()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: Text(AppLocalizations.of(context)!.editProfile),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              ProfileMenuWidget(
                title: AppLocalizations.of(context)!.friends,
                icon: LineAwesomeIcons.user_friends,
                onPress: () => Get.to(() => const Friends()),
              ),
              ProfileMenuWidget(
                title: AppLocalizations.of(context)!.settings,
                icon: LineAwesomeIcons.cog,
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
