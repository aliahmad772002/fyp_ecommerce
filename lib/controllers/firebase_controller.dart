import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/models/Cart.dart';
import 'package:fyp_ecommerce/models/usermodel.dart';
import 'package:fyp_ecommerce/view/bottom_bar/bottom_bar.dart';
import 'package:fyp_ecommerce/view/cart/cart_screen.dart';
import 'package:fyp_ecommerce/view/sign_in/sign_in_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController extends GetxController {
  static FirebaseController get instance => Get.find();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  var isloading = false.obs;
  String? errorMessage;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final firebasemessaging = FirebaseMessaging.instance;
  void getToken() {
    firebasemessaging.getToken().then((value) {
      StaticData.tokenId = value!;
      print('token id ${StaticData.tokenId} ');
    });
  }

  String? get uid => FirebaseAuth.instance.currentUser?.uid; // Getter for UID

  Future signUp({
    required File? image,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (userCredential.user != null) {
        getToken();

        print('uid of the current user ----> ${userCredential.user!.uid}');

        postdatatoDB(
          id: userCredential.user!.uid,
          image: image,
        );
        Get.to(const SignInScreen());
        showSnackBar(
          'Success',
          'Now please login!',
          Icons.check,
          Colors.green,
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        'Error',
        e.message!,
        Icons.close,
        Colors.red,
      );
    }

    /// Stores user data on firebase
  }

  void postdatatoDB({
    required String id,
    File? image,
  }) async {
    try {
      // Check if an image is selected
      if (image != null) {
        // Upload image to Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child('userprofile_images/$id.png');

        UploadTask uploadTask = storageReference.putFile(image);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();

          // Save user data with image URL to Firestore
          UserModel userModel = UserModel(
            userName: nameController.text,
            userEmail: emailController.text,
            userPasword: passwordController.text,
            userToken: StaticData.tokenId,
            uid: id,
            userImage: imageUrl,
          );

          // Add new seller to 'Seller' collection
          await firebaseFirestore
              .collection('users')
              .doc(id)
              .set(userModel.toMap());
          showSnackBar(
            'Success',
            'Signup successfully!',
            Icons.check,
            Colors.green,
          );
        });
      }
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to post data to Firestore.',
        Icons.close,
        Colors.red,
      );
    }
  }

  String? _userEmail;
  FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance; // Initialize Firebase Messaging

  // login/////////

  void signin() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      User user = (await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user!;
      StaticData.uid = user.uid;
      print('uid of the current user ----> ${StaticData.uid}');
      _userEmail = user.email!;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      print('email of the current user ----> $_userEmail');
      Get.offAll(const BottomBar());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(
          'Error',
          'No user found for that email.',
          Icons.close,
          Colors.red,
        );
      } else if (e.code == 'wrong-password') {
        showSnackBar(
          'Error',
          'Wrong password provided for that user.',
          Icons.close,
          Colors.red,
        );
      }
      showSnackBar(
        'Error',
        errorMessage!,
        Icons.close,
        Colors.red,
      );
    }
  }

  /// Function to handle liking/disliking a post
  Future<void> handleLikeDislike(String postId) async {
    try {
      // Retrieve the current user's UID
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // Get a reference to the book document
      DocumentReference postRef =
          firebaseFirestore.collection('Product').doc(postId);
      DocumentSnapshot bookSnapshot = await postRef.get();
      List<dynamic> likedBy = bookSnapshot.get('likedBy');
      bool isAlreadyLiked = likedBy.contains(currentUserId);
      if (isAlreadyLiked) {
        // User is disliking the book
        likedBy.remove(currentUserId);
      } else {
        // User is liking the book
        likedBy.add(currentUserId);
      }
      // Update the book document with the new like count and likedBy list
      await postRef.update({
        'likedBy': likedBy,
      });
      // Notify listeners of changes
      update();
    } catch (e) {
      log('Error updating likes: $e');
      // Handle errors or display a message to the user
    }
  }

  Future<void> updateUserProfile({File? image}) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;

        // Check if an image is selected
        if (image != null) {
          // Upload image to Firebase Storage
          Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$uid.png');

          UploadTask uploadTask = storageReference.putFile(image);

          // Wait for the image upload task to complete
          await uploadTask.whenComplete(() async {
            String imageUrl = await storageReference.getDownloadURL();

            // Update seller image in Firestore
            await firebaseFirestore
                .collection('users')
                .doc(uid)
                .update({'userImage': imageUrl});
          });
        }

        // Update seller name in Firestore
        await firebaseFirestore
            .collection('users')
            .doc(uid)
            .update({'userName': nameController.text});

        showSnackBar(
          'Success',
          'Seller data updated!',
          Icons.check,
          Colors.green,
        );
      }
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to update Seller data: $e',
        Icons.close,
        Colors.red,
      );
    }
  }


  void signOut() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.to(const SignInScreen());
  }

  Future<UserModel> getUserInfo() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Explicitly cast the data to Map<String, dynamic>
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return UserModel.fromMap(userData);
      } else {
        // Handle the case where user information is not found
        return UserModel(); // You might want to handle this better
      }
    } catch (e) {
      // Handle exceptions
      print(e.toString());
      return UserModel(); // You might want to handle this better
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

class StaticData {
  static String uid = '';
  static String tokenId = '';
}
