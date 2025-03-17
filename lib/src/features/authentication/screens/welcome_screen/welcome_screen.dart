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
        body: Stack(
          children: [
            Positioned(top: 0, child: Lottie.asset(welcomeAni1,height: size.height*0.3,fit: BoxFit.fitHeight),),
            Positioned(bottom: 370,width: size.width, child: SizedBox(height: size.height*0.27, child: Lottie.asset(welcomeAni3,fit: BoxFit.cover,)),),
            Positioned(bottom: 0, child: SizedBox(height: size.height*0.27, child: Lottie.asset(welcomeAni2,fit: BoxFit.cover)),),
            Positioned(top: 150,width: size.width,
              child: Center(
                child: Text(
                    welcomeheadline,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
              ),
            ),
            Positioned(bottom: 130,width: size.width, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                SizedBox(
                  width: size.width * 0.45,height: 65,
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
                  width: size.width * 0.45,height: 65,
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
            ),

          ],
        )
      ),
    );
  }
}
