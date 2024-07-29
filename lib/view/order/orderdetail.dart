import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';
import 'package:fyp_ecommerce/view/order/components/order_status.dart';
import 'package:fyp_ecommerce/view/order/components/order_title.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String uid;
  final String orderCode;
  final String orderDate;
  final String shippingMethod;
  final String paymentMethod;
  final String address;
  final String city;
  final String phonenumber;
  final String email;
  final String postalCode;
  final String state;
  final String userName;
  final double totalAmount;
  final List<dynamic> orders;
  final bool orderPlaced;
  final bool orderConfirmed;
  final bool orderOnDelivery;
  final bool orderDelivered;
  const OrderDetailsScreen({
    Key? key, required this.uid, required this.orderCode, required this.orderDate, required this.shippingMethod, required this.paymentMethod, required this.address, required this.city, required this.phonenumber, required this.email, required this.postalCode, required this.state, required this.userName, required this.totalAmount, required this.orders, required this.orderPlaced, required this.orderConfirmed, required this.orderOnDelivery, required this.orderDelivered,

  }) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              orderStatus(
                color: kPrimaryColor,
                icon: Icons.done,
                title: "Placed",
                showDone: widget.orderPlaced,
              ),
              orderStatus(
                color: Colors.blue,
                icon: Icons.thumb_up,
                title: "Confirmed",
                showDone: widget.orderConfirmed,
              ),
              orderStatus(
                color: Colors.yellow,
                icon: Icons.car_crash,
                title: "On Delivery",
                showDone: widget.orderOnDelivery,
              ),
              orderStatus(
                color: Colors.purple,
                icon: Icons.done_all_rounded,
                title: "Delivered",
                showDone: widget.orderDelivered,
              ),
              Container(
                height: height*0.5,
                width: width,
                color: Colors.grey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        OrderDetailTile(
                          title: 'Order Code',
                          value: widget.orderCode,
                        ),
                        OrderDetailTile(
                          title: 'Order Date',
                          value: widget.orderDate,
                        ),
                      SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          'Shipping Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.045,
                          ),
                        ),
                        Text(
                          widget.userName,
                          style: TextStyle(
                            fontSize: width * 0.04,
                          ),
                        ),
                        Text(
                          widget.email,
                          style: TextStyle(
                            fontSize: width * 0.04,
                          ),
                        ),
                        Text(
                          widget.address,
                          style: TextStyle(
                            fontSize: width * 0.04,
                          ),
                        ),
                        Text(
                          widget.city,
                          style: TextStyle(
                            fontSize: width * 0.04,
                          ),
                        ),
                        Text(
                          widget.state,
                          style: TextStyle(
                            fontSize: width * 0.04,
                          ),
                        ),
                        Text(
                          widget.postalCode,
                          style: TextStyle(
                            fontSize: width * 0.04,
                          ),
                        ),
                        Text(
                          widget.phonenumber,
                          style: TextStyle(
                            fontSize: width * 0.04,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderDetailTile(
                          title: 'Shipping Method',
                          value:    widget.shippingMethod,
                        ),
                        OrderDetailTile(
                          title: 'Payment Method',
                          value:    widget.paymentMethod,
                        ),

                        SizedBox(
                          height: height * 0.05,
                        ),
                        OrderDetailTile(
                          title: 'Total Amount',
                          value:   '\$${widget.totalAmount.toString()}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ordered Product',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.orders.length,
                itemBuilder: (context, index) {
                  var order = widget.orders[index];

                  // Check if the colorCodes and sizes are available
                  bool hasColors = order['colorCodes'] != null && order['colorCodes'].isNotEmpty;
                  bool hasSizes = order['sizes'] != null && order['sizes'].isNotEmpty;

                  // Convert the first color code to Color if available
                  Color? color;
                  if (hasColors) {
                    color = Color(int.parse(order['colorCodes'][0], radix: 16));
                  }

                  return ListTile(

                    title: Text(
                      order['productname'],
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${order['productQuantity']}x",
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: kPrimaryColor,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            if (hasColors) ...[
                              Container(
                                height: height * 0.03,
                                width: width * 0.2,
                                color: color, // Set color of the container
                              ),
                              SizedBox(width: width * 0.02),
                            ],
                            if (hasSizes) ...[
                              Text(
                                order['sizes'][0],
                                style: TextStyle(
                                  fontSize: width * 0.045,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      '\$${order['productPrice']}',

                      style: TextStyle(
                        fontSize: width * 0.045,
                      ),
                    ),


                  );
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}

































