import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeaderFormWidget extends StatelessWidget {
  const HeaderFormWidget({super.key,
    required this.img,
    required this.txt,
    required this.txt2,
  });

  final String img;
  final String txt;
  final String txt2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Lottie.asset(img,fit: BoxFit.fitWidth),
        Text(txt,style: Theme.of(context).textTheme.headlineLarge,),



      ],
    );
  }
}
