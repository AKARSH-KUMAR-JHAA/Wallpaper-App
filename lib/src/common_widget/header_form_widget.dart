import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class header_form_widget extends StatelessWidget {
  const header_form_widget({super.key,
    required this.img,
    required this.txt,
    required this.txt2,
  });

  final String img;
  final String txt;
  final String txt2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Lottie.asset(img,fit: BoxFit.fill),
        Text(txt,style: Theme.of(context).textTheme.headlineLarge,),
        Text(txt2,style: Theme.of(context).textTheme.bodyLarge,textAlign: TextAlign.center,)


      ],
    );
  }
}
