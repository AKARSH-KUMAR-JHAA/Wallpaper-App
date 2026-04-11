import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.img,
    required this.title,
    required this.subtitle,
  });

  final String img;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * 0.28,
          child: Lottie.asset(img, fit: BoxFit.fitHeight),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? kJungleCream : kJungleGreen,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                  )
                ],
              ),
        ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? kJungleCream.withValues(alpha: 0.7) : kJungleDeepGreen.withValues(alpha: 0.7),
                  ),
            ),
          ),
      ],
    );
  }
}
