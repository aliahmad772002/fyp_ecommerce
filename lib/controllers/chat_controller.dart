import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  TextEditingController msgController = TextEditingController();

  RxString sellerId = ''.obs;
  RxString sellerName = ''.obs;

  void setSeller(String id, String name) {
    sellerId.value = id;
    sellerName.value = name;
  }

  Future<void> updateMessage(String chatId, String messageId, String newContent) async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatId)
        .collection('chats')
        .doc(messageId)
        .update({'message': newContent});
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatId)
        .collection('chats')
        .doc(messageId)
        .delete();
  }
}

