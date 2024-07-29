import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';

class PaymentOption extends StatefulWidget {
  const PaymentOption({Key? key}) : super(key: key);

  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "Payment Methods ",style: TextStyle(color: kTextColor,fontSize:  width*0.055,fontWeight: FontWeight.bold),

              ),
            ],
          ),
        ),
        Container(
          height: height * 0.2,
          width: width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8.0),
            children: [
              buildSelectableImageContainer(
                image: 'assets/images/visa.png',
                index: 0,
              ),
              buildSelectableImageContainer(
                image: 'assets/images/paypal.png',
                index: 1,
              ),
              buildSelectableImageContainer(
                image: 'assets/images/csh.jpg',
                index: 2,
              ),
              buildSelectableImageContainer(
                image: 'assets/images/google-pay.png',
                index: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSelectableImageContainer({
    required String image,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        print('Image $index selected');
      },
      child: Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: selectedIndex == index ? Colors.grey[200] : Colors.white,
          border: Border.all(
            color: selectedIndex == index ? Colors.blue : Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4.0),
        padding: EdgeInsets.all(8.0),
        child: Image.asset(
          image,
          width: 100

        ),
      ),
    );
  }
}
