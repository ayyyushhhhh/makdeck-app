import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:makdeck/models/Products/product_model.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/utils/ui/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ProductImagesCaursel extends StatefulWidget {
  final ProductModel product;
  const ProductImagesCaursel({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductImagesCaursel> createState() => _ProductImagesCaurselState();
}

class _ProductImagesCaurselState extends State<ProductImagesCaursel> {
  final ScreenshotController _screenshotController = ScreenshotController();
  List<String> wishlistproducts = [];
  Future<void> _shareScreenshot(ScreenshotController controller) async {
    final imageBytes = await _screenshotController.capture();
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/screenshot${DateTime.now()}.png');
    if (imageBytes != null) {
      image.writeAsBytesSync(imageBytes);

      const String appURl =
          "https://play.google.com/store/apps/details?id=com.scarecrowhouse.makdeck";
      await Share.shareFiles(
        [image.path],
        text:
            "Check this out ${widget.product.name} on makdeck. Download the app now - $appURl ",
      );
    }
  }

  Future<List<String>> _getWishlist() async {
    return await CloudDatabase()
        .getWishlistProductsid(uid: FirebaseAuthentication.getUserUid);
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuthentication.isLoggedIn() == true) {
      _getWishlist().then((value) {
        setState(() {
          wishlistproducts = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Screenshot(
          controller: _screenshotController,
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              height: MediaQuery.of(context).size.height / 2.5,
              aspectRatio: 1 / 1,
              enableInfiniteScroll: false,
            ),
            items: widget.product.images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.white,
                      ),
                      fit: BoxFit.contain,
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Positioned(
          right: 20,
          top: 10,
          child: IconButton(
            onPressed: () {
              _shareScreenshot(_screenshotController);
            },
            icon: Icon(
              Icons.share_rounded,
              color: kPrimaryColor,
              size: 30,
            ),
          ),
        ),
        Positioned(
            right: 60,
            top: 10,
            child: IconButton(
              onPressed: () {
                if (!wishlistproducts.contains(widget.product.id)) {
                  if (FirebaseAuthentication.isLoggedIn() == false) {
                    Fluttertoast.showToast(
                        msg: "Please Log in before Wishlisting a Product",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }

                  setState(() {
                    CloudDatabase().addProducttoWishlist(
                        product: widget.product,
                        uid: FirebaseAuthentication.getUserUid);
                    _getWishlist().then((value) {
                      setState(() {
                        wishlistproducts = value;
                      });
                    });
                  });
                } else {
                  setState(() {
                    CloudDatabase().deleteProductFromWishlist(
                        productID: widget.product.id,
                        uid: FirebaseAuthentication.getUserUid);
                    _getWishlist().then((value) {
                      setState(() {
                        wishlistproducts = value;
                      });
                    });
                  });
                }
              },
              icon: Icon(
                Icons.favorite,
                color: wishlistproducts.contains(widget.product.id)
                    ? kPrimaryColor
                    : Colors.grey,
                size: 30,
              ),
            )),
      ],
    );
  }
}
