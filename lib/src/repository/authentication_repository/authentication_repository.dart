import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_party/src/features/screens/home/home_screen.dart';
import 'package:my_party/src/features/screens/profile/profile.dart';
import 'package:my_party/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:my_party/src/features/screens/welcome/welcome.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _userRepo = Get.put(UserRepository());
  final _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const WelcomeScreen()) : Get
        .offAll(() => const HomeScreen());
  }

  void createUserWithEmailandPassword(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      U.User user = U.User(
          email: email,
          userName: username,
          userId: userCredential.user!.uid);
      _userRepo.addUser(user);
      // firebaseUser.value?.sendEmailVerification();
      firebaseUser.value == null ? Get.offAll(() => const WelcomeScreen()) : Get
          .offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure(e.code);
      Get.snackbar("Failed", ex.message);
    }
    catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      Get.snackbar("Failed", ex.message);
    }
  }

  void signInWithEmailandPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value == null ? Get.offAll(() => const WelcomeScreen()) : Get
          .offAll(() => Profile());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Failed", e.message ?? e.code);
    }
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      firebaseUser.value == null ? Get.offAll(() => const WelcomeScreen()) : Get
          .offAll(() => Profile());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Failed", e.message ?? e.code);
    }
  }

  void sendResetPasswordMail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Succes", "Email sent");
    } on Exception catch (e) {
      Get.snackbar("Failed", e.toString());
    }
  }

  Future<void> logOut() async => await _auth.signOut();
}