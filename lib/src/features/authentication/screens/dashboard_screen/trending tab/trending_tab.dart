import 'package:flutter/material.dart';

class TrendingTab extends StatelessWidget {
  const TrendingTab({super.key});

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
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(children: [
          Container(margin: EdgeInsets.only(top: 55),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: color.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Container(
                    height: size.height * 0.75,
                    width: 100,
                    decoration: BoxDecoration(
                        color: color[index],
                        borderRadius: BorderRadius.circular(20)),
                  ),
                );
              },
            ),
          ),
          Positioned(top: 0,left: 0, child: Text("Trending",style: Theme.of(context).textTheme.headlineSmall,))
        ]),
      ),
    ));
  }
}
