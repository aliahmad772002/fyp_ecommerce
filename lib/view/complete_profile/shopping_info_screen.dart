import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/components/custom_surfix_icon.dart';
import 'package:fyp_ecommerce/components/form_error.dart';
import 'package:fyp_ecommerce/controllers/cart_controller.dart';
import 'package:fyp_ecommerce/controllers/firebase_controller.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/sign_in/sign_in_screen.dart';
import 'package:get/get.dart';
import 'components/payment_info.dart';

class ShoppingInfo extends StatefulWidget {
final String productId;
  final double totalAmount;
  const ShoppingInfo({super.key,  required this.totalAmount, required this.productId, });

  @override
  State<ShoppingInfo> createState() => _ShoppingInfoState();
}

class _ShoppingInfoState extends State<ShoppingInfo> {
  final pcontroller = Get.put(CartController());
  final controller = Get.put(FirebaseController());
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? address;
  String? city;
  String? state;
  String? postalcode;
  String? phoneNumber;


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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Shopping Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.streetAddress,
                controller: pcontroller.addressController,
                onSaved: (newValue) => address = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: kAddressNullError);
                  }
                  return;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: kAddressNullError);
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Address",
                  hintText: "Enter your address",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: pcontroller.cityController,
                keyboardType: TextInputType.streetAddress,
                onSaved: (newValue) => city = newValue,
                decoration: const InputDecoration(
                  labelText: "City",
                  hintText: "Enter your City name",

                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.streetAddress,
                controller: pcontroller.stateController,
                onSaved: (newValue) => state = newValue,
                decoration: const InputDecoration(
                  labelText: "State",
                  hintText: "Enter your State name",

                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: pcontroller.postalController,
                onSaved: (newValue) => postalcode = newValue,
                decoration: const InputDecoration(
                  labelText: "PostalCode",
                  hintText: "Enter your PostalCode",

                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: pcontroller.phoneController,
                keyboardType: TextInputType.phone,
                onSaved: (newValue) => phoneNumber = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: kPhoneNumberNullError);
                  }
                  return;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: kPhoneNumberNullError);
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  hintText: "Enter your phone number",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
                ),
              ),


              FormError(errors: errors),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
      bottomNavigationBar:  ElevatedButton(
        onPressed: () {

          if (_formKey.currentState!.validate()) {
            Get.to(() => PaymentOption(
              address: pcontroller.addressController.text,
              city: pcontroller.cityController.text,
              state: pcontroller.stateController.text,
              postalcode: pcontroller.postalController.text,
              phoneNumber: pcontroller.phoneController.text,
                 totalAmount: widget.totalAmount,
                productId: widget.productId,
            ));
          }
        },
        child: const Text("Continue"),
      ),
    );
  }
}
