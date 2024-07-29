import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fyp_ecommerce/components/feature.dart';
import 'package:fyp_ecommerce/components/popular.dart';
import 'package:fyp_ecommerce/view/categories/category.dart';
import 'package:fyp_ecommerce/view/home/components/popular_product.dart';
import 'package:fyp_ecommerce/view/order/order_screen.dart';
import 'package:get/get.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/Flash Icon.svg", "text": "Popular ", "onPress": () {
        Get.to(() => Popular());
      }},
      {"icon": "assets/icons/Bill Icon.svg", "text": "Featured", "onPress": () {
        Get.to(() => Featured());
      }},
      // {"icon": "assets/icons/Game Icon.svg", "text": "Game", "onPress": () {
      //   // Add your logic for Game category here
      //   print("Game category pressed");
      // }},
      {"icon": "assets/icons/Gift Icon.svg", "text": "Orders", "onPress": () {
        Get.to(() => OrderScreen());
        print("Daily Gift category pressed");
      }},
      {"icon": "assets/icons/Discover.svg", "text": "More", "onPress": () {
        Get.to(() => CategoryScreen());
      }},
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
              (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            onPress: categories[index]["onPress"],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPress,
  }) : super(key: key);

  final String icon, text;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECDF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
