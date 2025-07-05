import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_data/Screens/Auth/Controller/phone_auth_controller.dart';

class NumberScreen extends StatelessWidget {
  const NumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PhoneAuthController controller = Get.put(PhoneAuthController());

    return Scaffold(
      appBar: AppBar(title: Text('Phone Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.phoneController,
              decoration: InputDecoration(
                prefixText: '+91 ',
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: controller.smsCodeController,
              decoration: InputDecoration(labelText: 'SMS Code'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isOtpSent.value
                    ? () => controller.verifyOtp()
                    : () => controller.sendOtp(),
                child: Text(
                  controller.isOtpSent.value ? 'Verify & Sign In' : 'Send OTP',
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.resendOtp(),
              child: Text('Resend OTP'),
            ),
            Obx(() {
              if (controller.errorMessage.isNotEmpty) {
                return Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red),
                );
              }
              return Container();
            }),
          ],
        ),
      ),
    );
  }
}
