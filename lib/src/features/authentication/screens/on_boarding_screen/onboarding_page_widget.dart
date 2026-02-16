import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:luminawall/src/features/authentication/screens/welcome_screen/welcome_screen.dart';
import '../../models/onboarding_page_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  const OnboardingPageWidget({
    super.key,
    required this.model,
  });

  final OnboardingPageModel model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: model.bgcolor,
      body: Stack(
        children: [
          // Lottie Background
          Positioned.fill(
            child: Lottie.asset(
              model.img,
              fit: BoxFit.cover,
            ),
          ),
          // Subtle Dark Overlay for Text Readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      model.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: kJungleCream,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      model.subtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: kJungleCream.withValues(alpha: 0.9),
                            fontSize: 17,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    if (model.visible)
                      SizedBox(
                        height: 60,
                        width: size.width * 0.8,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kJungleEmerald,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 10,
                            ),
                            onPressed: () {
                              Get.offAll(() => WelcomeScreen());
                              final deviceStorage = GetStorage();
                              deviceStorage.write("IsFirstTime", false);
                            },
                            child: Center(
                                child: Text(
                              onboardingstart.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ))),
                      ),
                    const SizedBox(height: 40), // Space for indicator
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
