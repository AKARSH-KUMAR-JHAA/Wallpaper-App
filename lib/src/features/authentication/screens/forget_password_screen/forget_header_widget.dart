import 'package:flutter/material.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

class ForgetHeaderWidget extends StatelessWidget {
  const ForgetHeaderWidget({
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
        Image.asset(
          img,
          height: size.height * 0.25,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30),
        Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
        ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? kJungleCream.withValues(alpha: 0.6) : kJungleDeepGreen.withValues(alpha: 0.6),
                  ),
            ),
          ),
      ],
    );
  }
}
