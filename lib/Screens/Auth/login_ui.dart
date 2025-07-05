import 'package:firebase_data/Screens/Auth/number_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:firebase_data/Screens/Auth/Controller/login_controller.dart';
import 'package:firebase_data/Services/Firebase/google_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginUi extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  LoginUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Form(
          key: loginController.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );

                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  controller: loginController.emailController,
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    final passwordRegex = RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
                    );

                    if (!passwordRegex.hasMatch(value)) {
                      return 'Password must be at least 8 characters,\ninclude upper & lower case letters and a number';
                    }
                    return null;
                  },
                  controller: loginController.passwordController,
                ),
                SizedBox(height: 80.h),
                ElevatedButton(
                  onPressed: () => loginController.login(),
                  child: Text('Login'),
                ),
                SizedBox(height: 50.h),
                Row(
                  children: [
                    Expanded(
                      child: SignInButton(
                        buttonSize: ButtonSize.small,
                        onPressed: () {
                          googleSignIn();
                        },
                        buttonType: ButtonType.google,
                      ),
                    ),
                    ElevatedButton(
                      child: Text('Number Login'),
                      onPressed: () => Get.to(() => NumberScreen()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
