import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:luminawall/src/features/authentication/controller/onboarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:luminawall/src/constants/colors_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final obcontroller = OnboardingController();

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            liquidController: obcontroller.controller,
            slideIconWidget: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: kJungleEmerald,
                size: 20,
              ),
            ),
            enableLoop: false,
            pages: obcontroller.pages,
            onPageChangeCallback: obcontroller.onPageChangedCallback,
          ),
          Obx(
            () => Positioned(
                bottom: 30,
                child: AnimatedSmoothIndicator(
                  activeIndex: obcontroller.currentpage.value,
                  count: 3,
                  effect: const WormEffect(
                      dotColor: Colors.white24,
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: kJungleCream),
                )),
          ),
          Positioned(
              top: 50,
              right: 25,
              child: TextButton(
                onPressed: () => obcontroller.skip(),
                child: Text(
                  onboardingskip.toUpperCase(),
                  style: const TextStyle(
                    color: kJungleCream,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
