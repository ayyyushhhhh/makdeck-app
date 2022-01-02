import 'package:flutter/material.dart';

class CategoryContainer extends StatelessWidget {
  final String title;
  final String image;
  const CategoryContainer({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
              "assets/images/$image.png",
              height: 50,
              width: 50,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
