import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/features/screens/home/home_screen.dart';
import 'package:my_party/src/features/screens/profile/profile.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class EditProfileController extends GetxController {
  static EditProfileController get instance => Get.find();

  final _userRepo = Get.put(UserRepository());

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController birthDate = TextEditingController();

  Rx<File?> image = Rx<File?>(null);

  final profilPictureRef = FirebaseStorage.instance.ref().child('profile_picture');

  void selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime(2000),
        firstDate: DateTime(1920),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate =
      DateFormat('yyyy-MM-dd').format(pickedDate);
      birthDate.text = formattedDate;
    } else {
      print("Date is not selected");
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final thisImg = await ImagePicker().pickImage(source: source);
      if (thisImg == null) return;
      File? img = File(thisImg.path);
      img = await cropImage(imageFile: img);
      image.value = img;
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(Get.context!).pop();
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
    await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Future<void> storeImage(String userId) async {
    final idProfilPictureRef = profilPictureRef.child(userId);
    try {
      await idProfilPictureRef.putFile(image.value!);
    } catch (e) {
      print("_storeImage error: $e");
    }
  }

  updateUser(U.User user) async {
    storeImage(user.userId);
    user.birthDate = birthDate.text;
    user.firstName = firstName.text;
    user.lastName = lastName.text;

    await _userRepo.updateUser(user);

    Get.to(() => const HomeScreen());
  }

  // void validate() async {
  //     _storeImage(_user!.uid);
  //     U.User user = U.User(
  //       userName: _usernameController.text,
  //       email: _user.email!,
  //       userId: _user.uid,
  //       birthDate: _dateController.text,
  //       firstName: _firstNameController.text,
  //       lastName: _lastNameController.text,
  //     );
  // }
}
