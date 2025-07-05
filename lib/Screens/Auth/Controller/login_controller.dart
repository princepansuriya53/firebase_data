import 'package:firebase_data/Services/Api/api_base_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      String userName = emailController.text.trim();
      String password = passwordController.text;

      ApiResponse response = await ApiService.postRequest(
        url: 'auth/login',
        body: {"username": userName, "password": password},
        isTokenRequired: false,
      );
      if (response.success) {
        print('Success Response : ${response.data}');
        /*  if (!authString.contains('ROLE_ADMIN') &&
              !authString.contains('ROLE_BROKER') &&
              authString.contains('ROLE_USER')) {
            idToken.value = response.data!['id_token'];
            await SharedPreferenceHelper.setString(
              SharedPreferenceHelper().idToken,
              idToken.value,
            );
            await SharedPreferenceHelper.setString(
              SharedPreferenceHelper().password,
              password,
            );
            Get.offAll(() => CustomNavigationBar()); */
      } else {
        // Get.snackbar("Fail", 'Invalid auth credential');
      }
    }
  }
}
