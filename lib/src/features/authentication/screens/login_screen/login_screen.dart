import 'package:flutter/material.dart';
import 'package:login/src/common_widget/header_form_widget.dart';
import 'package:login/src/constants/animation_strings.dart';
import 'package:login/src/features/authentication/screens/login_screen/login_form.dart';
import 'package:login/src/features/authentication/screens/sighup_screen/footer_signup_widget.dart';
import 'package:login/src/features/authentication/screens/sighup_screen/signup_screen.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(height: size.height,
            child: Stack(
              children: [
                Positioned(width: size.width,height: size.height*0.43, top: 0, child: HeaderFormWidget(txt: 'Login Here',img: loginAni2,txt2: '')),
                Positioned(top: 320,width: size.width, child: Loginform(size: size)),
                Positioned(width: size.width, bottom: -35, child: Lottie.asset(loginAni3,fit: BoxFit.fitWidth)),
                Positioned(bottom: 90,width: size.width, child: FooterSignupWidget(size: size, txt1: "Don't have an Account? ", txt2: "Signup", screen: SignupScreen())),
                Positioned(top: 190,right: -20, child: Lottie.asset(loginAni1,height: size.height*0.26,width: size.width*0.35,fit: BoxFit.fill))

              ],
            ),
          ),
        ),
      ),
    );
  }
}

