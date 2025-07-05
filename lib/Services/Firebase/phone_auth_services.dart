import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? verificationId;

  // Send OTP
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await auth.signInWithCredential(credential);
            onSuccess("auto-verified", null);
          } catch (e) {
            onError("Auto sign-in failed: ${e.toString()}");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(mapFirebaseAuthError(e));
        },
        codeSent: (String verificationId, int? resendToken) async {
          this.verificationId = verificationId;
          onSuccess(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      onError(mapFirebaseAuthError(e));
    } catch (e) {
      onError("Something went wrong: ${e.toString()}");
    }
  }

  // Resend OTP
  Future<String?> resendOtp({
    required String phoneNumber,
    required int resendToken,
    required Function(String verificationId, int? resendToken) onCodeSent,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // handled below
        },
        codeSent: (String verificationId, int? newResendToken) {
          this.verificationId = verificationId;
          onCodeSent(verificationId, newResendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return mapFirebaseAuthError(e);
    } catch (e) {
      return "Something went wrong";
    }
  }

  // Verify OTP
  Future<String?> verifyOtp({required String smsCode}) async {
    try {
      if (verificationId == null) {
        return "Verification process has not started. Please try again.";
      }

      // Verify the OTP
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(
        credential,
      ); // Sign the user in with the credential

      // If successful, return null (signing in the user)
      return null; // success
    } on FirebaseAuthException catch (e) {
      // Return the error message if there's an exception related to Firebase Auth
      return mapFirebaseAuthError(e);
    } catch (e) {
      // If an error occurs that isn't related to FirebaseAuthException, print it
      // and return a general error message
      print('ERROR:--${e.toString()}'); // For debugging purposes
      return "Something went wrong: ${e.toString()}";
    }
  }

  // Get friendly error messages
  String mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return "The phone number entered is invalid.";
      case 'too-many-requests':
        return "Too many requests. Please try again later.";
      case 'invalid-verification-code':
        return "The code you entered is incorrect.";
      case 'session-expired':
        return "Session expired. Please request a new code.";
      case 'network-request-failed':
        return "Network error. Please check your connection.";
      default:
        return "Something went wrong";
    }
  }
}
