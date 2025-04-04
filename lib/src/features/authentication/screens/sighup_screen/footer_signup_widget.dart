import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/controller/login_controller.dart';

class FooterSignupWidget extends StatelessWidget {
  const FooterSignupWidget({super.key,
    required this.size,
    required this.txt1,
    required this.txt2,
    required this.screen

  });
  final Size size;
  final String txt1;
  final String txt2;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Padding(
      padding: const EdgeInsets.fromLTRB(15,0,15,0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('OR',style: Theme.of(context).textTheme.bodyLarge,),
            SizedBox(height: 65,width: size.width,
              child: OutlinedButton.icon(onPressed: () {
                controller.googleSignIn();
        
              }, icon: Image(image: AssetImage('assets/images/sign_up_images/R.png'),height: 23,),
                label: Text('SIGN IN WITH GOOGLE',style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            TextButton(onPressed: () {
              Get.offAll(()=>screen);
            },
              child: RichText(text: TextSpan(
                  style: Theme.of(context).textTheme.displaySmall,
                  children: [
                    TextSpan(text: txt1),
                    TextSpan(text: txt2.toUpperCase(),style: TextStyle(color: Colors.blue))
        
                  ]
              )),
            )
          ],
        ),
      ),
    );
  }
}
