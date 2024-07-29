import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/components/feature.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/categories/components/clothes.dart';
import 'package:fyp_ecommerce/view/product/product_details.dart';
import 'package:get/get.dart';

import 'section_title.dart';

class FeaturedProducts extends StatefulWidget {
  const FeaturedProducts({Key? key}) : super(key: key);

  @override
  State<FeaturedProducts> createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  final controller = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Featured Products",
            press: () {
              Get.to(() => Featured());
            },
          ),
        ),
        SizedBox(
          height: height * 0.35,
          width: width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Product').
            where('isFeatured', isEqualTo: true)
        .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No products found.'));
              }

              var productDocs = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productDocs.length,

                itemBuilder: (context, index) {
                  var productData = productDocs[index].data() as Map<String, dynamic>;
                  var productId = productDocs[index].id;

                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        ProductDetailsScreen(
                          productId: productId,
                          productName: productData['productName'],
                          category: productData['category'],
                          productPrice: productData['productPrice'],
                          productDescription: productData['productDescription'],
                          productQuantity: productData['productQuantity'],
                          images: productData['images'],
                          colors: (productData['colors'] as List<dynamic>).map((color) {
                            return Color(int.parse('0xFF${color.substring(1)}'));
                          }).toList(),
                          sizes: (productData['sizes'] as List<dynamic>).cast<String>(),
                          sellerName: productData['sellerName'],
                          sellerId: productData['sellerId'],
                        ),
                      );
                    },
                    child: SizedBox(
                      height: height * 0.22,
                      width: width*0.6,
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
                                child: productData.containsKey('images') && (productData['images'] as List).isNotEmpty
                                    ? Image.network(
                                  productData['images'][0],
                                )
                                    : Center(child: CircularProgressIndicator()),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              productData['productName'],
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${productData['productPrice']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.handleLikeDislike(productId);
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: (productData['likedBy'] as List).contains(controller.auth.currentUser?.uid)
                                        ? const Color(0xFFFF4848)
                                        : const Color(0xFFDBDEE4),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
