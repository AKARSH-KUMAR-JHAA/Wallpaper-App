import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/src/features/authentication/models/menu_item_model.dart';
import 'package:login/src/repository/authentication_repository/authentication_repository.dart';

class Menuitems {
  static const profile = Menuitem("Profile", Icons.person);
  static const Home = Menuitem("Profile", Icons.home);
  static const favourites = Menuitem("Favourites", Icons.favorite);
  static const notifications =
      Menuitem("Notification", Icons.notifications_active);
  static const settings = Menuitem("Settings", Icons.settings);
  static const rate = Menuitem("Rate Us", Icons.star_rate_rounded);
  static const about = Menuitem("About Us", Icons.book);

  static const all = <Menuitem>[
    profile,
    Home,
    favourites,
    notifications,
    settings,
    rate,
    about
  ];
}

class MenuScreen extends StatelessWidget {
   final Menuitem currentItem;
  final ValueChanged<Menuitem> onSelectedItem;
  const MenuScreen({Key? key,
    required this.currentItem,
    required this.onSelectedItem
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Theme(
          data: ThemeData.dark(),
          child: Scaffold(
              backgroundColor: Colors.indigo,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  ...Menuitems.all.map(buildMenuItem),
                  Spacer(
                    flex: 2,
                  ),
                  ElevatedButton(onPressed: () {
                    AuthenticationRepository.instance.logout();
                    GoogleSignIn().signOut();
                  }, child: Text("Logout"))
                ],
              )),
        ));

  }
  Widget buildMenuItem(Menuitem item) {

    return ListTile(
      selectedColor: Colors.white,
      selected: currentItem == item,
    selectedTileColor: Colors.black26,
    minLeadingWidth: 20,
    leading: Icon(item.icon,),
    title: Text(item.title,style: TextStyle(fontSize: 20),),
    onTap: () {onSelectedItem(item);},
  );
  }
}
