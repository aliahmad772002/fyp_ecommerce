import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/view/home/components/feature_products.dart';
import 'package:fyp_ecommerce/view/home/components/home_header.dart';
import 'package:fyp_ecommerce/view/home/components/popular_product.dart';
import 'package:fyp_ecommerce/view/home/components/special_offers.dart';
import 'components/categories.dart';
import 'components/discount_banner.dart';


class HomeScreen extends StatelessWidget {


  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(),
              DiscountBanner(),
              Categories(),
              SpecialOffers(),
              SizedBox(height: 20),
              PopularProducts(),
              SizedBox(height: 20),
              FeaturedProducts(),
            ],
          ),
        ),
      ),
    );
  }
}
