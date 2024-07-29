import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/chat_controller.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/product/components/quantity_selector.dart';
import 'package:fyp_ecommerce/view/profile/components/chat_screen.dart';
import 'package:get/get.dart';

class ProductTitle extends StatefulWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final int productQuantity;
  final Function(int) onQuantitySelected;
  final String sellerName;
  final String sellerId;
  const ProductTitle({
    Key? key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.onQuantitySelected, required this.sellerName, required this.sellerId,
  }) : super(key: key);

  @override
  State<ProductTitle> createState() => _ProductTitleState();
}

class _ProductTitleState extends State<ProductTitle> {
  final controller = Get.put(FirebaseController());
  final chatcontroller = Get.put(ChatController());
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [


            Text(widget.productName,
                style: TextStyle(
                    color: kTextColor,
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold)),
            const Spacer(),
            InkWell(
              onTap: () {
                String currentUserId =
                    controller.auth.currentUser?.uid ?? '';
                  String chatID = chatroomid(widget.sellerId,currentUserId );
                chatcontroller.setSeller(widget.sellerId, widget.sellerName);
                Get.to(ChatScreen(receiverName:widget.sellerName, receiverID: widget.sellerId, chatID: chatID, ));

              },
              child: Icon(
                Icons.chat,

              ),
            ),
          ],
        ),
        SizedBox(height: height * 0.02),
        Row(
          children: [
            Text(
              '\$${widget.productPrice.toString()}',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            QuantitySelector(
              productQuantity: widget.productQuantity,
              onQuantitySelected: widget.onQuantitySelected,
            ),
          ],
        ),
        SizedBox(height: height * 0.015),
        Container(
          height: height * 0.14,
          width: width,
          child: Text(widget.productDescription,
              style: TextStyle(
                color: kTextColor,
                fontSize: width * 0.045,
              )),
        ),
      ],
    );
  }
}

