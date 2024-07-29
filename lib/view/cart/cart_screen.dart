import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/cart_controller.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/view/cart/components/cart_card.dart';
import 'package:fyp_ecommerce/view/cart/components/check_out_card.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final pcontroller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: pcontroller.cartStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Your Cart",
                style: TextStyle(color: Colors.black),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.black),
              );
            } else if(snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              int itemCount = snapshot.data!.docs.length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Cart",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    "$itemCount items",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            }else {
              return const Text(
                "Cart",
                style: TextStyle(color: Colors.black),
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CartCard(),
      ),
      // bottomNavigationBar: const CheckoutCard(),
    );
  }
}
