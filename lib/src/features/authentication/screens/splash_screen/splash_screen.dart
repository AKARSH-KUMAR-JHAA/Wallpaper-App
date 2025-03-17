
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login/src/features/authentication/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4),(){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnBoardingScreen(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: Lottie.asset("assets/animation/splashscreen.json",)
      ),
    );
  }
}
