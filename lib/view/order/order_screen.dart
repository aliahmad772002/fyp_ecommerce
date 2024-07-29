import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/cart_controller.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/order/orderdetail.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: Container(
          height: height,
          width: width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Orders')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)

                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                var orders = snapshot.data!.docs;

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];

                    return Column(
                      children: [
                        Container(
                          height: height * 0.12,
                          width: width,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            onTap: () {
                              Get.to(
                                OrderDetailsScreen(
                                  uid: snapshot.data!.docs[index].id,
                                  orderCode: snapshot.data!.docs[index]
                                      .get('order_code'),
                                  orderDate: DateFormat('yyyy-MM-dd').format(
                                      (snapshot.data!.docs[index]
                                          .get('order_date') as Timestamp)
                                          .toDate()),
                                  shippingMethod: snapshot.data!.docs[index]
                                      .get('shipping_method'),
                                  paymentMethod: snapshot.data!.docs[index]
                                      .get('payment_method'),
                                  address:
                                  snapshot.data!.docs[index].get('address'),
                                  city: snapshot.data!.docs[index].get('city'),
                                  phonenumber: snapshot.data!.docs[index]
                                      .get('phonenumber'),
                                  email: snapshot.data!.docs[index].get('email'),
                                  postalCode: snapshot.data!.docs[index]
                                      .get('postalcode'),
                                  state: snapshot.data!.docs[index].get('state'),
                                  userName:
                                  snapshot.data!.docs[index].get('username'),
                                  totalAmount: snapshot.data!.docs[index]
                                      .get('total_amount'),
                                  orderPlaced: snapshot.data!.docs[index]
                                      .get('order_placed'),
                                  orderConfirmed: snapshot.data!.docs[index]
                                      .get('order_confirmed'),
                                  orderOnDelivery: snapshot.data!.docs[index]
                                      .get('order_on_delievery'),
                                  orderDelivered: snapshot.data!.docs[index]
                                      .get('order_delievered'),
                                  orders: snapshot.data!.docs[index].get('orders'),

                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            leading: Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                                fontSize: width * 0.045,
                              ),
                            ),
                            title: Text(
                              order['order_code'],
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '\$${order['total_amount']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                                fontSize: width * 0.035,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      ],
                    );
                  },
                );

              }
else {
                return Center(child: Text('No orders found'));
              }

            },
          ),
        ),
      ),
    );
  }
}
