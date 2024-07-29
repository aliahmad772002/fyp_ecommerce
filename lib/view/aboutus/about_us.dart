import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Text(
              'Welcome to Tokoto',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Your ultimate destination for all things fashion and style!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'At Tokoto, we believe that shopping isn\'t just about buying products, it\'s about expressing yourself and embracing your unique style.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Our curated collection features handpicked items from top brands and emerging designers, ensuring that you\'ll always find something that speaks to your individual taste.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'From clothing and accessories to shoes and beauty essentials, we offer a diverse range of products to suit every style and occasion.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'But Tokoto is more than just a place to shop. We\'re a community of fashion enthusiasts who share a passion for creativity and self-expression.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Join us as we celebrate diversity, empowerment, and the beauty of personal style.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'Thank you for choosing Tokoto. Happy shopping!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutUsScreen(),
  ));
}
