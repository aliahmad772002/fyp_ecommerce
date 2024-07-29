import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/categories/components/Shoes.dart';
import 'package:fyp_ecommerce/view/categories/components/clothes.dart';
import 'package:fyp_ecommerce/view/categories/components/cosmatics.dart';
import 'package:fyp_ecommerce/view/categories/components/electronics.dart';
import 'package:fyp_ecommerce/view/categories/components/grocery.dart';
import 'package:fyp_ecommerce/view/categories/components/health.dart';
import 'package:fyp_ecommerce/view/categories/components/jewelary.dart';
import 'package:fyp_ecommerce/view/categories/components/sports.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Clothes', 'image': 'assets/images/clothes.jpg',"onPress": () {
      Get.to(() => Clothes());
    }},
    {'name': 'Cosmatics', 'image': 'assets/images/cosmatics.jpg',"onPress": () {
      Get.to(() => Cosmatics());
    }},
    {'name': 'Jewelary', 'image': 'assets/images/jewlary.jpg',"onPress": () {
      Get.to(() => Jewelary());
    }},
    {'name': 'Sports', 'image': 'assets/images/sports.jpg',"onPress": () {
      Get.to(() => Sports());
    }},
    {'name': 'Electronics', 'image': 'assets/images/electronics.jpg',"onPress": () {
      Get.to(() => Electronics());
    }},
    {'name': 'Grocery ', 'image': 'assets/images/grocery.jpg',"onPress": () {
      Get.to(() => Grocery());
    }},
    {'name': 'Health ', 'image': 'assets/images/health.jpg',"onPress": () {
      Get.to(() => Health());
    }},
    {'name': 'Shoes ', 'image': 'assets/images/shoes.png',"onPress": () {
      Get.to(() => Shoes());
    }},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 0.85,
          mainAxisSpacing: 20,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Call onPress function if available
              if(categories[index]['onPress'] != null) {
                categories[index]['onPress']!();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  AspectRatio(
                    aspectRatio: 1.05,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset( categories[index]['image'],),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categories[index]['name'],
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


