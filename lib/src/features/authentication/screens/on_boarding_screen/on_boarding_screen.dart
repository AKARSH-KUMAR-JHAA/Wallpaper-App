import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:login/src/constants/text_strings.dart';
import 'package:login/src/features/authentication/controller/onboarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final obcontroller = OnboardingController();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            LiquidSwipe(
              liquidController: obcontroller.controller,
              slideIconWidget: Container(
                  height: 800,
                  width: 40,
                  decoration: ShapeDecoration(
                      shape: CircleBorder(), color: Colors.white38),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              enableLoop: false,
              pages: obcontroller.pages,
              onPageChangeCallback: obcontroller.onPageChangedCallback,
            ),
            Obx(
              () => Positioned(
                  bottom: 15,
                  child: AnimatedSmoothIndicator(
                    activeIndex: obcontroller.currentpage.value,
                    count: 3,
                    effect: WormEffect(
                        dotColor: Colors.black,
                        dotHeight: 8,
                        activeDotColor: Colors.white),
                  )),
            ),
            Positioned(
                top: 20,
                right: 20,
                child: InkWell(
                  child: Text(
                    onboardingskip,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  onTap: () {
                    obcontroller.skip();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
