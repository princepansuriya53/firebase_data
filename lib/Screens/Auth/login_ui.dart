import 'package:firebase_data/Screens/Auth/Controller/auth_service.dart';
import 'package:firebase_data/Screens/Auth/number_login.dart';
import 'package:firebase_data/Screens/Auth/register_screen.dart';
import 'package:firebase_data/Screens/Chat/chat_room.dart';
import 'package:firebase_data/Services/Firebase/google_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginUi extends StatelessWidget {
  final AuthService authService = Get.put(AuthService());
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  LoginUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                /*   validator: (value) {
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
                }, */
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
                /* validator: (value) {
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
                }, */
              ),
              SizedBox(height: 80.h),
              ElevatedButton(
                onPressed: () {
                  authService
                      .login(email.text.trim(), password.text.trim())
                      .then((value) {
                        Get.to(() => ChatRoom());
                      });
                },
                child: Text('Login'),
              ),
              SizedBox(height: 80.h),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () => Get.to(() => RegisterScreen()),
              ),
              SizedBox(height: 50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    label: Text('Google Login'),
                    icon: Icon(Icons.g_mobiledata),
                    onPressed: () => googleSignIn(),
                  ),

                  ElevatedButton(
                    child: Text('Number Login'),
                    onPressed: () => Get.to(() => NumberScreen()),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                child: Text('sign Out'),
                onPressed: () => googleSignInInstance.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
