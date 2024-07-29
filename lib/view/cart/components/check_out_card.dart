import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/cart_controller.dart';
import 'package:fyp_ecommerce/view/complete_profile/shopping_info_screen.dart';
import 'package:get/get.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pcontroller = Get.put(CartController());

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('cart')
                  .doc(pcontroller.auth.currentUser!.uid)
                  .collection('products')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  var productId = snapshot.data!.docs[0].data()['productId'];
                  double total = 0;
                  for (var doc in snapshot.data!.docs) {
                    var data = doc.data();
                    double price = data['productPrice'];
                    int quantity = data['productQuantity'];
                    total += price * quantity;
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "Total:\n",
                            children: [
                              TextSpan(
                                text: "\$$total",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => ShoppingInfo(

                          productId: productId,
                              totalAmount: total,
                            ),
                            );
                          },
                          child: const Text("Check Out"),
                        ),
                      ),
                    ],
                  );
                }
                else {
                  return const Text("Cart is empty");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
