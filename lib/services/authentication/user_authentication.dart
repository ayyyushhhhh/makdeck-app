import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthentication {
  static late FirebaseAuth _auth; //FirebaseAuth instance

  static void initFirebaseAuth() {
    _auth = FirebaseAuth.instance;
  }

  static String get getUserUid {
    return _auth.currentUser!.uid;
  }

  static String get getUserName {
    return _auth.currentUser!.displayName.toString();
  }

  static Stream<User?> get getUserStream {
    return _auth.authStateChanges().map((User? user) {
      if (user == null) {
        return null;
      } else {
        return user;
      }
    });
  }

  static bool isLoggedIn() {
    final User? user = _auth.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException {
      rethrow;
    }
  }
}
