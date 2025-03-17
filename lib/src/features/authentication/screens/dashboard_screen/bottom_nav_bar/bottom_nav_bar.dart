import 'package:flutter/material.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/category_tab/category_tab.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/home_tab/home_tab.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/trending%20tab/trending_tab.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: SafeArea(child: Scaffold(
      bottomNavigationBar: Container(height: 55,color: Colors.white10,
        child: TabBar(tabs: [
          Tab(
            icon: Icon(Icons.eco_rounded,size: 40,),
          ),
          Tab(
            icon: Icon(Icons.widgets,size: 40,),
          ),
          Tab(
            icon: Icon(Icons.local_fire_department,size: 40,),
          ),

        ],
          indicatorColor: Colors.transparent,
          labelColor: Colors.orange,
          unselectedLabelColor: Color(0xff999999),
        ),
      ),
      body: TabBarView(children: [
        HomeTab(),
        CategoryTab(),
        TrendingTab(),
      ]),
    )));
  }
}
