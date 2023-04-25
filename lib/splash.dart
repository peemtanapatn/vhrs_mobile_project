import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vhrs_flutter_project/services/controller.dart';
import 'package:vhrs_flutter_project/widgets/bottombar.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return AnimatedSplashScreen(
      splash: 'assets/images/GroupLOGO.jpg',
      splashIconSize: double.maxFinite,
      centered: true,
      nextScreen: BottomBar(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
      //animationDuration: Duration(milliseconds: 1500),
    );
  }
}
