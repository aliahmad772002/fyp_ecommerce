import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final int productQuantity;
  final Function(int) onQuantitySelected;

  QuantitySelector({
    Key? key,
    required this.productQuantity,
    required this.onQuantitySelected,
  }) : super(key: key);

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 1;

  void incrementQuantity() {
    if (quantity < widget.productQuantity) {
      setState(() {
        quantity++;
        widget.onQuantitySelected(quantity);
      });
    }
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.onQuantitySelected(quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedIconBtn(
          icon: Icons.remove,
          press: decrementQuantity,
          showShadow: true,
        ),
        const SizedBox(width: 20),
        Text(
          '$quantity',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 20),
        RoundedIconBtn(
          icon: Icons.add,
          showShadow: true,
          press: incrementQuantity,
        ),
      ],
    );
  }
}


class RoundedIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback press;
  final bool showShadow;

  const RoundedIconBtn({
    Key? key,
    required this.icon,
    required this.press,
    this.showShadow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: showShadow
              ? [BoxShadow(offset: Offset(0, 2), blurRadius: 6, color: Colors.black26)]
              : [],
        ),
        child: Icon(icon),
      ),
    );
  }
}
