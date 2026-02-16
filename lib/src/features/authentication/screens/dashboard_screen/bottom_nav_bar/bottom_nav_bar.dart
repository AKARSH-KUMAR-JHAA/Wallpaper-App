import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:luminawall/src/features/authentication/screens/dashboard_screen/category_tab/category_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/home_tab/home_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/trending%20tab/trending_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/live_wallpapers_tab/live_wallpapers_tab.dart';

import '../../../../../constants/colors_strings.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index =1;
  @override
  Widget build(BuildContext context) {
    final screen = [
      CategoryTab(),
      HomeTab(),
      TrendingTab(),
      LiveWallpapersTab(),
    ];

    final items = <Widget>[
      Icon(
        Icons.widgets,
        size: 32,
        color: index == 0 ? Colors.white : kJungleEmerald.withValues(alpha: 0.7),
      ),
      Icon(
        Icons.eco,
        size: 32,
        color: index == 1 ? Colors.white : kJungleEmerald.withValues(alpha: 0.7),
      ),
      Icon(
        Icons.local_fire_department,
        size: 32,
        color: index == 2 ? Colors.white : kJungleEmerald.withValues(alpha: 0.7),
      ),
      Icon(
        Icons.movie_creation_rounded,
        size: 32,
        color: index == 3 ? Colors.white : kJungleEmerald.withValues(alpha: 0.7),
      ),
    ];
    return Scaffold(
      backgroundColor: kJungleMossDark,
      resizeToAvoidBottomInset: false,
      body: AnimatedSwitcher(
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
      bottomNavigationBar: CurvedNavigationBar(
          animationCurve: Curves.easeIn,
          animationDuration: const Duration(milliseconds: 300),
          height: 60,
          index: index,
          onTap: (index) {
            setState(() => this.index = index);
          },
          items: items,
          backgroundColor: Colors.transparent,
          color: kJungleDeepGreen.withValues(alpha: 0.95),
          buttonBackgroundColor: kJungleEmerald),
    );
  }
}
