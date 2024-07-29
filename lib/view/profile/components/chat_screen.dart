import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/chat_controller.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/models/usermodel.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  String receiverName;
  String receiverID;
  String chatID;


  ChatScreen({
    Key? key,
    required this.receiverName,
    required this.receiverID,
    required this.chatID,

  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ccontroller = Get.put(ChatController());
  final controller = Get.put(FirebaseController());
  TextEditingController msgController = TextEditingController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  http.Response? response;







  void onSendMessage() async {
    UserModel user = await FirebaseController.instance.getUserInfo();
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> messageData = {
        "sendBy": user.userName,
        "message": msgController.text,
        "time": DateTime.now(),
        "messageID": const Uuid().v4(),
        'senderID': user.uid,
        'receiverID': widget.receiverID,
      };

      // Add message to sender's chat history
      await firebaseFirestore
          .collection('chatroom')
          .doc(widget.chatID)
          .collection('chats')
          .doc(messageData['messageID'])
          .set(messageData);

      // Add message to seller's chat history
      await firebaseFirestore
          .collection('seller_chatroom') // Change this to your seller chatroom collection
          .doc(widget.receiverID) // Each seller has their own document containing chat history
          .collection('chats')
          .doc(messageData['messageID'])
          .set(messageData);

      msgController.clear();
    } else {
      print("Enter Some Text");
    }
  }




  // void onSendMessage() async {
  //   UserModel user = await FirebaseController.instance.getUserInfo();
  //   if (msgController.text.isNotEmpty) {
  //     Map<String, dynamic> messages = {
  //       "sendBy": user.userName,
  //       "message": msgController.text,
  //       "time": DateTime.now(),
  //       "messageID": const Uuid().v4(),
  //       'senderID': user.uid,
  //       'receiverID': widget.receiverID,
  //     };
  //
  //     await firebaseFirestore
  //         .collection('chatroom')
  //         .doc(widget.chatID)
  //         .collection('chats')
  //         .doc(messages['messageID'])
  //         .set(messages);
  //
  //
  //
  //     msgController.clear();
  //   } else {
  //     print("Enter Some Text");
  //   }
  // }




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
        title: Text(widget.receiverName,
            style: TextStyle(
                color: kTextColor,
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatroom')
                      .doc(widget.chatID)
                      .collection('chats')
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>;
                          return messages(MediaQuery.of(context).size, data);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[


                    Expanded(
                      child: TextField(
                        controller: msgController,
                        decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          onSendMessage();
                        },
                        backgroundColor: kPrimaryColor,
                        elevation: 0,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> data) {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    bool isCurrentUser = data['senderID'] == currentUserID;

    return Container(
      width: size.width,
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
          size.width * 0.7, // Set a maximum width for the message container
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isCurrentUser ? Colors.blue : Colors.red[100],
        ),
        child: PopupMenuButton<String>(
          itemBuilder: (context) {
            List<PopupMenuEntry<String>> items = [];

            if (isCurrentUser) {
              items.add(
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
              );

              items.add(
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              );
            }

            return items;
          },
          onSelected: (value) async {
            if (value == 'edit') {
              // Get the new message content from the user
              String newContent = await showDialog(
                context: context,
                builder: (context) {
                  final controller =
                  TextEditingController(text: data['message']);
                  return AlertDialog(
                    title: Text('Edit message'),
                    content: TextField(
                      controller: controller,
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Save'),
                        onPressed: () => Navigator.of(context).pop(
                            controller.text.isNotEmpty
                                ? controller.text
                                : data['message']),
                      ),
                    ],
                  );
                },
              );

              // Update the message
              ccontroller.updateMessage(
                  widget.chatID, data['messageID'], newContent);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message updated successfully')),
              );
            } else if (value == 'delete') {
              // Delete the message
              ccontroller.deleteMessage(widget.chatID, data['messageID']);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message deleted successfully')),
              );
            }
          },
          child: Text(
            data['message'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isCurrentUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
