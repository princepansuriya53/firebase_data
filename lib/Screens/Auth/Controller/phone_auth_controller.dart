import 'package:firebase_data/Services/Firebase/phone_auth_services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PhoneAuthController extends GetxController {
  final PhoneAuthService _phoneAuthService = PhoneAuthService();
  RxBool isOtpSent = false.obs;
  TextEditingController phoneController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();
  RxString errorMessage = "".obs;

  // Send OTP
  Future<void> sendOtp() async {
    final phoneNumber = '+91 ${phoneController.text.trim()}';
    if (phoneNumber.isNotEmpty) {
      try {
        await _phoneAuthService.sendOtp(
          phoneNumber: phoneNumber,
          onSuccess: (verificationId, resendToken) {
            isOtpSent.value = true;
            Get.snackbar('OTP Sent', 'Please check your phone for the OTP');
          },
          onError: (error) {
            errorMessage.value = error;
            Get.snackbar('Error', error);
          },
        );
      } catch (e) {
        errorMessage.value = "Something went wrong: ${e.toString()}";
        Get.snackbar('Error', errorMessage.value);
      }
    } else {
      Get.snackbar('Error', 'Please enter a valid phone number');
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    final phoneNumber = '+91 ' + phoneController.text.trim();
    try {
      await _phoneAuthService.resendOtp(
        phoneNumber: phoneNumber,
        resendToken: 0, // Or use your logic to get the resend token
        onCodeSent: (verificationId, resendToken) {
          Get.snackbar('OTP Resent', 'Please check your phone for the OTP');
        },
      );
    } catch (e) {
      Get.snackbar('Error', "Failed to resend OTP: ${e.toString()}");
    }
  }

  // Verify OTP
  Future<void> verifyOtp() async {
    final smsCode = smsCodeController.text.trim();
    if (smsCode.isNotEmpty) {
      try {
        final error = await _phoneAuthService.verifyOtp(smsCode: smsCode);
        if (error == null) {
          Get.snackbar('Success', 'You have successfully signed in');
          // Navigate to the home screen or wherever necessary
        } else {
          Get.snackbar('Error', error);
        }
      } catch (e) {
        Get.snackbar('Error', "Error verifying OTP: ${e.toString()}");
      }
    } else {
      Get.snackbar('Error', 'Please enter the OTP');
    }
  }
}
