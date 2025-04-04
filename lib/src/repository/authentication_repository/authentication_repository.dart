import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/src/exception/exception.dart';
import 'package:login/src/exception/signup_email_password_failure.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:login/src/features/authentication/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:login/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:login/src/features/authentication/screens/welcome_screen/welcome_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

//variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  final devicestorage = GetStorage();

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setIntialScreen);
  }
  screenRedirect()async{
    devicestorage.writeIfNull("IsFirstTime", true);
    devicestorage.read("IsFirstTime")!= true ? Get.offAll(()=>WelcomeScreen()) : Get.offAll(()=>OnBoardingScreen());
  }

  _setIntialScreen(User? user) {
    user == null
        ? Get.offAll(() => const SplashScreen())
        : Get.offAll(() => const BottomNavBar());
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        codeSent: (verificationId, resendToken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        },
        timeout: Duration(seconds: 60),
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar('Error', 'The provided number is not valid');
          } else {
            Get.snackbar('Error', 'Something went wrong. Try again later!');
          }
        });
  }

  Future<bool> verifyotp(String otp) async {
    var credential = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credential.user != null ? true : false;
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const BottomNavBar())
          : Get.offAll(() => WelcomeScreen());
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
      firebaseUser.value != null
          ? Get.offAll(() => const BottomNavBar())
          : Get.offAll(() => WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpEmailPasswordFailure.code(e.code);
      throw ex;
    } catch (_) {
      const ex = SignUpEmailPasswordFailure();
      throw ex;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = AExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = AExceptions();
      throw ex.message;
    }
  }
  Future<void>logout() async {
   await _auth.signOut();
   Get.offAll(WelcomeScreen());
  }

}
