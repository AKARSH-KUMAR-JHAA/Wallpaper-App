import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/profile_screen/profile_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List color = [
      Colors.yellow,
      Colors.green,
      Colors.red,
      Colors.blue,
      Colors.grey,
      Colors.orange,
      Colors.cyanAccent,
      Colors.greenAccent,
      Colors.deepPurpleAccent,
      Colors.brown,
      Colors.pink,
      Colors.teal
    ];
    List color2 = [
      Colors.teal,
      Colors.pink,
      Colors.brown,
      Colors.deepPurpleAccent,
      Colors.greenAccent,
      Colors.cyanAccent,
      Colors.orange,
      Colors.grey,
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow
    ];
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          child: Stack(alignment: Alignment.center,
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                      onTap: () {
                        Get.to(()=> const ProfileScreen(),transition:Transition.rightToLeftWithFade );
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
              Positioned(top: 0, child: Text("Latest",style: Theme.of(context).textTheme.headlineSmall,)),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: color[index],),

                                height: 400,
                                width: size.width * 0.45,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(color: color2[index],borderRadius: BorderRadius.circular(15)),
                                
                                height: 400,
                                width: size.width * 0.45,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: color.length,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
