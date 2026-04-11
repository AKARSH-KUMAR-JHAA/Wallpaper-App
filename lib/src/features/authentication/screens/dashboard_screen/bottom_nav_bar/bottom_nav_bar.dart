import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/controller/bottom_nav_controller.dart';

import 'package:luminawall/src/features/authentication/screens/dashboard_screen/category_tab/category_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/home_tab/home_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/trending%20tab/trending_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/live_wallpapers_tab/live_wallpapers_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/games_tab/games_tab.dart';

import '../../../../../constants/colors_strings.dart';


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navControl = Get.find<BottomNavController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final screen = [
      CategoryTab(),
      HomeTab(),
      TrendingTab(),
      LiveWallpapersTab(),
      GamesTab(),
    ];

    return Obx(() {
      final index = navControl.currentIndex.value;
      
      final items = <Widget>[
        Icon(
          Icons.widgets,
          size: 32,
          color: index == 0 ? Colors.white : (isDark ? kJungleEmerald : kJungleGreen).withValues(alpha: 0.7),
        ),
        Icon(
          Icons.eco,
          size: 32,
          color: index == 1 ? Colors.white : (isDark ? kJungleEmerald : kJungleGreen).withValues(alpha: 0.7),
        ),
        Icon(
          Icons.local_fire_department,
          size: 32,
          color: index == 2 ? Colors.white : (isDark ? kJungleEmerald : kJungleGreen).withValues(alpha: 0.7),
        ),
        Icon(
          Icons.movie_creation_rounded,
          size: 32,
          color: index == 3 ? Colors.white : (isDark ? kJungleEmerald : kJungleGreen).withValues(alpha: 0.7),
        ),
        Icon(
          Icons.videogame_asset_rounded,
          size: 32,
          color: index == 4 ? Colors.white : (isDark ? kJungleEmerald : kJungleGreen).withValues(alpha: 0.7),
        ),
      ];

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: PopScope(
          canPop: index == 1,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            navControl.changeIndex(1);
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOutQuart,
            switchOutCurve: Curves.easeInOutQuart,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(index),
              child: screen[index],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: CurvedNavigationBar(
              animationCurve: Curves.easeIn,
              animationDuration: const Duration(milliseconds: 300),
              height: 60,
              index: index,
              onTap: (newIndex) {
                navControl.changeIndex(newIndex);
              },
              items: items,
              backgroundColor: Colors.transparent,
              color: isDark ? kJungleDeepGreen.withValues(alpha: 0.95) : kJungleCream.withValues(alpha: 0.95),
              buttonBackgroundColor: isDark ? kJungleEmerald : kJungleGreen),
        ),
      );
    });
  }
}
