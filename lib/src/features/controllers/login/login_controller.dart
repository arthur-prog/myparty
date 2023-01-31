import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';

class LoginController extends GetxController{
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  Rx<bool> isPasswordNotVisible = true.obs;

  void loginUser(String email, String password, BuildContext context){
    AuthenticationRepository.instance.signInWithEmailandPassword(email, password);
  }

  void changePasswordVisibility(){
    isPasswordNotVisible.value = !isPasswordNotVisible.value;
  }
}