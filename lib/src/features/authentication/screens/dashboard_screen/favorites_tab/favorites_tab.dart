import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/controller/favorites_controller.dart';
import '../../../../../constants/colors_strings.dart';

import 'package:luminawall/src/common_widget/standard_header.dart';

import '../widgets/premium_wallpaper_card.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: kJungleMossDark,
      body: Stack(
        children: [
          // Theme Background
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

          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 10),
              const StandardHeader(title: "Favorites"),
              Expanded(
                child: Obx(() {
                  if (favoritesController.favorites.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_outline_rounded,
                              size: 80, color: kJungleEmerald.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          Text(
                            "No Favorites Yet",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: kJungleCream),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Start liking wallpapers to see them here!",
                            style: TextStyle(color: kJungleCream.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: favoritesController.favorites.length,
                      itemBuilder: (context, i) {
                        var photo = favoritesController.favorites[i];
                        var imageUrl = photo.src.large2x;
                        return PremiumWallpaperCard(
                          photo: photo,
                          heroTag: imageUrl,
                        );
                      },
                    ),
                  );
                }),
              ),
              // For bottom nav spacing if needed
            ],
          ),
        ],
      ),
    );
  }
}
