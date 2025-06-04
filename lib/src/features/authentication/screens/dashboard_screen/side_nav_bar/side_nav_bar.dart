import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/controller/sidebar_controller.dart';
import 'package:login/src/features/authentication/models/menu_item_model.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/side_nav_bar/menu_screen.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  Menuitem currentItem = Menuitems.Home;

  @override
  Widget build(BuildContext context) {
    Get.put<MyDrawerController>(MyDrawerController());
    return SafeArea(
      child: Scaffold(
        body: ZoomDrawer(
          menuBackgroundColor: Colors.indigo,
          angle: -12,
          controller: MyDrawerController.instance.zoomDrawerController,
          menuScreen: MenuScreen(
              currentItem: currentItem,
              onSelectedItem: (item) {
                setState(() {
                  currentItem = item;
                });
              }),
          mainScreen: getScreen(),
          borderRadius: 24.0,
          showShadow: true,
          drawerShadowsBackgroundColor: Colors.grey,
        ),
      ),
    );
  }
  Widget getScreen{
  switch(currentItem) {
  case Menuitems.Home:

  }
}

}
