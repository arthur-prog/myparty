import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final UserCredential _userCredential;

  //sign in with email and password
  Future<dynamic> signInWithMail(email, password) async{
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return _userCredential = userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.code;
    }
  }

  //sign in with google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    print('signed in with google');

    // Once signed in, return the UserCredential
    final userCredential = await _auth.signInWithCredential(credential);
    return _userCredential = userCredential;
  }

  FirebaseAuth getFirebaseAuth(){
    return _auth;
  }

  UserCredential getUserCredential() {
    return _userCredential;
  }

  //sign out
  Future signOut() async{
    _auth.signOut();
  }
}