import 'dart:convert';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:makdeck/models/product_model.dart';

import 'package:makdeck/utils/ui/colors.dart';

import 'package:zefyrka/zefyrka.dart';

class ProductInfo extends StatelessWidget {
  final ProductModel product;
  ProductInfo({Key? key, required this.product}) : super(key: key);
  final GlobalKey expansionTileKey = GlobalKey();

  Future<void> launchWhatsApp({required String product}) async {
    final link = WhatsAppUnilink(
      phoneNumber: '+91-7065916587',
      text: "Hey! I'm interested in $product",
    );

    await launch('$link');
  }

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
              padding:
                  EdgeInsets.only(top: 10, bottom: 60, left: 10, right: 10),
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
                  Container(
                    height: MediaQuery.of(context).size.width / 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (product.crueltyFree)
                          Image.asset(
                            'assets/images/cruelty-free.png',
                            height: MediaQuery.of(context).size.width / 6,
                            width: MediaQuery.of(context).size.width / 6,
                          ),
                        if (product.crueltyFree)
                          VerticalDivider(
                            width: 5,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        Image.asset(
                          'assets/images/original.png',
                          height: MediaQuery.of(context).size.width / 6,
                          width: MediaQuery.of(context).size.width / 6,
                        ),
                        VerticalDivider(
                          width: 5,
                          thickness: 2,
                          color: Colors.black,
                        ),
                        Image.asset(
                          'assets/images/quality.png',
                          height: MediaQuery.of(context).size.width / 6,
                          width: MediaQuery.of(context).size.width / 6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    key: expansionTileKey,
                    onExpansionChanged: (value) {
                      if (value) {
                        final keyContext = expansionTileKey.currentContext;
                        if (keyContext != null) {
                          Future.delayed(Duration(milliseconds: 200))
                              .then((value) {
                            Scrollable.ensureVisible(keyContext,
                                duration: Duration(milliseconds: 200));
                          });
                        }
                      }
                    },
                    tilePadding: EdgeInsets.zero,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    childrenPadding: EdgeInsets.zero,
                    title: Text(
                      "Additional Information",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    children: [
                      Text(
                        "Country of Origin: ${product.countryofOrigin}",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Address of Importer: ${product.nameOfImporter}",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Address of Importer: ${product.addressofImporter}",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                if (product.inStocks) {
                  launchWhatsApp(product: product.name);
                }
              },
              child: Container(
                height: 60,
                width: double.infinity,
                color: kPrimaryColor,
                child: Center(
                  child: Text(
                    product.inStocks ? "Buy on WhatsApp" : "Out of Stock",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
