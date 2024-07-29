import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/components/form_error.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';



class EditProfile extends StatefulWidget {

  const EditProfile({super.key,});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = Get.put(FirebaseController());
  final _formKey = GlobalKey<FormState>();

  bool remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }File? _image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }



  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kTextColor,),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop();
          },
        ),

        centerTitle: true,
        title: Text('Edit Profile',  style: TextStyle(
            color: kTextColor,
            fontSize: width * 0.045,
            fontWeight: FontWeight.bold)),

      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                await pickImage();
                setState(() {});
              },
              child: _image != null
                  ? Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    "Upload Image",
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height*0.02,),
            const Divider(),
            SizedBox(height: height*0.02,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.nameController,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        removeError(error: kNamelNullError);
                      }
                      return;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        addError(error: kNamelNullError);
                        return "";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      hintText: "Enter your first name",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),


                  FormError(errors: errors),
                  const SizedBox(height: 30),

                ],
              ),
            ),
            SizedBox(height: height*0.02,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: width*0.3, vertical: height*0.02),
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),

                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await controller.updateUserProfile(image: _image);
                }
              }, child: Text(
              'Update',
              style: TextStyle(
                color: kTextColor,
              ),
            ),),
          ],
        ),
      ),
    );
  }
}
