import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FirebaseController());
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(controller.auth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is loading
          return CircularProgressIndicator(); // You can replace this with a placeholder widget
        } else if (snapshot.hasError) {
          // If there's an error
          return Text('Error: ${snapshot.error}');
        }
        else if(snapshot.hasData && snapshot.data != null){
          // If data is available

          return ListTile(
            leading: snapshot.data != null
                ? Container(
                height: height * 0.2,
                width: width * 0.2,
                decoration: BoxDecoration(

                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        snapshot.data!.get('userImage'),
                      ),
                      fit: BoxFit.contain,
                    )))
                : const Center(child: CircularProgressIndicator()),
            title: Text(
              snapshot.data!.get('userName'),
              style: TextStyle(
                color: kTextColor,
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              snapshot.data!.get('userEmail'),
              style: TextStyle(
                color: kTextColor,
                fontSize: width * 0.045,
              ),
            ),
          );
        }
        else {
          return Center(
            child: Text(
              'No Data Found',
              style: TextStyle(
                color: kTextColor,
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }
}
