import 'package:firebase_data/Screens/Auth/Controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final AuthService auth = Get.put(AuthService());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passC,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final err = await auth.register(
                  emailC.text.trim(),
                  passC.text.trim(),
                );
                if (err != null) {
                  Get.snackbar('Error', err);
                } else {
                  Get.snackbar('Success', 'Account created');
                  Get.back();
                }
              },
              child: Text('Create Account'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Already have an account? Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
