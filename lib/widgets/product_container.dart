import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makdeck/models/product_model.dart';
import 'package:makdeck/screens/product_info.dart';

class ProductContainer extends StatelessWidget {
  final ProductModel product;
  ProductContainer({Key? key, required this.product}) : super(key: key);
  final NumberFormat _formatter = NumberFormat('#,###');
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
        // width: MediaQuery.of(context).size.width / 2.3,
        // height: MediaQuery.of(context).size.height / 2.8,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 0),
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
              child: CachedNetworkImage(
                imageUrl: product.images[0],
                errorWidget: (context, url, error) => Container(
                  color: Colors.white,
                ),
                fit: BoxFit.cover,
                width: width / 2.5,
                height: width / 2.5,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width / 35,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '₹ ${_formatter.format(int.parse(product.originalPrice))}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width / 38,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    TextSpan(
                      text: ' ₹ ${_formatter.format(int.parse(product.mrp))}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width / 40,
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
