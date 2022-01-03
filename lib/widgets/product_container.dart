import 'package:flutter/material.dart';
import 'package:makdeck/models/product_model.dart';
import 'package:makdeck/screens/product_info.dart';

class ProductContainer extends StatelessWidget {
  final ProductModel product;
  const ProductContainer({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductInfo(product: product);
            },
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        height: MediaQuery.of(context).size.height / 2.8,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0, 0),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.network(
                product.images[0],
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.width / 2.5,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '₹ ${product.originalPrice}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    TextSpan(
                      text: '  ₹ ${product.mrp}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
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
}
