import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/cart_controller.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:get/get.dart';

class PaymentOption extends StatefulWidget {
  final String address;
  final String city;
  final String state;
  final String postalcode;
  final String phoneNumber;
  final double totalAmount;
  final String productId;
  const PaymentOption({
    Key? key,
    required this.address,
    required this.city,
    required this.state,
    required this.postalcode,
    required this.phoneNumber, required this.totalAmount, required this.productId,
  }) : super(key: key);

  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  final pcontroller = Get.put(CartController());  String? selectedPaymentMethod; // Changed to store payment method as text
  final controller = Get.put(FirebaseController());
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            buildSelectableImageContainer(
              image: 'assets/images/visa.png',
              paymentMethod: 'visa',
            ),
            buildSelectableImageContainer(
              image: 'assets/images/paypal.png',
              paymentMethod: 'paypal',
            ),
            buildSelectableImageContainer(
              image: 'assets/images/csh.jpg',
              paymentMethod: 'cash',
            ),
            buildSelectableImageContainer(
              image: 'assets/images/google-pay.png',
              paymentMethod: 'google_pay',
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          if (selectedPaymentMethod != null) {
            // Retrieve cart data list
            var cartDataList = await pcontroller.cartStream.first.then((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

            // Call OrderAdd method with payment method and cart data list
            pcontroller.OrderAdd(paymentmethod: selectedPaymentMethod!, cartDataList: cartDataList, totalAmount: widget.totalAmount, productId: widget.productId );
            await pcontroller.clearCart();
          } else {
            // Show error or prompt to select a payment method
            print('Please select a payment method');
          }
        },


        child: const Text("Continue"),
      ),
    );
  }

  Widget buildSelectableImageContainer({
    required String image,
    required String paymentMethod, // Changed to pass payment method as text
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = paymentMethod; // Store payment method as text
        });
        print('Selected Payment Method: $paymentMethod');
      },
      child: Container(
        height: 100,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: selectedPaymentMethod == paymentMethod
              ? Colors.grey[200]
              : Colors.white,
          border: Border.all(
            color: selectedPaymentMethod == paymentMethod
                ? Colors.blue
                : Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4.0),
        padding: EdgeInsets.all(8.0),
        child: Image.asset(
          image,
          width: 100,
        ),
      ),
    );
  }
}
