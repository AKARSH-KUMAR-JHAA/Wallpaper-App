import 'package:flutter/material.dart';
import 'package:login/src/constants/animation_strings.dart';
import 'package:login/src/constants/text_strings.dart';
import 'package:login/src/features/authentication/screens/login_screen/login_screen.dart';
import 'package:login/src/features/authentication/screens/sighup_screen/signup_screen.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: SizedBox(height: size.height*1,
            child: Stack(
                    children: [
            Positioned(
              top: 0,
              child: Lottie.asset(welcomeAni1,
                  height: size.height * 0.27, fit: BoxFit.fitHeight),
            ),
            Positioned(
              bottom: 510, width: 400,
              child: SizedBox(
                  height: size.height * 0.1,
                  child: Lottie.asset(
                    welcomeAni3,
                    fit: BoxFit.cover,
                  )),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                  height: size.height * 0.27,
                  child: Lottie.asset(welcomeAni2, fit: BoxFit.cover)),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                Center(
                  child: Text(
                    welcomeheadline,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                SizedBox(height: 440,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: size.width * 0.45,
                      height: 65,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                          child: Text(
                            login.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    ),
                    SizedBox(
                      width: size.width * 0.45,
                      height: 65,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ));
                          },
                          child: Text(
                            signup.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    )
                  ],
                ),
              ],
            ),
                    ],
                  ),
          )),
    );
  }
}
