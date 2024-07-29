import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/view/introscreen/intro_screen.dart';
import 'package:fyp_ecommerce/view/sign_in/sign_in_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import '../bottom_bar/bottom_bar.dart';


class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {

  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(() => const IntroScreen(), transition: Transition.rightToLeft);
    });


  }

  void getdatafromSF() async {
    print('Inside getdatafromSF');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('uid');
    print('UID from SharedPreferences: $value');

    if (value != null) {

      print('UID is not null. Navigating to HomeScreen');
      Get.to(() => const BottomBar(), transition: Transition.zoom);
    } else {
      print('uid is null. Navigating to LoginScreen');
      Get.to(() => const SignInScreen(), transition: Transition.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: height,
        width: width,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash.gif',width: width*0.6,),SizedBox(
              height: height * 0.015,
            ),
            Text(
              "Tokoto",
              style: TextStyle(
                  fontSize: width * 0.1,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor),


            ),
          ],


        ),
      ),
    ));
  }
}
