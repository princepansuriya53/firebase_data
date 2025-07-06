// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
  }

  // register
  Future<String?> register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // login
  Future<String?> login(String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
            print('The RESPONSE OF LOGIN');

            Get.snackbar('Login Success', "${value.additionalUserInfo}");
          });
      return null;
    } on FirebaseAuthException catch (e) {
      print('---${e.message}');

      return e.message;
    }
  }

  // logout
  Future<void> logout() async {
    await auth.signOut();
  }
}
