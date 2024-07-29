import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/view/aboutus/about_us.dart';
import 'package:fyp_ecommerce/view/order/order_screen.dart';
import 'package:fyp_ecommerce/view/profile/components/edit_profile.dart';
import 'package:fyp_ecommerce/view/sign_in/sign_in_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class Profile_Screen extends StatelessWidget {
  static String routeName = "/profile";

  const Profile_Screen({super.key});
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.to(const SignInScreen());
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Edit Profile",
              icon: "assets/icons/User Icon.svg",
              press: () => {
                Get.to(EditProfile())
              },
            ),
            // ProfileMenu(
            //   text: "Notifications",
            //   icon: "assets/icons/Bell.svg",
            //   press: () {},
            // ),
            ProfileMenu(
              text: "Orders",
              icon: "assets/icons/Settings.svg",
              press: () {
                Get.to(OrderScreen());
              },
            ),
            // ProfileMenu(
            //   text: "Message",
            //   icon: "assets/icons/Question mark.svg",
            //   press: () {}
            //
            // ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                signOut();
              },
            ),
            ProfileMenu(
              text: "About Us",
              icon: "assets/icons/Question mark.svg",
              press: () {
                Get.to(AboutUsScreen());
              }

            ),
          ],
        ),
      ),
    );
  }
}
