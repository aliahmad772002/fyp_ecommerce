import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';

class OrderDetailTile extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;

  OrderDetailTile({required this.title, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title ',
            style: TextStyle(
              fontSize: width*0.045,
              fontWeight: FontWeight.bold,

            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: kPrimaryColor,
              fontSize: width*0.045,
            ),
          ),
        ],
      ),
    );
  }
}