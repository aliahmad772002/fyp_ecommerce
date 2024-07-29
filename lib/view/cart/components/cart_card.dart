import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/cart_controller.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/complete_profile/shopping_info_screen.dart';
import 'package:get/get.dart';

class CartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pcontroller = Get.put(CartController());
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<dynamic> cartDataList = [];

    return Scaffold(

      body: StreamBuilder(
        stream: pcontroller.cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            cartDataList = snapshot.data!.docs.map((doc) => doc.data()).toList();
            double total = 0;

            for (var doc in snapshot.data!.docs) {
              var data = doc.data() as Map<String, dynamic>;
              double price = data['productPrice'];
              int quantity = data['productQuantity'];
              total += price * quantity;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartDataList.length,
                    itemBuilder: (context, index) {
                      var cart = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      pcontroller.productSnapshot = cart;
                      return ListTile(
                        leading: AspectRatio(
                          aspectRatio: 0.88,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: cart.containsKey('images') && (cart['images'] as List).isNotEmpty
                                ? Image.network(cart['images'][0])
                                : Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        title: Text(
                          cart['productName'],
                          style: TextStyle(color: kTextColor, fontSize: width * 0.055),
                          maxLines: 2,
                        ),
                        subtitle: Text.rich(
                          TextSpan(
                            text: '\$${cart['productPrice']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, color: kPrimaryColor),
                            children: [
                              TextSpan(
                                  text: " x${cart['productQuantity']}",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('cart')
                                .doc(pcontroller.auth.currentUser!.uid)
                                .collection('products')
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                          },
                          child: Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                    child: Row(
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
                              String productId = cartDataList[0]['productId'];
                              Get.to(() => ShoppingInfo(
                                productId: productId,
                                totalAmount: total,
                              ));
                            },
                            child: const Text("Check Out"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No Cart Product available'));
          }
        },
      ),
    );
  }
}
