import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/about_us_tab/about_us_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/favorites_tab/favorites_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/notifications_tab/notifications_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/rate_us_tab/rate_us_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/settings_tab/settings_tab.dart';
import 'package:luminawall/src/features/authentication/screens/profile_screen/profile_screen.dart';

import '../../../controller/sidebar_controller.dart';
import '../../../models/menu_item_model.dart';
import '../bottom_nav_bar/bottom_nav_bar.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'menu_screen.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  Menuitem currentItem = Menuitems.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        menuBackgroundColor: kJungleMossDark,

        menuScreenWidth: MediaQuery.of(context).size.width * 0.65,
        menuScreenOverlayColor: Colors.black.withValues(alpha: 0.5),
        menuScreenTapClose: true,
        mainScreenTapClose: true,
        angle: -12,
        controller: MyDrawerController.instance.zoomDrawerController,
        menuScreen: MenuScreen(
            currentItem: currentItem,
            onSelectedItem: (item) {
              setState(() {
                currentItem = item;
              });
              MyDrawerController.instance.toggleDrawer();
            }),
        mainScreen: getScreen(),
        borderRadius: 24.0,
        showShadow: true,
        drawerShadowsBackgroundColor: Colors.grey.shade800,
      ),
    );
  }

  Widget getScreen() {
    switch (currentItem) {
      case Menuitems.home:
        return BottomNavBar();
      case Menuitems.about:
        return const AboutUsTab();
      case Menuitems.favourites:
        return const FavoritesTab();
      case Menuitems.notifications:
        return const NotificationsTab();
      case Menuitems.profile:
        return ProfileScreen();
      case Menuitems.rate:
        return const RateUsTab();
      case Menuitems.settings:
        return const SettingsTab();
      default:
        return BottomNavBar();
    }
  }
}
