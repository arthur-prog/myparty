import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:my_party/src/constants/colors.dart';
import 'package:my_party/src/constants/image_strings.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:image_picker/image_picker.dart';

import 'package:my_party/src/common_widgets/select_photo/select_photo_button.dart';
import 'package:my_party/src/features/controllers/profile/edit_profile_controller.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _auth = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());
  final controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    final _user = _auth.firebaseUser.value;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          AppLocalizations.of(context)!.editProfile,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: FutureBuilder(
                future: _userRepo.getUserById(_auth.firebaseUser.value!.uid),
                builder: (context, snapshot) {
                  print(_auth.firebaseUser.value!.uid);
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      U.User user = snapshot.data as U.User;
                      controller.birthDate.text = user.birthDate ?? "";
                      controller.firstName.text = user.firstName ?? "";
                      controller.lastName.text = user.lastName ?? "";
                      return Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: FutureBuilder<String>(
                                    future: _userRepo
                                        .getProfilPicture(_user?.uid ?? ""),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.hasData) {
                                        return Obx(
                                          () => controller.image.value == null
                                              ? CircleAvatar(
                                                  radius: 100,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data!),
                                                )
                                              : CircleAvatar(
                                                  radius: 100,
                                                  backgroundImage: FileImage(
                                                      controller.image.value!),
                                                ),
                                        );
                                      }
                                      return Obx(
                                            () => controller.image.value == null
                                            ? const CircleAvatar(
                                          radius: 100,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              profilePicture),
                                        )
                                            : CircleAvatar(
                                          radius: 100,
                                          backgroundImage: FileImage(
                                              controller.image.value!),
                                        ),
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
                                    LineAwesomeIcons.camera,
                                    color: isDark ? darkColor : lightColor,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectPhoto(
                                  onTap: () {
                                    controller.pickImage(ImageSource.gallery);
                                  },
                                  icon: Icons.image,
                                  textLabel: 'Browse Gallery',
                                  width:
                                      MediaQuery.of(context).size.width * 0.4),
                              const SizedBox(width: 10),
                              SelectPhoto(
                                onTap: () {
                                  controller.pickImage(ImageSource.camera);
                                },
                                icon: Icons.camera_alt_outlined,
                                textLabel: 'Use a Camera',
                                width: MediaQuery.of(context).size.width * 0.4,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),
                          Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: controller.firstName,
                                  decoration: InputDecoration(
                                    label: Text(AppLocalizations.of(context)!
                                        .firstName),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: controller.lastName,
                                  decoration: InputDecoration(
                                    label: Text(
                                        AppLocalizations.of(context)!.lastName),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: controller.birthDate,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    labelText:
                                        AppLocalizations.of(context)!.birthdate,
                                  ),
                                  readOnly: true,
                                  onTap: controller.selectDate,
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        controller.updateUser(user),
                                    child: Text(AppLocalizations.of(context)!
                                        .editProfile),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(TextSpan(
                                        text:
                                            "${AppLocalizations.of(context)!.memberSince} ",
                                        children: [
                                          TextSpan(
                                              text: _user != null
                                                  ? DateFormat.yMd().format(
                                                      _user.metadata
                                                          .creationTime!)
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .error,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))
                                        ])),
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent
                                                .withOpacity(0.2),
                                            elevation: 0,
                                            foregroundColor: Colors.red,
                                            side: BorderSide.none),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .delete),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return const Center(child: Text('Something went wrong'));
                    }
                  } else {
                    return const Center(
                        child: SpinKitFadingCube(color: primaryColor));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
