import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';

Widget orderStatus({icon,color,title, showDone}){
  return ListTile(
    leading: Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        border: Border.all(color: kSecondaryColor,width: 2)
      ),
      child: Icon(
        icon,
        color: color,
      ),
    ),
    trailing: SizedBox(
      height: 100,
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Text(title,style: TextStyle(
          fontSize: 15
        ),),
          showDone?
          const Icon(Icons.done)

              :Container(),
        ],
      ),
    ),
  );
}