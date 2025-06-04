import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/category_tab/category_tab.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/home_tab/home_tab.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/trending%20tab/trending_tab.dart';

import '../../../controller/sidebar_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index =1;
  @override
  Widget build(BuildContext context) {
    Get.put<MyDrawerController>(MyDrawerController());
    final screen = [
      CategoryTab(),
      HomeTab(),
      TrendingTab()
    ];

    final items = <Widget>[
      Icon(
        Icons.widgets,
        size: 40,
        color: Colors.black,
      ),
      Icon(
        Icons.eco,
        size: 40,
        color: Colors.black,
      ),
      Icon(
        Icons.local_fire_department,
        size: 40,
        color: Colors.black,
      ),
    ];
    return SafeArea(
        child: Scaffold(
          body: screen[index],
      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Curves.easeIn,
        animationDuration: Duration(milliseconds: 300),
          height: 60,
          index: index,
          onTap: (index) {setState(() => this.index =index);
          },
          items: items,
          backgroundColor: Colors.black,
          color: Colors.white,
          buttonBackgroundColor: Colors.orange),
    ));
  }
}
