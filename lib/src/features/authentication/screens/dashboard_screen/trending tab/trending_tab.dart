import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../wallpaper_full_screen/wallpaper_full_screen.dart';

class TrendingTab extends StatelessWidget {
  const TrendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(children: [
          Container(margin: EdgeInsets.only(top: 55),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("wallpaper")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio:
                      (size.width / 2.5) / (size.height / 3),
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
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                    child: Text("Error"),
                  );
                }
              },
            )
          ),
          Positioned(top: 0,left: 0, child: Text("Trending",style: Theme.of(context).textTheme.headlineSmall,))
        ]),
      ),
    ));
  }
}
