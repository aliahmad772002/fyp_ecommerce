import 'package:flutter/material.dart';
import 'package:fyp_ecommerce/utils/constants.dart';


class ImageContainer extends StatefulWidget {
  final List images;
  const ImageContainer({Key? key, required this.images}) : super(key: key);

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  int selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        if (widget.images.isNotEmpty)
          SizedBox(
            width: width,
            child: AspectRatio(
              aspectRatio: 1.8,
              child: Image.network(
                widget.images[selectedImageIndex],
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Center(child: Text('Error Loading Image'));
                },
              ),
            ),
          ),
        if (widget.images.isEmpty)
          Container(
            width: width,
            height: height*0.25,
            color: Colors.grey[200],
            child: Center(
              child: Text('No Image Found', style: TextStyle(fontSize: 16)),
            ),
          ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
                  (index) => SmallProductImage(
                isSelected: index == selectedImageIndex,
                press: () {
                  setState(() {
                    selectedImageIndex = index;
                  });
                },
                image: widget.images[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}





class SmallProductImage extends StatelessWidget {
  const SmallProductImage({
    Key? key,
    required this.isSelected,
    required this.press,
    required this.image,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback press;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? kPrimaryColor: Colors.transparent,
          ),
        ),
        child: Image.network(
          image,

        ),
      ),
    );
  }
}
