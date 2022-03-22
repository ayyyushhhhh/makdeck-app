import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:makdeck/models/Cart/cart_product.dart';
import 'package:makdeck/models/Cart/cart_screen_model.dart';
import 'package:makdeck/screens/cart_screen.dart';
import 'package:makdeck/widgets/Products/product_images_coursel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:makdeck/models/Review/review_model.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/review/reviews_lists.dart';
import 'package:makdeck/widgets/review/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:makdeck/models/Products/product_model.dart';

import 'package:makdeck/utils/ui/colors.dart';

import 'package:zefyrka/zefyrka.dart';

// ignore: must_be_immutable
class ProductInfo extends StatelessWidget {
  final ProductModel product;
  ProductInfo({Key? key, required this.product}) : super(key: key);
  final GlobalKey additionalInfoexpansionTileKey = GlobalKey();
  final GlobalKey ingredientsexpansionTileKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NumberFormat _formatter = NumberFormat('#,###', "en_IN");

  // Product Data Variables
  int _quantity = 1;

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

  void openLoadingScafold(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        backgroundColor: Colors.black,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: "View Cart",
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const CartScreen();
            }));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double discout =
        ((double.parse(product.originalPrice) - double.parse(product.mrp)) /
                double.parse(product.originalPrice)) *
            100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.white10,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
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
                            _formatter.format(int.parse(product.originalPrice)),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      TextSpan(
                        text:
                            '  ₹ ' + _formatter.format(int.parse(product.mrp)),
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
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                const Divider(),
                StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _quantity--;
                            });
                          },
                          icon: const Icon(
                            CupertinoIcons.minus,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _quantity.toString(),
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                          icon: const Icon(
                            CupertinoIcons.add,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Divider(),
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
                  margin: const EdgeInsets.only(top: 20),
                  child: ExpansionTile(
                    key: ingredientsexpansionTileKey,
                    onExpansionChanged: (value) {
                      if (value) {
                        final keyContext =
                            ingredientsexpansionTileKey.currentContext;
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
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    children: [
                      ZefyrEditor(
                        showCursor: false,
                        enableInteractiveSelection: false,
                        controller: ZefyrController(
                          NotusDocument.fromJson(
                              jsonDecode(product.ingredients)),
                        ),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                    key: additionalInfoexpansionTileKey,
                    onExpansionChanged: (value) {
                      if (value) {
                        final keyContext =
                            additionalInfoexpansionTileKey.currentContext;
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
              height: MediaQuery.of(context).size.height / 12,
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  if (product.inStocks) {
                    CartProductModel cartProduct = CartProductModel(
                        productName: product.name,
                        productId: product.id,
                        numOfItems: _quantity,
                        price: double.parse(product.mrp),
                        image: product.images[0]);
                    openLoadingScafold(
                        message: "Product Added to Cart", context: context);
                    CartScreenModel.cartProducts.add(cartProduct);
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 14,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Text(
                      product.inStocks ? "🛒 ADD TO CART" : "Out of Stock",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ]),
    );
  }
}
