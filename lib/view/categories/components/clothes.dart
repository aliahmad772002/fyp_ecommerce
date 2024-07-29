import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/product/product_details.dart';
import 'package:get/get.dart';

class Clothes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FirebaseController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Product')
              .where('category', isEqualTo: 'Clothes')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No products found.'));
            }

            final products = snapshot.data!.docs;

            return GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.9,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final product = products[index].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                  Get.to(
                    ProductDetailsScreen(
                      productId: snapshot.data!.docs[index].id,
                      productName: snapshot.data!.docs[index]
                          .get('productName'),
                      category: snapshot.data!.docs[index]
                          .get('category'),
                      productPrice: snapshot.data!.docs[index]
                          .get('productPrice'),
                      productDescription: snapshot
                          .data!.docs[index]
                          .get('productDescription'),
                      productQuantity: snapshot.data!.docs[index]
                          .get('productQuantity'),
                      images: snapshot.data!.docs[index]
                          .get('images'),
                      colors: (snapshot.data!.docs[index]
                          .get('colors') as List<dynamic>)
                          .map((color) {
                        return Color(int.parse(
                            '0xFF${color.substring(1)}')); // Convert hexadecimal color to Color object
                      }).toList(),
                      sizes: (snapshot.data!.docs[index]
                          .get('sizes') as List<dynamic>)
                          .cast<String>(),
                      sellerName: snapshot.data!.docs[index]
                          .get('sellerName'),
                      sellerId: snapshot.data!.docs[index]
                          .get('sellerId'),
                    ),
                  );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.05,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: product.containsKey('images') &&
                                    (product['images'] as List).isNotEmpty
                                ? Image.network(
                                    product['images'][0],
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['productName'],
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product['productPrice']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.handleLikeDislike(
                                    snapshot.data!.docs[index].id);
                              },
                              child: Icon(
                                Icons.favorite,
                                color: snapshot.data!.docs[index]
                                        .get('likedBy')
                                        .contains(
                                            controller.auth.currentUser?.uid)
                                    ? const Color(0xFFFF4848)
                                    : const Color(0xFFDBDEE4),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
