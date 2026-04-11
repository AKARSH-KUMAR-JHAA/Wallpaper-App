import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:luminawall/src/features/authentication/controller/bottom_nav_controller.dart';
import 'package:luminawall/src/features/authentication/controller/favorites_controller.dart';
import 'package:luminawall/src/features/authentication/controller/lifecycle_controller.dart';
import 'package:luminawall/src/features/authentication/controller/settings_controller.dart';
import 'package:luminawall/src/features/authentication/controller/sidebar_controller.dart';
import 'package:luminawall/src/features/authentication/controller/theme_controller.dart';
import 'package:luminawall/src/features/authentication/controller/trending_controller.dart';
import 'package:luminawall/src/features/authentication/controller/wallhaven_controller.dart';
import 'package:luminawall/src/features/authentication/controller/wallpaper_controller.dart';
import 'package:luminawall/src/features/authentication/controller/rating_controller.dart';
import 'package:luminawall/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:luminawall/src/repository/authentication_repository/authentication_repository.dart';
import 'package:luminawall/src/repository/user_repository/user_repository.dart';
import 'package:luminawall/src/utils/themes/theme.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

void main()  async  {

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Set preferred orientations if needed
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    Get.put(AuthenticationRepository());
    Get.put(UserRepository()); // Ensured UserRepository is put
    Get.put(BottomNavController()); // Persist bottom nav index
    Get.put(TrendingController()); // Global Community Trending
    Get.put(MyDrawerController());
    Get.put(WallpaperController());
    Get.put(WallhavenController());
    Get.put(FavoritesController());
    Get.put(ThemeController());
    Get.put(LifecycleController());
    Get.put(RatingController());
    Get.put(SettingsController());
  });
  // Initialize App Check for security (Attestation)
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
  // );
  
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
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      home: const SplashScreen(),
    );
  }
}
