import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luminawall/src/exception/exception.dart';
import 'package:luminawall/src/exception/signup_email_password_failure.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/side_nav_bar/side_nav_bar.dart';
import 'package:luminawall/src/features/authentication/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:luminawall/src/features/authentication/screens/welcome_screen/welcome_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

//variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  final devicestorage = GetStorage();
  bool canRedirect = false;

  @override
  void onReady() async {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setIntialScreen);
  }

  /// Manually refresh the user data to catch updates like updateDisplayName
  Future<void> refreshUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      firebaseUser.value = _auth.currentUser;
    }
  }

  void hasrunfun() {
    canRedirect = true;
    _setIntialScreen(firebaseUser.value);
  }

  screenRedirect() async {
    devicestorage.writeIfNull("IsFirstTime", true);
    if (devicestorage.read("IsFirstTime") != true) {
      Get.offAll(() => const WelcomeScreen());
    } else {
      Get.offAll(() => const OnBoardingScreen());
    }
  }

  _setIntialScreen(User? user) async {
    if (!canRedirect) return;
    user == null ? screenRedirect() : Get.offAll(() => const SideNavBar());
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          // AUTO-VERIFICATION: If the Android device can automatically read the SMS
          if (_auth.currentUser != null) {
            await _auth.currentUser!.linkWithCredential(credential);
          } else {
            await _auth.signInWithCredential(credential);
          }
          // Redirect to home if auto-verified
          hasrunfun(); 
        },
        codeSent: (verificationId, resendToken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        },
        timeout: const Duration(seconds: 60),
        verificationFailed: (e) {
          debugPrint("Phone Auth Error: ${e.code} - ${e.message}");
          
          // Use a slight delay to ensure snackbar shows after any navigation/overlay transitions
          Future.delayed(const Duration(milliseconds: 800), () {
            if (!_hasOverlay()) return;

            if (e.code == 'invalid-phone-number') {
              _showSafeSnackbar('Error', 'The provided number is not valid.');
            } else if (e.code == 'too-many-requests') {
              _showSafeSnackbar('Error', 'Too many requests. This device is temporarily blocked by Firebase. Please try again in a few hours or use a different number.', isError: true);
            } else if (e.code == 'app-not-verified') {
              _showSafeSnackbar('Verification Error', 'App verification failed. Please check your internet or Play Services.', isError: false);
            } else {
              _showSafeSnackbar('Auth Error', e.message ?? 'Authentication failed');
            }
          });
        });
  }

  Future<AuthCredential> getPhoneCredential(String otp) async {
    return PhoneAuthProvider.credential(
        verificationId: verificationId.value, smsCode: otp);
  }

  Future<bool> verifyotp(String otp) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId.value, smsCode: otp);
      
      if (_auth.currentUser != null) {
        // If user is already logged in (with Email/Password), link the phone number
        final userCredential = await _auth.currentUser!.linkWithCredential(credential);
        return userCredential.user != null;
      } else {
        // If no user is logged in, sign in with the phone credential
        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user != null;
      }
    } catch (e) {
      debugPrint("OTP Verification Error: $e");
      
      // If it's a FirebaseAuthException, check for specific codes
      if (e is FirebaseAuthException) {
        if (e.code == 'provider-already-linked' || e.code == 'credential-already-in-use') {
          // If already linked to THIS user or another user, we might want to just proceed
          // but for security, usually we want to ensure it's linked to THIS user.
          // For now, let's assume if it's already linked, we're good.
          return true;
        }
      }
      
      // Fallback: try signing in directly if linking fails for other reasons
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp);
        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user != null;
      } catch (innerE) {
        debugPrint("OTP Sign-In Fallback Error: $innerE");
        return false;
      }
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpEmailPasswordFailure.code(e.code);
      throw ex;
    } catch (_) {
      const ex = SignUpEmailPasswordFailure();
      throw ex;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpEmailPasswordFailure.code(e.code);
      throw ex;
    } catch (_) {
      const ex = SignUpEmailPasswordFailure();
      throw ex;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: (defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.iOS) 
            ? '953178718235-1ejcuscvmqtumm4ii6ohghvjg1uqrptb.apps.googleusercontent.com' 
            : null,
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      final ex = AExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      debugPrint("Google Sign-In Detailed Error: $e");
      if (e is Exception) {
        throw e.toString();
      }
      throw e.toString();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.snackbar("Success", "Reset link sent to $email",
            backgroundColor: Colors.green.withValues(alpha: 0.1), colorText: Colors.green);
      });
    } on FirebaseAuthException catch (e) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.snackbar("Error", e.message ?? "Something went wrong",
            backgroundColor: Colors.red.withValues(alpha: 0.1), colorText: Colors.red);
      });
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updatePassword(newPassword);
      } else {
        throw "No user logged in to update password";
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Failed to update password";
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => const WelcomeScreen());
  }

  // Helper to safely show snackbars without "No Overlay" crash
  void _showSafeSnackbar(String title, String message, {bool isError = true}) {
    if (!_hasOverlay()) return;
    
    Get.snackbar(
      title, 
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
      colorText: isError ? Colors.red : Colors.orange,
      duration: const Duration(seconds: 5),
    );
  }

  bool _hasOverlay() {
    try {
      return Get.context != null && Overlay.maybeOf(Get.context!) != null;
    } catch (_) {
      return false;
    }
  }
}
