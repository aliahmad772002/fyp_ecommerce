import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/view/sign_in/sign_in_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../utils/constants.dart';
import '../../complete_profile/components/payment_info.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final controller = Get.put(FirebaseController());
  final _formKey = GlobalKey<FormState>();
  String? FullName;
  String? email;
  String? password;
  // String? conform_password;
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
  }
  File? _image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await pickImage();
            setState(() {});
          },
          child: _image != null
              ? Container(
            width: height*0.27,
            height: width*0.27,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: FileImage(_image!),
                fit: BoxFit.contain,
              ),
            ),
          )
              : Container(
            width: height*0.27,
            height: width*0.27,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryLightColor,

            ),
            child:  Center(
              child: Text(
                "Upload Image",
                style: TextStyle(
                  color: kTextColor,
                  fontSize: width*0.032,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: height*0.03),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.nameController,
                onSaved: (newValue) => FullName = newValue,
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
                  labelText: "Full Name",
                  hintText: "Enter your name",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => email = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: kEmailNullError);
                  } else if (emailValidatorRegExp.hasMatch(value)) {
                    removeError(error: kInvalidEmailError);
                  }
                  return;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: kEmailNullError);
                    return "";
                  } else if (!emailValidatorRegExp.hasMatch(value)) {
                    addError(error: kInvalidEmailError);
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller.passwordController,
                obscureText: true,
                onSaved: (newValue) => password = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: kPassNullError);
                  } else if (value.length >= 8) {
                    removeError(error: kShortPassError);
                  }
                  password = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: kPassNullError);
                    return "";
                  } else if (value.length < 8) {
                    addError(error: kShortPassError);
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                ),
              ),
              const SizedBox(height: 20),
              // TextFormField(
              //   obscureText: true,
              //   onSaved: (newValue) => conform_password = newValue,
              //   onChanged: (value) {
              //     if (value.isNotEmpty) {
              //       removeError(error: kPassNullError);
              //     } else if (value.isNotEmpty && password == conform_password) {
              //       removeError(error: kMatchPassError);
              //     }
              //     conform_password = value;
              //   },
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       addError(error: kPassNullError);
              //       return "";
              //     } else if ((password != value)) {
              //       addError(error: kMatchPassError);
              //       return "";
              //     }
              //     return null;
              //   },
              //   decoration: const InputDecoration(
              //     labelText: "Confirm Password",
              //     hintText: "Re-enter your password",
              //     // If  you are using latest version of flutter then lable text and hint text shown like this
              //     // if you r using flutter less then 1.20.* then maybe this is not working properly
              //     floatingLabelBehavior: FloatingLabelBehavior.always,
              //     suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
              //   ),
              // ),
              FormError(errors: errors),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => SignInScreen()),
                    child: const Text(
                      "SignIn",
                      style: TextStyle(fontSize: 16, color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    controller.signUp(
                      image: _image,
                    );
                  }
                },
                child: const Text("Signup"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
