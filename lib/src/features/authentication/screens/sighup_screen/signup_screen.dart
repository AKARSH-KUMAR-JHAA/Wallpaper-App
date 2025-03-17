import 'package:flutter/material.dart';
import 'package:login/src/constants/animation_strings.dart';
import 'package:login/src/constants/text_strings.dart';
import 'package:login/src/features/authentication/screens/login_screen/login_screen.dart';
import 'package:login/src/features/authentication/screens/sighup_screen/footer_signup_widget.dart';
import 'package:lottie/lottie.dart';
import 'signup_form.dart';
import '../../../../common_widget/header_form_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(height: size.height,
            child: Stack(
              children: [
               // Positioned(top: 0, child: Lottie.asset(signupAni1,width: size.width)),
                Positioned(height: size.height*0.363, width: size.width, top: 0, child: header_form_widget(img:signupAni1 ,txt: onboardingheadline1,txt2: '')),
                Positioned(width: size.width, bottom: -35, child: Lottie.asset(loginAni3,fit: BoxFit.fitWidth)),
                Positioned(bottom: 185, width: size.width, child: form_field()),
                Positioned(width: size.width, bottom: 35, child: FooterSignupWidget(size:size,txt1: 'already have an account? ',txt2: 'login',screen: LoginScreen(),))

              ],
            ),
          ),

        ),
      ),
    );
  }
}



