import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/models/usermodel.dart';
import 'package:fyp_ecommerce/view/cart/cart_screen.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalController = TextEditingController();
  var phoneController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  var searchResults = <Product>[].obs;
  var allProducts = <Product>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }
  void fetchAllProducts() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('products').get();
      var products = snapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
      allProducts.assignAll(products);
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      searchResults.assignAll(allProducts);
    } else {
      searchResults.assignAll(allProducts.where((product) => product.name.toLowerCase().contains(query.toLowerCase())));
    }
  }
  Future<void> addToCart({
    required String productName,
    required double productPrice,
    required int productQuantity,
    required List<String> images,
    required String productId,
    required String sellerName,
    required String sellerId,
    required List<Color> colors,
    required List<String> sizes,
    required String productDescription,
    required BuildContext context,
    required double rating, // New parameter for rating
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('products') // Add a subcollection for products
          .add({
        'productName': productName,
        'productPrice': productPrice,
        'productQuantity': productQuantity,
        'images': images,
        'productId': productId,
        'sellerName': sellerName,
        'sellerId': sellerId,
        'colorCodes':
            colors.map((color) => color.value.toRadixString(16)).toList(),
        'sizes': sizes,
        'productDescription': productDescription,
        'rating': rating, // Store the rating
      });

      showSnackBar(
        'Success',
        'Added to cart successfully!',
        Icons.check,
        Colors.green,
      );
      Get.to(CartScreen());
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to add to cart.',
        Icons.close,
        Colors.red,
      );
    }
  }

  Stream<QuerySnapshot> get cartStream => FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('products')
      .snapshots();
  Future<void> clearCart() async {
    final cartCollection = FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('products');

    final querySnapshot = await cartCollection.get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  late dynamic productSnapshot;
  var products = [];
  var seller = [];
  Future<void> OrderAdd({
    required String paymentmethod,
    required List<dynamic> cartDataList,
    required double totalAmount,
    required String productId,
  }) async {
    try {
      String id = Uuid().v4();

      String orderCode = generateOrderCode();
      UserModel userModel = await FirebaseController.instance.getUserInfo();
      await getProductDetails(cartDataList); // Pass the accumulated list
      await FirebaseFirestore.instance.collection('Orders').doc(id).set({
        'order_date': FieldValue.serverTimestamp(),
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'username': userModel.userName,
        'email': userModel.userEmail,
        'address': addressController.text,
        'state': stateController.text,
        'city': cityController.text,
        'postalcode': postalController.text,
        'phonenumber': phoneController.text,
        'shipping_method': 'Home Delivery',
        'payment_method': paymentmethod,
        'order_placed': true,
        'order_confirmed': false,
        'order_delievered': false,
        'order_on_delievery': false,
        'total_amount': totalAmount,
        'orders': FieldValue.arrayUnion(products),
        'orderId': id,
        'order_code': orderCode,
        'sellers': FieldValue.arrayUnion(seller),
        'productId': productId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      showSnackBar(
        'Success',
        'Order Placed successfully!',
        Icons.check,
        Colors.green,
      );
      Get.to(CartScreen());
    } catch (e) {
      print('Error adding order: $e'); // Log the error message
      showSnackBar(
        'Error',
        'Failed to place order. $e',
        Icons.close,
        Colors.red,
      );
    }
  }

  getProductDetails(List<dynamic> cartDataList) {

    for (var i = 0; i < cartDataList.length; i++) {
      var cart = cartDataList[i];
      if (cart != null) {
        products.add({
          'colorCodes': cart['colorCodes'],
          'images': cart['images'],
          'sizes': cart['sizes'],
          'productname':
              cart['productName'], // Use 'productName' instead of 'productname'
          'productQuantity': cart['productQuantity'],
          'sellerId': cart['sellerId'],
          'productPrice': cart['productPrice'],
          'rating':cart['rating'],

        });
        seller.add(cart['sellerId']);
      } else {
        print('Cart data at index $i is null');
      }
    }
  }

  String generateOrderCode() {
    var rng = Random();
    var code = StringBuffer();
    for (var i = 0; i < 8; i++) {
      code.write(
          rng.nextInt(10)); // Generate a random digit and add to the code
    }
    return code.toString();
  }

  void showSnackBar(
      String title, String message, IconData icon, Color iconColor) {
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: iconColor),
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    );
  }
}
class Product {
  final String name;
  final double price;
  // Add other product fields here

  Product({required this.name, required this.price});

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      name: doc['productName'],
      price: doc['productPrice'],
      // Initialize other product fields here
    );
  }
}