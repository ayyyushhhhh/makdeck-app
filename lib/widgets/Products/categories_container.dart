import 'package:flutter/material.dart';

class CategoryContainer extends StatelessWidget {
  final String title;
  final String image;
  const CategoryContainer({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
              "assets/images/$image.png",
              height: width / 12,
              width: width / 12,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(fontSize: width / 25),
          ),
        ],
      ),
    );
  }
}
