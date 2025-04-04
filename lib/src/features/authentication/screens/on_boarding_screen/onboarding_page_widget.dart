import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:login/src/constants/text_strings.dart';
import 'package:login/src/features/authentication/screens/welcome_screen/welcome_screen.dart';
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
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: model.bgcolor,
        child: Padding(
          padding:  EdgeInsets.all(23),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(image: AssetImage(model.img),height: size.height *0.3,),
              Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(model.title,style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  Text(model.subtitle,style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30,),
                  Visibility(visible: model.visible,
                    child: SizedBox(height: size.height*0.08,width: size.width,
                      child: ElevatedButton(
                          onPressed:() {
                            Get.offAll(()=>WelcomeScreen());
                            final deviceStorage = GetStorage();
                            deviceStorage.write("IsFirstTime", false);
                          },
                          child: Center(child: Text(onboardingstart.toUpperCase(),style: Theme.of(context).textTheme.bodyMedium,))),
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
