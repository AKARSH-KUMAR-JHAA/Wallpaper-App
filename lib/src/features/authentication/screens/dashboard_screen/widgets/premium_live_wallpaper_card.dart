import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/features/authentication/models/wallpaper_model.dart';
import 'package:luminawall/src/features/authentication/screens/live_wallpaper_full_screen/live_wallpaper_full_screen.dart';

class PremiumLiveWallpaperCard extends StatelessWidget {
  final Video video;

  const PremiumLiveWallpaperCard({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Hero(
      tag: video.image,
      child: GestureDetector(
        onTap: () => Get.to(() => LiveWallpaperFullScreen(video: video)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28), // more rounded for Live
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: video.image,
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
                
                
                // Play indicator overlay
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28,
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
