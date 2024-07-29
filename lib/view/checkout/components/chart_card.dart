import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/home/components/section_title.dart';

class Chart_Card extends StatelessWidget {
  const Chart_Card({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child:   Text(
                "Your Chart ",style: TextStyle(color: kTextColor,fontSize: width*0.055,fontWeight: FontWeight.bold),

              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: height * 0.2,
            width: width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height * 0.15,
                    width: width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child: Image.asset(
                      'assets/images/clothes.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Your Address ",style: TextStyle(color: kTextColor,fontSize:  width*0.055,fontWeight: FontWeight.bold),

              ),
         SizedBox(height: 10,),
              Container(
                height: height * 0.1,
                width: width,
                child: Text(
                  "Lightweight injection-molded EVA foam midsole provides lightweight cushioning",style: TextStyle(color: kSecondaryColor,fontSize: width*0.045,),
                  maxLines: 3,
                ),
              )
            ],
          ),
        ),

      ],
    );
  }
}
