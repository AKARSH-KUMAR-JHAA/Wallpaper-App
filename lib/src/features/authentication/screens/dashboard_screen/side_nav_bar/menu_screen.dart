import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luminawall/src/features/authentication/models/menu_item_model.dart';
import 'package:luminawall/src/repository/authentication_repository/authentication_repository.dart';
import 'package:luminawall/src/features/authentication/controller/profile_controller.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

class Menuitems {
  static const profile = Menuitem(profileTitle, Icons.person);
  static const home = Menuitem(homeTitle, Icons.home);
  static const favourites = Menuitem(favoritesTitle, Icons.favorite);
  static const notifications = Menuitem(notificationsTitle, Icons.notifications_active);
  static const settings = Menuitem(settingsTitle, Icons.settings);
  static const rate = Menuitem(rateUsTitle, Icons.star_rate_rounded);
  static const about = Menuitem(aboutUsTitle, Icons.book);

  static const all = <Menuitem>[
    profile,
    home,
    favourites,
    notifications,
    settings,
    rate,
    about
  ];
}

class MenuScreen extends StatelessWidget {
  final Menuitem currentItem;
  final ValueChanged<Menuitem> onSelectedItem;
  const MenuScreen(
      {super.key, required this.currentItem, required this.onSelectedItem});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;
    final profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: kJungleMossDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kJungleMossDark,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // User Profile Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Obx(() {
                  final firestoreUser = profileController.userModel.value;
                  final currentUser = authRepo.firebaseUser.value; // Access reactively inside Obx
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kJungleEmerald.withValues(alpha: 0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: kJungleEmerald.withValues(alpha: 0.1),
                              blurRadius: 15,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: kJungleEmerald,
                          backgroundImage: currentUser?.photoURL != null
                              ? NetworkImage(currentUser!.photoURL!)
                              : null,
                          child: currentUser?.photoURL == null
                              ? Builder(
                                  builder: (context) {
                                    final name = firestoreUser?.fullName ?? currentUser?.displayName ?? currentUser?.email ?? "U";
                                    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "U";
                                    return Text(
                                      initial,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        (firestoreUser?.fullName ?? currentUser?.displayName ?? "Lumina Explorer").toUpperCase(),
                        style: const TextStyle(
                          color: kJungleCream,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        firestoreUser?.email ?? currentUser?.email ?? "PREMIUM NATURE MEMBER",
                        style: TextStyle(
                          color: kJungleEmerald.withValues(alpha: 0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 10),

              // Menu Items
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...Menuitems.all.map((item) => buildMenuItem(context, item)),
                      ],
                    ),
                  ),
                ),
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: TextButton.icon(
                  onPressed: () {
                    AuthenticationRepository.instance.logout();
                    GoogleSignIn().signOut();
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.white54),
                  label: const Text(
                    "LOGOUT",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, Menuitem item) {
    final isSelected = currentItem == item;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isSelected ? kJungleEmerald.withValues(alpha: 0.15) : Colors.transparent,
      ),
      child: ListTile(
        selected: isSelected,
        minLeadingWidth: 20,
        leading: Icon(
          item.icon,
          color: isSelected ? kJungleEmerald : kJungleCream.withValues(alpha: 0.4),
          size: 24,
        ),
        title: Text(
          item.title.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : kJungleCream.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        onTap: () => onSelectedItem(item),
      ),
    );
  }
}
