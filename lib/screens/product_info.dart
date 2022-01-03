import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:makdeck/models/product_model.dart';

import 'package:makdeck/utils/ui/colors.dart';

import 'package:zefyrka/zefyrka.dart';

class ProductInfo extends StatelessWidget {
  final ProductModel product;
  ProductInfo({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double discout =
        ((double.parse(product.originalPrice) - double.parse(product.mrp)) /
                double.parse(product.originalPrice)) *
            100;

    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                    ),
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: MediaQuery.of(context).size.height / 2.5,
                      aspectRatio: 1 / 1,
                      enableInfiniteScroll: false,
                    ),
                    items: product.images.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Image.network(
                              image,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\₹ ' + product.originalPrice.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        TextSpan(
                          text: '  \₹ ' + product.mrp.toString(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        TextSpan(
                          text: '  (${discout.round()}% off)',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ),
                        TextSpan(
                          text: '\nInclusive of all taxes',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "About the Product ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  ZefyrEditor(
                    showCursor: false,
                    enableInteractiveSelection: false,
                    controller: ZefyrController(
                      NotusDocument.fromJson(
                          jsonDecode(product.productDescription)),
                    ),
                    readOnly: true,
                  ),
                  Text(
                    "Features",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  ZefyrEditor(
                    showCursor: false,
                    enableInteractiveSelection: false,
                    controller: ZefyrController(
                      NotusDocument.fromJson(jsonDecode(product.features)),
                    ),
                    readOnly: true,
                  ),
                  Text(
                    "Benefits",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  ZefyrEditor(
                    showCursor: false,
                    enableInteractiveSelection: false,
                    controller: ZefyrController(
                      NotusDocument.fromJson(jsonDecode(product.benefits)),
                    ),
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              width: double.infinity,
              color: kPrimaryColor,
              child: Center(
                child: Text(
                  "Buy on WhatsApp",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
