import 'package:flutter/material.dart';

class CartModel {
  final String productName;
  final String productDescription;
  final int productQuantity;
  final double productPrice;
  final List<String> images;
  final List<String> colorCodes;
  final List<String> sizes;
  final String productId;
  final String sellerName;

  CartModel({
    required this.productName,
    required this.productDescription,
    required this.productQuantity,
    required this.productPrice,
    required this.images,
    required this.colorCodes,
    required this.sizes,
    required this.productId,
    required this.sellerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productDescription': productDescription,
      'productQuantity': productQuantity,
      'productPrice': productPrice,
      'images': images,
      'colors': colorCodes,
      'sizes': sizes,
      'productId': productId,
      'sellerName': sellerName,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      productId: map['productId'],
      productName: map['productName'],
      productDescription: map['productDescription'],
      productQuantity: map['productQuantity'],
      productPrice: map['productPrice'],
      images: List<String>.from(map['images']),
      colorCodes: List<String>.from(map['colors']),
      sizes: List<String>.from(map['sizes']),
      sellerName: map['sellerName'],
    );
  }
}
