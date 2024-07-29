import 'package:flutter/material.dart';

import '../../../utils/constants.dart';


class IntroContent extends StatefulWidget {
  const IntroContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  State<IntroContent> createState() => _IntroContentState();
}

class _IntroContentState extends State<IntroContent> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Spacer(),
         Text(
          "TOKOTO",
          style: TextStyle(
            fontSize: width * 0.1,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.text!,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Image.asset(
          widget.image!,
          height: height* 0.35,
          width: width* 0.6,
          // height: 265,
          // width: 235,
        ),
      ],
    );
  }
}
