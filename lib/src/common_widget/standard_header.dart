


import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../constants/colors_strings.dart';
import '../features/authentication/controller/sidebar_controller.dart';

class StandardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const StandardHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Attempt to find MyDrawerController, fallback if not found
    MyDrawerController? drawerController;
    try {
      drawerController = Get.find<MyDrawerController>();
    } catch (_) {}

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => drawerController?.toggleDrawer(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kJungleEmerald.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_rounded,
                  size: 28,
                  color: kJungleEmerald,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: kJungleCream,
                          fontSize: 20,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!.toUpperCase(),
                        style: TextStyle(
                          color: kJungleEmerald.withValues(alpha: 0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 44), // Balanced alignment for center title
          ],
        ),
      ),
    );
  }
}
