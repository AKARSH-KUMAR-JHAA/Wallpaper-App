import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/features/authentication/controller/profile_controller.dart';
import 'package:luminawall/src/features/authentication/screens/forget_password_screen/forget_options_menu/forget_pass_model_bottom_sheet.dart';
import 'package:luminawall/src/features/authentication/controller/sidebar_controller.dart';
import 'package:luminawall/src/repository/authentication_repository/authentication_repository.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = AuthenticationRepository.instance.firebaseUser.value;
    final profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: kJungleMossDark,
      body: Stack(
        children: [
          // Background Forest Depth
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kJungleDeepGreen,
                    kJungleMossDark,
                  ],
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => MyDrawerController.instance.toggleDrawer(),
                        icon: const Icon(Icons.menu_open_rounded, color: kJungleCream, size: 28),
                      ),
                      Text(
                        profileTitle.toUpperCase(),
                        style: const TextStyle(
                          color: kJungleCream,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer to balance menu icon
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Profile Picture with Premium Ring
                  Obx(() {
                    final firestoreUser = profileController.userModel.value;
                    final name = firestoreUser?.fullName ?? authUser?.displayName ?? authUser?.email ?? "U";
                    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "U";

                    return Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [kJungleEmerald, kJungleCream],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: kJungleEmerald.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: kJungleDeepGreen,
                              backgroundImage: authUser?.photoURL != null
                                  ? NetworkImage(authUser!.photoURL!)
                                  : null,
                              child: authUser?.photoURL == null
                                  ? Text(
                                      initial,
                                      style: const TextStyle(
                                          color: kJungleCream,
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => _showEditProfile(context, profileController),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: kJungleEmerald,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kJungleDeepGreen, width: 2),
                                ),
                                child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // User Identity Details
                  Obx(() {
                    final firestoreUser = profileController.userModel.value;
                    return Column(
                      children: [
                        Text(
                          firestoreUser?.fullName ?? authUser?.displayName ?? "Guest Explorer",
                          style: const TextStyle(
                            color: kJungleCream,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          firestoreUser?.email ?? authUser?.email ?? "no-email@lumina.com",
                          style: TextStyle(
                            color: kJungleCream.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 40),

                  // Functional Menu Card (Glassmorphic)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: kJungleCream.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        _buildActionItem(
                          icon: Icons.person_outline_rounded,
                          title: editProfile,
                          onTap: () => _showEditProfile(context, profileController),
                        ),
                        _buildDivider(),
                        _buildActionItem(
                          icon: Icons.lock_reset_rounded,
                          title: "Change Password",
                          onTap: () => ForgetpasswordScreen.buildShowModalBottomSheet(context),
                        ),
                        _buildDivider(),
                        _buildActionItem(
                          icon: Icons.shield_outlined,
                          title: privacySecurity,
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildActionItem(
                          icon: Icons.card_giftcard_rounded,
                          title: premiumSubscription,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Danger Zone Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        _buildActionItem(
                          icon: Icons.logout_rounded,
                          title: logout,
                          color: Colors.redAccent,
                          onTap: () => _confirmLogout(context),
                        ),
                        _buildDivider(isDanger: true),
                        _buildActionItem(
                          icon: Icons.delete_forever_rounded,
                          title: "Delete Account",
                          color: Colors.redAccent,
                          onTap: () => _confirmDeletion(context, profileController),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = kJungleEmerald,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color == kJungleEmerald ? kJungleCream : color,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: kJungleCream.withValues(alpha: 0.3)),
    );
  }

  Widget _buildDivider({bool isDanger = false}) {
    return Divider(
      height: 1,
      indent: 80,
      endIndent: 25,
      color: isDanger ? Colors.red.withValues(alpha: 0.1) : kJungleCream.withValues(alpha: 0.05),
    );
  }

  // --- Handlers ---

  void _showEditProfile(BuildContext context, ProfileController controller) {
    final name = TextEditingController(text: controller.userModel.value?.fullName);
    final phone = TextEditingController(text: controller.userModel.value?.phoneNo);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: kJungleDeepGreen,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Update Profile",
              style: TextStyle(color: kJungleCream, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: name,
              style: const TextStyle(color: kJungleCream),
              decoration: _inputDecoration("Full Name", Icons.person_rounded),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phone,
              style: const TextStyle(color: kJungleCream),
              decoration: _inputDecoration("Phone Number", Icons.phone_rounded),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  final user = UserModel(
                    fullName: name.text,
                    email: controller.userModel.value?.email ?? "",
                    phoneNo: phone.text,
                    password: "",
                  );
                  // Close bottom sheet first using native Navigator to avoid GetX snackbar race conditions
                  Navigator.pop(context);
                  // Then trigger the update
                  await controller.updateRecord(user);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kJungleEmerald,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: kJungleCream.withValues(alpha: 0.5)),
      prefixIcon: Icon(icon, color: kJungleEmerald),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: kJungleCream.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: kJungleEmerald, width: 2),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
    );
  }

  void _confirmLogout(BuildContext context) {
    Get.defaultDialog(
      title: "Logout?",
      middleText: "Are you sure you want to end your session?",
      backgroundColor: kJungleDeepGreen,
      titleStyle: const TextStyle(color: kJungleCream),
      middleTextStyle: const TextStyle(color: kJungleCream),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        onPressed: () {
          Navigator.pop(context);
          AuthenticationRepository.instance.logout();
          GoogleSignIn().signOut();
        },
        child: const Text("Logout"),
      ),
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(foregroundColor: kJungleCream),
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel"),
      ),
    );
  }

  void _confirmDeletion(BuildContext context, ProfileController controller) {
    Get.defaultDialog(
      title: "DELETE ACCOUNT",
      middleText: "This action is permanent and cannot be reversed. Are you absolutely sure?",
      backgroundColor: kJungleDeepGreen,
      titleStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      middleTextStyle: const TextStyle(color: kJungleCream),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          Navigator.pop(context);
          controller.deleteAccount();
        },
        child: const Text("DELETE"),
      ),
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(foregroundColor: kJungleCream),
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel"),
      ),
    );
  }
}
