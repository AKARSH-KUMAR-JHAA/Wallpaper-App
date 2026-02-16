import 'package:flutter/material.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

class ForgetPassBtnWidget extends StatelessWidget {
  const ForgetPassBtnWidget({
    super.key,
    required this.size,
    required this.iconbtn,
    required this.title,
    required this.subtitle,
    required this.onTap

  });

  final Size size;
  final IconData iconbtn;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              iconbtn,
              size: 50,
              color: kJungleGreen,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                  )
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
