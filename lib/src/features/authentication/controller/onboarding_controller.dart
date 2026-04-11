import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import '../../../constants/animation_strings.dart';
import '../../../constants/colors_strings.dart';

import '../../../constants/text_strings.dart';
import '../models/onboarding_page_model.dart';
import '../screens/on_boarding_screen/onboarding_page_widget.dart';

class OnboardingController extends GetxController{
  final controller = LiquidController();
  RxInt currentpage = 0.obs;
  final pages = [
    OnboardingPageWidget(
      model: OnboardingPageModel(
        img: onboardingAni1,
        title: onboardingheadline1,
        subtitle: onboardingbody1,
        bgcolor: kJungleDeepGreen,
        visible: false,
      ),
    ),
    OnboardingPageWidget(
      model: OnboardingPageModel(
        img: onboardingAni2,
        title: onboardingheadline2,
        subtitle: onboardingbody2,
        bgcolor: kJungleForestGreen,
        visible: false,
      ),
    ),
    OnboardingPageWidget(
      model: OnboardingPageModel(
        img: onboardingAni3,
        title: onboardingheadline3,
        subtitle: onboardingbody3,
        bgcolor: kJungleMossDark,
        visible: true,
      ),
    ),
  ];
  int onPageChangedCallback(int activepageindex) => currentpage.value =activepageindex;
  dynamic skip() => controller.jumpToPage(page: 2);
}
