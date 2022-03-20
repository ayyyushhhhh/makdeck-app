import 'dart:convert';
import 'dart:math';
import 'package:makdeck/widgets/Products/product_images_coursel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:makdeck/models/Review/review_model.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/review/reviews_lists.dart';
import 'package:makdeck/widgets/review/star_rating.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:makdeck/models/Products/product_model.dart';

import 'package:makdeck/utils/ui/colors.dart';

import 'package:zefyrka/zefyrka.dart';

class ProductInfo extends StatelessWidget {
  final ProductModel product;
  ProductInfo({Key? key, required this.product}) : super(key: key);
  final GlobalKey expansionTileKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NumberFormat _formatter = NumberFormat('#,###', "en_IN");

  Future<void> _launchWhatsApp({required String product}) async {
    final String phoneNumber = await CloudDatabase().getContactNumber();

    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: "Hey! I'm interested in $product",
    );

    await launch('$link');
  }

  Future<void> _launchcall() async {
    final String phoneNumber = await CloudDatabase().getContactNumber();

    final url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _addRatingModal(BuildContext context, double deviceWidth) async {
    User? user = await FirebaseAuthentication.getUserStream.first;
    ReviewModel review = await CloudDatabase()
        .getReview(productID: product.id, uid: user!.uid.toString());
    _scaffoldKey.currentState!.showBottomSheet<void>((BuildContext context) {
      int stars = review.rating;
      String reviewComment = review.review;
      return Container(
        width: deviceWidth,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Rate the Product",
                style: Theme.of(context).textTheme.headline4,
              ),
              StarRating(
                onRatingChanged: (rating) {
                  stars = rating;
                },
                rating: stars,
              ),
              TextField(
                controller: TextEditingController(text: reviewComment),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                minLines: null,
                maxLines: null,
                onChanged: (value) {
                  reviewComment = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(10)),
                  labelText: "Review",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        final reviewID = Random().nextInt(1000000).toString();
                        if (stars != 0) {
                          final review = ReviewModel(
                            id: reviewID,
                            rating: stars,
                            review: reviewComment,
                            date: DateTime.now().toIso8601String(),
                            userId: user.uid,
                            userName: user.displayName.toString(),
                          ).toMap();
                          CloudDatabase().uploadReview(
                              productId: product.id,
                              review: review,
                              reviewId: user.uid);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Submit")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double discout =
        ((double.parse(product.originalPrice) - double.parse(product.mrp)) /
                double.parse(product.originalPrice)) *
            100;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: 10,
                  bottom: MediaQuery.of(context).size.height / 12,
                  left: 10,
                  right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                    ),
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProductImagesCaursel(
                    product: product,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "₹ " +
                              _formatter
                                  .format(int.parse(product.originalPrice)),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        TextSpan(
                          text: '  ₹ ' +
                              _formatter.format(int.parse(product.mrp)),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        TextSpan(
                          text: '  (${discout.round()}% off)',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ),
                        const TextSpan(
                          text: '\nInclusive of all taxes',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                            text: "Size -",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        TextSpan(
                          text: " ${product.quantity}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FutureBuilder(
                    future: CloudDatabase().getRatings(productID: product.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        final double rating = snapshot.data;

                        return Row(
                          children: [
                            const Text(
                              "Ratings - ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  rating.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.white),
                                ))),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Text(
                              "Ratings - ",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Center(
                                child: Text(
                                  "0.0",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
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
                  SizedBox(
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
                          const VerticalDivider(
                            width: 5,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        Image.asset(
                          'assets/images/original.png',
                          height: MediaQuery.of(context).size.width / 6,
                          width: MediaQuery.of(context).size.width / 6,
                        ),
                        const VerticalDivider(
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
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ExpansionTile(
                      key: expansionTileKey,
                      onExpansionChanged: (value) {
                        if (value) {
                          final keyContext = expansionTileKey.currentContext;
                          if (keyContext != null) {
                            Future.delayed(const Duration(milliseconds: 200))
                                .then((value) {
                              Scrollable.ensureVisible(keyContext,
                                  duration: const Duration(milliseconds: 200));
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
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Name of Importer / Manufacturer: ${product.nameOfImporter}",
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Address of Importer / Manufacturer: ${product.addressofImporter}",
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (FirebaseAuthentication.isLoggedIn())
                    GestureDetector(
                        onTap: () {
                          _addRatingModal(
                              context, MediaQuery.of(context).size.width);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: const ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Write a Review",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            leading: Icon(
                              Icons.rate_review,
                              size: 30,
                            ),
                          ),
                        )),
                  const SizedBox(
                    height: 10,
                  ),
                  ReviewsListView(productId: product.id),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 12 + 10,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    if (product.inStocks) {
                      _launchWhatsApp(product: product.name);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 12,
                        width: MediaQuery.of(context).size.width / 2 - 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: kPrimaryColor,
                        ),
                        child: Center(
                          child: Text(
                            product.inStocks
                                ? "Buy via WhatsApp"
                                : "Out of Stock",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          if (product.inStocks) {
                            _launchcall();
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: kPrimaryColor,
                          ),
                          child: Center(
                            child: Text(
                              product.inStocks
                                  ? "Buy via Call"
                                  : "Out of Stock",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ]),
      ),
    );
  }
}
