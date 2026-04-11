import 'package:flutter/material.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/constants/animation_strings.dart';
import 'package:luminawall/src/features/authentication/screens/login_screen/login_screen.dart';
import 'package:luminawall/src/features/authentication/screens/sighup_screen/footer_signup_widget.dart';
import 'package:luminawall/src/features/authentication/screens/sighup_screen/signup_header_widget.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/common_widget/jungle_loading_overlay.dart';
import 'package:luminawall/src/features/authentication/controller/signup_controller.dart';
import 'signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomAnimHeight = size.height * 0.25;
    final controller = Get.put(SignUpController());

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // 1. Prevent the background elements from being pushed up by the keyboard
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Depth
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark ? [
                    kJungleDeepGreen,
                    kJungleMossDark,
                  ] : [
                    Colors.white,
                    kJungleCream,
                  ],
                ),
              ),
            ),
          ),

          // Bottom Background Animation - Pinned strictly to the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Lottie.asset(
              loginAni3,
              fit: BoxFit.fitWidth,
              height: bottomAnimHeight,
            ),
          ),

          // Main Content
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                // 2. Account for keyboard manually so form stays scrollable
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                child: Column(
                  children: [
                    const SignupHeaderWidget(
                      img: loginAni2,
                      title: signupTitle,
                      subtitle: signupSubtitle,
                    ),
                    const SignupForm(),
                    FooterSignupWidget(
                      size: size,
                      txt1: alreadyHaveAccount,
                      txt2: login,
                      screen: const LoginScreen(),
                    ),
                    // Large spacer at the bottom
                    SizedBox(height: bottomAnimHeight * 0.2),
                  ],
                ),
              ),
            ),
          ),

          // Full Screen Loading Overlay
          Obx(() {
            if (controller.isLoading.value) {
              return const JungleLoadingOverlay(message: "Creating Account...");
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
