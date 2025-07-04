import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:login/firebase_options.dart';
import 'package:login/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:login/src/repository/authentication_repository/authentication_repository.dart';
import 'package:login/src/utils/themes/theme.dart';

void main()  async  {

  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value)=>Get.put(AuthenticationRepository()));
  await FirebaseAppCheck.instance.activate(

    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),

    androidProvider: AndroidProvider.debug,


  );
  runApp(const Login());
  
}
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {

    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GAppTheme.lightTheme,
      darkTheme: GAppTheme.darkTheme,
      themeMode: ThemeMode.system,
     // defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 500),
      home: SplashScreen(),

    );
  }
}


