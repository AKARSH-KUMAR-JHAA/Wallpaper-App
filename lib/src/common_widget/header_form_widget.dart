import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeaderFormWidget extends StatelessWidget {
  const HeaderFormWidget({
    super.key,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width,
          height: size.height * 0.2, // Slightly reduced to ensure buttons move up more easily
          child: Lottie.asset(img, fit: BoxFit.fitWidth),
        ),
        const SizedBox(height: 5),
        Text(
          txt,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (txt2.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              txt2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),
      ],
    );
  }
}
