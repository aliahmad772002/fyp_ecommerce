import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/cart/cart_screen.dart';
import 'package:fyp_ecommerce/view/order/order_screen.dart';
import 'package:fyp_ecommerce/view/order/orderdetail.dart';
import 'package:get/get.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 16),
        InkWell(
          onTap: (){
            Get.to(CartScreen());
          },
          child: Container(
            height: 50,
              width: 50,
              decoration: BoxDecoration(shape: BoxShape.circle,color: kSecondaryColor.withOpacity(0.1),),
              child: Icon(Icons.shopping_cart_outlined,)),
        ),
          const SizedBox(width: 8),
          // InkWell(
          //   onTap: (){
          //     Get.to(OrderScreen());
          //   },
          //   child: Container(
          //       height: 50,
          //       width: 50,
          //       decoration: BoxDecoration(shape: BoxShape.circle,color: kSecondaryColor.withOpacity(0.1),),
          //       child: Icon(Icons.notifications_none_outlined,color: kTextColor,)),
          // ),
        ],
      ),
    );
  }
}
