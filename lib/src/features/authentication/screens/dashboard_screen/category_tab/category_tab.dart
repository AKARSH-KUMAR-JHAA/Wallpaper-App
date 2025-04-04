import 'package:flutter/material.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Positioned(top: 200, child: SizedBox(width: size.width, child: SearchBar(onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(), leading: Icon(Icons.search ,size: 35,), hintText: "  Search",)))
        ],
      ),
    ));
  }
}
