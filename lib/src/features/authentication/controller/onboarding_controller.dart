import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import '../../../constants/colors_strings.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';
import '../models/onboarding_page_model.dart';
import '../screens/on_boarding_screen/onboarding_page_widget.dart';

class OnboardingController extends GetxController{
  final controller = LiquidController();
  RxInt currentpage = 0.obs;
  final pages = [
    OnboardingPageWidget(model: OnboardingPageModel(
      img: onboardingimage1,
      title: onboardingheadline1,
      subtitle: onboardingbody1,
      bgcolor: onboardingbg1,
        visible: false
    )),
    OnboardingPageWidget(model: OnboardingPageModel(
      img: onboardingimage2,
      title: onboardingheadline2,
      subtitle: onboardingbody2,
      bgcolor: onboardingbg2,
      visible: false
    )),
    OnboardingPageWidget(model: OnboardingPageModel(
      img: onboardingimage3,
      title: onboardingheadline3,
      subtitle: onboardingbody3,
      bgcolor: onboardingbg3,
      visible: true
    )),

  ];
  onPageChangedCallback(int activepageindex) => currentpage.value =activepageindex;
  skip() => controller.jumpToPage(page: 2);
}
