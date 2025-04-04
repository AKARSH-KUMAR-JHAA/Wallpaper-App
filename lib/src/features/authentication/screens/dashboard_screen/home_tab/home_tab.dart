import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/profile_screen/profile_screen.dart';
import 'package:login/src/features/authentication/screens/wallpaper_full_screen/wallpaper_full_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
        child: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                      onTap: () {
                        Get.to(() => const ProfileScreen(),
                            transition: Transition.rightToLeftWithFade);
                      },
                      child: Icon(
                        Icons.account_circle,
                        size: 40,
                      ))),
              Positioned(
                  top: 0,
                  left: 0,
                  child: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.menu,
                        size: 40,
                      ))),
              Positioned(
                  top: 0,
                  child: Text(
                    "Latest",
                    style: Theme.of(context).textTheme.headlineSmall,
                  )),
              Container(
                  margin: EdgeInsets.only(top: 50),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("wallpaper")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                (size.width / 2.5) / (size.height / 2.5),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, i) {
                            var lower = snapshot.data!.docs[i]['lower'];
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: GestureDetector(
                                    onTap: () {
                                      Get.to(()=>WallpaperFullScreen(lower));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: lower,
                                      fit: BoxFit.fill,
                                    )));
                          },
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Center(
                          child: Text("Error"),
                        );
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
