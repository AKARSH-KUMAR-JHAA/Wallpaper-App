import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/about_us_tab/about_us_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/favorites_tab/favorites_tab.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/notifications_tab/notifications_tab.dart';
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
  DateTime? lastPressedTime;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          // 1. Close drawer if open
          final controller = MyDrawerController.instance.zoomDrawerController;
          if (controller.isOpen != null && controller.isOpen!()) {
            MyDrawerController.instance.toggleDrawer();
            return;
          }

          // 2. Return to home tab if not already there
          if (currentItem != Menuitems.home) {
            setState(() {
              currentItem = Menuitems.home;
            });
            return;
          }

          // 3. Handle double-tap to exit
          final now = DateTime.now();
          final backButtonHasNotBeenPressedOrToastHasClosed =
              lastPressedTime == null ||
                  now.difference(lastPressedTime!) > const Duration(seconds: 2);

          if (backButtonHasNotBeenPressedOrToastHasClosed) {
            lastPressedTime = now;
            Fluttertoast.showToast(
              msg: "Tap back again to exit LuminaWall",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: kJungleDeepGreen.withValues(alpha: 0.95),
              textColor: kJungleCream,
              fontSize: 14.0,
            );
            return;
          }

          // Exit the app
          SystemNavigator.pop();
        },
        child: ZoomDrawer(
          menuBackgroundColor: isDark ? kJungleMossDark : kJungleCream,
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
          drawerShadowsBackgroundColor: isDark ? Colors.black26 : Colors.black12,
        ),
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
      case Menuitems.settings:
        return const SettingsTab();
      default:
        return BottomNavBar();
    }
  }
}
