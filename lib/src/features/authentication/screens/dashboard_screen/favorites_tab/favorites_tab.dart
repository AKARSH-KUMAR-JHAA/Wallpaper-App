import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/controller/favorites_controller.dart';
import '../../../../../constants/colors_strings.dart';

import 'package:luminawall/src/common_widget/standard_header.dart';

import '../widgets/premium_wallpaper_card.dart';

import 'package:luminawall/src/features/authentication/screens/dashboard_screen/widgets/premium_live_wallpaper_card.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Theme Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark ? [
                      kJungleDeepGreen,
                      kJungleMossDark,
                    ] : [
                      Colors.white,
                      kJungleCream,
                    ],
                  ),
                ),
              ),
            ),

            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 10),
                const StandardHeader(title: "Favorites"),
                
                // Custom TabBar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 45,
                  decoration: BoxDecoration(
                    color: isDark ? kJungleMossDark.withValues(alpha: 0.5) : kJungleGreen.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: kJungleEmerald,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: kJungleEmerald.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? kJungleCream.withValues(alpha: 0.5) : kJungleGreen.withValues(alpha: 0.5),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: "WALLPAPERS"),
                      Tab(text: "LIVE"),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      // Static Wallpapers Tab
                      Obx(() => _buildFavoritesContent(
                        context,
                        isDark: isDark,
                        isEmpty: favoritesController.favorites.isEmpty,
                        emptyMsg: "No Liked Wallpapers",
                        child: RefreshIndicator(
                          onRefresh: () => favoritesController.syncFromFirestore(),
                          color: kJungleEmerald,
                          child: GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.55,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: favoritesController.favorites.length,
                            itemBuilder: (context, i) {
                              var photo = favoritesController.favorites[i];
                              return PremiumWallpaperCard(
                                photo: photo,
                                heroTag: photo.src.large2x,
                              );
                            },
                          ),
                        ),
                      )),

                      // Live Wallpapers Tab
                      Obx(() => _buildFavoritesContent(
                        context,
                        isDark: isDark,
                        isEmpty: favoritesController.favoritesLive.isEmpty,
                        emptyMsg: "No Liked Live Wallpapers",
                        child: RefreshIndicator(
                          onRefresh: () => favoritesController.syncFromFirestore(),
                          color: kJungleEmerald,
                          child: GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.55,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: favoritesController.favoritesLive.length,
                            itemBuilder: (context, i) {
                              var video = favoritesController.favoritesLive[i];
                              return PremiumLiveWallpaperCard(video: video);
                            },
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesContent(
    BuildContext context, {
    required bool isDark,
    required bool isEmpty,
    required String emptyMsg,
    required Widget child,
  }) {
    if (isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_rounded,
                size: 80, color: isDark ? kJungleEmerald.withValues(alpha: 0.2) : kJungleMossDark.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              emptyMsg,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: isDark ? kJungleCream : kJungleGreen, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Start liking items to see them here!",
              style: TextStyle(color: isDark ? kJungleCream.withValues(alpha: 0.5) : kJungleMossDark.withValues(alpha: 0.5)),
            ),
          ],
        ),
      );
    }
    return child;
  }
}
