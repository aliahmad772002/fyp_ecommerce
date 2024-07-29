import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/theme.dart';
import 'package:fyp_ecommerce/view/bottom_bar/bottom_bar.dart';
import 'package:fyp_ecommerce/view/splash/splash_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCJC7JHcjyYF-xVjsDaGWfDkKm6bHS7enU",
      appId: "1:1076711505335:android:4d1fcbc99c92274058bc32",
      messagingSenderId: "1076711505335",
      projectId: "tokotofyp",
      storageBucket: "tokotofyp.appspot.com",



  ),
  );
// Ensure the shared preferences are initialized before running the app
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));

}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme(context),
      home: isLoggedIn ?  const BottomBar() : const Splash_Screen(),
    );
  }
}
