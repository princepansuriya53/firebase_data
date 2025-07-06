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
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  prefixText: '+91 ',
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                enabled: !controller.isOtpSent.value,
              ),
              SizedBox(height: 20.h),

              if (controller.isOtpSent.value) ...[
                TextField(
                  controller: controller.smsCodeController,
                  decoration: InputDecoration(
                    labelText: 'SMS Code',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),
              ],

              ElevatedButton(
                onPressed: controller.isOtpSent.value
                    ? controller.verifyOtp
                    : controller.sendOtp,
                child: Text(
                  controller.isOtpSent.value ? 'Verify & Sign In' : 'Send OTP',
                ),
              ),

              if (controller.isOtpSent.value) ...[
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.resendOtp,
                  child: Text('Resend OTP'),
                ),
              ],

              if (controller.errorMessage.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
