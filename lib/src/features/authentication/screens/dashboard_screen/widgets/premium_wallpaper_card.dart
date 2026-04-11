import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/features/authentication/models/wallpaper_model.dart';
import 'package:luminawall/src/features/authentication/screens/wallpaper_full_screen/wallpaper_full_screen.dart';

import '../../../controller/settings_controller.dart';

class PremiumWallpaperCard extends StatelessWidget {
  final Photo photo;
  final String heroTag;

  const PremiumWallpaperCard({
    super.key,
    required this.photo,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final thumbnailUrl = photo.src.portrait.isNotEmpty ? photo.src.portrait : photo.src.large;
    final highResUrl = photo.src.original;

    return Hero(
      tag: heroTag,
      child: GestureDetector(
        onTap: () {
          final settings = Get.find<SettingsController>();
          final fullResUrl = settings.getDownloadUrl(
            original: photo.src.original, 
            large2x: photo.src.large2x, 
            large: photo.src.large, 
            medium: photo.src.medium,
          );
          Get.to(() => WallpaperFullScreen(fullResUrl, photo: photo, heroTag: heroTag));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: thumbnailUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 1000, 
                    memCacheHeight: 1800,
                    placeholder: (context, url) => Container(
                      color: isDark ? kJungleMossDark : Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                
                
                // "New" badge if applicable (mock logic for visual)
                if (photo.id.hashCode % 5 == 0)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: kJungleGreen,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: kJungleGreen.withValues(alpha: 0.5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const Text(
                        "PREMIUM",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
