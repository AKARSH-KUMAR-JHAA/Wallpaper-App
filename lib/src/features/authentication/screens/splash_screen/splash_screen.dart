
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login/src/constants/animation_strings.dart';
import 'package:login/src/repository/authentication_repository/authentication_repository.dart';
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
    Timer(Duration(milliseconds: 5350),(){
      AuthenticationRepository.instance.screenRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: SizedBox(height: 400, child: Lottie.asset(splashAni1,fit: BoxFit.cover))
      ),
    );
  }
}
