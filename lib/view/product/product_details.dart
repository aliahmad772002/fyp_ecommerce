import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/cart_controller.dart';
import 'package:fyp_ecommerce/controllers/chat_controller.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/cart/cart_screen.dart';
import 'package:fyp_ecommerce/view/product/components/image_container.dart';
import 'package:fyp_ecommerce/view/product/components/product_title.dart';
import 'package:fyp_ecommerce/view/product/components/rating.dart';
import 'package:fyp_ecommerce/view/product/components/size_color.dart';
import 'package:fyp_ecommerce/view/product/components/quantity_selector.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String category;
  final double productPrice;
  final String productDescription;
  final int productQuantity;
  final List<dynamic> images; // Assuming the images list contains strings
  final List<Color> colors;
  final List<String> sizes;
  final String sellerName;
  final String sellerId;
  const ProductDetailsScreen({
    Key? key,
    required this.productName,
    required this.category,
    required this.productPrice,
    required this.productId,
    required this.images,
    required this.colors,
    required this.sizes,
    required this.productDescription,
    required this.productQuantity,
    required this.sellerName, required this.sellerId,
  }) : super(key: key);
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final pcontroller = Get.put(CartController());

  Color? selectedColor;
  String? selectedSize;
  int selectedQuantity = 1;
  double userRating = 3.0; // Default rating value


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text('Product Details',
            style: TextStyle(
                color: kTextColor,
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          // Product Images
          ImageContainer(images: widget.images.cast<String>()),
          SizedBox(height: height * 0.01),
          // Product Name
          ProductTitle(
    sellerName:widget.sellerName,
    sellerId:widget.sellerId,
            productName: widget.productName,
            productDescription: widget.productDescription,
            productPrice: widget.productPrice,
            productQuantity: widget.productQuantity, onQuantitySelected: (int value) {
            setState(() {
              selectedQuantity = value;
            });
          },
          ),
          SizedBox(height: height * 0.01),
          // Review Stars
          ratingBar(
            context,
            onRatingUpdate: (rating) {
              setState(() {
                userRating = rating;
              });
            },
          ),
          SizedBox(height: height * 0.02),
          // Color Dots and Sizes
          ColorSize(
            colors: widget.colors,
            sizes: widget.sizes,
            onColorSelected: (color) {
              setState(() {
                selectedColor = color;
              });
            },
            onSizeSelected: (size) {
              setState(() {
                selectedSize = size;
              });
            },
          ),
          SizedBox(height: height * 0.02),
          // Quantity Selector

        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ElevatedButton(

          onPressed: () {
            if (selectedColor == null && widget.colors.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select color.')));
            } else if (selectedSize == null && widget.sizes.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select size.')));
            } else {
              pcontroller.addToCart(
                productName: widget.productName,
                productPrice: widget.productPrice,
                productQuantity: selectedQuantity,
                productId: widget.productId,
                images: widget.images.cast<String>(),
                sellerName: widget.sellerName,
                colors: widget.colors.isNotEmpty ? [selectedColor!] : [],
                sizes: widget.sizes.isNotEmpty ? [selectedSize!] : [],
                productDescription: widget.productDescription,
                context: context,
                rating: userRating,
                  sellerId:widget.sellerId,
              );


            }
          },

          child: const Text("Add To Cart"),
        ),
      ),
    );
  }
}
