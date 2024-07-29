import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';

class ColorSize extends StatefulWidget {
  final List<Color> colors;
  final List<String> sizes;
  final Function(Color) onColorSelected;
  final Function(String) onSizeSelected;

  const ColorSize({
    Key? key,
    required this.colors,
    required this.sizes,
    required this.onColorSelected,
    required this.onSizeSelected,
  }) : super(key: key);

  @override
  State<ColorSize> createState() => _ColorSizeState();
}

class _ColorSizeState extends State<ColorSize> {
  Color? selectedColor;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.colors.isNotEmpty) ...[
          Container(
            height: height * 0.045,
            width: width * 0.95,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.colors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = widget.colors[index];
                    });
                    widget.onColorSelected(widget.colors[index]);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.colors[index],
                      shape: BoxShape.circle,
                      border: selectedColor == widget.colors[index]
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                    ),
                    margin: EdgeInsets.all(5),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
        ],
        if (widget.sizes.isNotEmpty) ...[
          Container(
            height: height * 0.07,
            width: width * 0.95,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.sizes.length,
              itemBuilder: (context, index) {
                final size = widget.sizes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSize = size;
                    });
                    widget.onSizeSelected(size);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedSize == size ? kPrimaryColor : kTextColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        color: selectedSize == size ? Colors.black : null,
                        fontWeight:
                        selectedSize == size ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
