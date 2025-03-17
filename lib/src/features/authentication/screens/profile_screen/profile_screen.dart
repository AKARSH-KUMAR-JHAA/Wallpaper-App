import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/src/features/authentication/screens/welcome_screen/welcome_screen.dart';

import '../../../../repository/authentication_repository/authentication_repository.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          height: size.height,
          width: size.width,
          margin: EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 200,
              ),
              SizedBox(height: 50,),
              SizedBox(height: 65,width: size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        AuthenticationRepository.instance.logout();
                        GoogleSignIn().signOut();
                      },
                      child: Text(
                        "Logout",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )))
            ],
          ),
        ),
      ),
    ));
  }
}
