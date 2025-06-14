import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/home_tab/home_tab.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperFullScreen extends StatelessWidget {
 WallpaperFullScreen(this.link,{super.key});
  final String link;

  final WallpaperManagerFlutter wallpaperManagerFlutter = WallpaperManagerFlutter();

  Future<void> _loadImage() async {
    await Future.delayed(Duration(seconds: 0)); // Simulate network delay
  }

  Future<void> _setwallpaper(location) async {
    final file = await DefaultCacheManager().getSingleFile(link);
    try {
       await wallpaperManagerFlutter.setWallpaper(file, location);
       Get.to(()=>BottomNavBar());



    } catch (e) {
      ScaffoldMessenger.of(BuildContext as BuildContext).showSnackBar(
        const SnackBar(
          content: Text('Error Setting Wallpaper'),
        ),
      );
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
          body: Center(
            child: FutureBuilder<void>(
              future: _loadImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(color: Colors.white,);
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      SizedBox(height: double.infinity,
                          width: double.infinity,
                          child: CachedNetworkImage(imageUrl: link, fit: BoxFit.fill,)),
                      Positioned(bottom: 50, right: 20,
                        child: Center(
                          child: SizedBox(height: 65, width: size.width*0.9,
                            child: ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStateColor.transparent,),
                              onPressed: () {
                                _setwallpaper(WallpaperManagerFlutter.bothScreens);
                              },
                              child: Text('Set Wallpaper', style: Theme
                                  .of(context)
                                  .textTheme
                                  .displayMedium,),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text('Error loading image'));
                }
              },
            ),
          ),
        ));
  }
}

