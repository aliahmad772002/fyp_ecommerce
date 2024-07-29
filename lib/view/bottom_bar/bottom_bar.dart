import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/view/favourate/favorite_screen.dart';
import 'package:fyp_ecommerce/view/home/home_screen.dart';
import 'package:fyp_ecommerce/view/profile/components/chat_screen.dart';
import 'package:fyp_ecommerce/view/profile/profile_screen.dart';
import 'package:get/get.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import '../../utils/constants.dart';
import '../../controllers/chat_controller.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  final chatController = Get.put(ChatController());
  final controller = Get.put(FirebaseController());
  int currentSelectedIndex = 0;
// TabController? _tabController;
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();

    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }
  String chatroomid(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: TabBarView(
        physics: NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
    // controller: _tabController,
    controller: _motionTabBarController,
    children: <Widget>[
       HomeScreen(),
      FavoriteScreen(),
      Center(
        child: TextButton(
          onPressed: () {
            String currentUserId = controller.auth.currentUser?.uid ?? '';
            String chatID = chatroomid(chatController.sellerId.value, currentUserId);
            Get.to(ChatScreen(receiverName: chatController.sellerName.value, receiverID: chatController.sellerId.value, chatID: chatID));
          },
          child: Text("Chat Screen"),
        ),
      ),

      Profile_Screen(),
    ],
    ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController, // ADD THIS if you need to change your tab programmatically
        initialSelectedTab: "Home",
        labels: const ["Home", "Favourate", "Chat", "Profile"],
        icons: const [Icons.home_outlined, Icons.favorite_border_outlined, Icons.chat_outlined, Icons.person_outline],

        // optional badges, length must be same with labels

        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: inActiveIconColor,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: kPrimaryColor,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            // _tabController!.index = value;
            _motionTabBarController!.index = value;
          });
        },
      ),
    );
  }
}
