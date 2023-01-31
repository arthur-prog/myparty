import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:my_party/src/constants/colors.dart';
import 'package:my_party/src/constants/image_strings.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:my_party/src/common_widgets/re_usable_select_photo_button.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _auth = Get.put(AuthenticationRepository());

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  File? _image;

  final _profilPictureRef =
      FirebaseStorage.instance.ref().child('profile_picture');

  String _userError = "";
  Map<String, bool> _errors = {};

  Future<void> _storeImage(String userId) async {
    final idProfilPictureRef = _profilPictureRef.child(userId);
    try {
      await idProfilPictureRef.putFile(_image!);
    } catch (e) {
      print("_storeImage error: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void displayUserError(bool isUserNameAvailable) {
    setState(() {
      _userError = "";
    });
    _errors["username"] = false;
    if (_usernameController.text != '') {
      if (!isUserNameAvailable) {
        setState(() {
          _userError = "This username is already used.";
        });
        _errors["username"] = true;
      }
    } else {
      setState(() {
        _userError = "You have to choose a username.";
      });
      _errors["username"] = true;
    }
  }

  bool checkUserErrors() {
    bool result = true;
    _errors.forEach((key, value) {
      if (value == true) {
        result = false;
      }
    });
    return result;
  }

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
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                // Stack(
                //   children: [
                //     SizedBox(
                //       width: 120,
                //       height: 120,
                //       child: FutureBuilder<String>(
                //           future: U.User.getProfilPicture(_user?.uid ?? ""),
                //           builder: (BuildContext context,
                //               AsyncSnapshot<String> snapshot) {
                //             if (snapshot.hasData) {
                //               return CircleAvatar(
                //                 backgroundImage: NetworkImage(snapshot.data!),
                //                 radius: 60.0,
                //               );
                //             }
                //             return const CircleAvatar(
                //               backgroundImage: NetworkImage(profilePicture),
                //               radius: 60.0,
                //             );
                //           }),
                //     ),
                //     Positioned(
                //       bottom: 0,
                //       right: 0,
                //       child: Container(
                //         width: 35,
                //         height: 35,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(100),
                //             color: primaryColor),
                //         child: Icon(
                //           LineAwesomeIcons.camera,
                //           color: isDark ? darkColor : lightColor,
                //           size: 20,
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                Center(
                    child: _image == null
                        ? const CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage('https://shop.prestige-distribution.fr/web/image/product.template/15336/image_1024?unique=2c4e4bd'),
                    )
                        : CircleAvatar(
                      radius: 100,
                      backgroundImage: FileImage(_image!),
                    )
                ),

                const SizedBox(height: 20),

                SelectPhoto(
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                  icon: Icons.image,
                  textLabel: 'Browse Gallery',
                ),

                const SizedBox(height: 20),

                SelectPhoto(
                  onTap: () {
                    _pickImage(ImageSource.camera);
                  },
                  icon: Icons.camera_alt_outlined,
                  textLabel: 'Use a Camera',
                ),

                const SizedBox(height: 50),

                Form(
                  child: Column(
                    children: [],
                  ),
                ),

                SizedBox(height: 20),

                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onChanged: (content) async {
                    displayUserError(await U.User.isUserNameAvailable(content));
                  },
                ),

                Text(
                  _userError,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 5),

                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                    controller: _dateController,
                    //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Enter Date"),
                    readOnly: true,
                    // when true user cannot edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1920),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    }),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    if (checkUserErrors()) {
                      _storeImage(_user!.uid);
                      U.User user = U.User(
                        userName: _usernameController.text,
                        email: _user.email!,
                        userId: _user.uid,
                        birthDate: _dateController.text,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                      );
                      await user.addUser();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LandingPage()),
                      // );
                    } else {
                      //everything not valid
                      print("errors");
                    }
                  },
                  child: const Text(
                    "Validate",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
