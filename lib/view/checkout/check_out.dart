import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/models/Cart.dart';
import 'package:fyp_ecommerce/view/checkout/components/chart_card.dart';
import 'package:fyp_ecommerce/view/checkout/components/checkcard.dart';
import 'package:fyp_ecommerce/view/checkout/components/payment.dart';

class Check_Out extends StatefulWidget {
  const Check_Out({super.key});

  @override
  State<Check_Out> createState() => _Check_OutState();
}

class _Check_OutState extends State<Check_Out> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              "ChekOut",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${'demoCarts.length'} items",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

          Chart_Card(),
          PaymentOption(),
          Check_Card(),
        ],),
      ),
     ));
  }
}
