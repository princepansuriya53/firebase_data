import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignInInstance = GoogleSignIn();

Future<UserCredential?> googleSignIn() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignInInstance
        .signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      UserCredential result = await FirebaseAuth.instance.signInWithCredential(
        authCredential,
      );
      print('---user-${result.user}');

      /* if (userExists == true) {
        Get.offAll(
          () => ChatRoomScreen(),
          transition: Transition.fadeIn,
          duration: Duration(milliseconds: 500),
        );
      } else {
        await Api().addUserData(userModel: userModel);
        Get.offAll(
          () => ChatRoomScreen(),
          transition: Transition.fadeIn,
          duration: Duration(milliseconds: 500),
        );
      } */

      return result;
    } else {
      return null;
    }
  } catch (e, t) {
    print('hello googleSignIn error ----- $e');
    print('hello googleSignIn trace ----- $t');
  }

  return null;
}
