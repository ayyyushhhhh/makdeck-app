// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makdeck/models/Cart/cart_product.dart';
import 'package:makdeck/models/Cart/cart_screen_model.dart';
import 'package:makdeck/models/Cart/order_model.dart';
import 'package:makdeck/screens/address_payment_screen.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/utils/ui/colors.dart';

// ignore: must_be_immutable
class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late OrderModel orderModel;
  double totalCost = 0;

  Widget _buildCartItem(CartProductModel productModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      height: 150,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                  fit: BoxFit.cover, imageUrl: productModel.image),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productModel.productName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  height: 22,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(width: 1, color: Colors.black54)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Quantity : ',
                        style: TextStyle(color: kPrimaryColor, fontSize: 10),
                      ),
                      Text(
                        productModel.numOfItems.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text("₹ " + productModel.price.toString(),
              style: const TextStyle(fontSize: 16))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: kPrimaryColor,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      body: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (index < CartScreenModel.cartProducts.length) {
              CartProductModel cartProduct =
                  CartScreenModel.cartProducts[index];

              return _buildCartItem(cartProduct);
            }
            for (int i = 0; i < CartScreenModel.cartProducts.length; i++) {
              CartProductModel cartProduct = CartScreenModel.cartProducts[i];
              totalCost += cartProduct.price;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Cost:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "₹" + totalCost.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 1,
              color: Colors.grey,
            );
          },
          itemCount: CartScreenModel.cartProducts.length + 1),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(color: Theme.of(context).primaryColor, boxShadow: [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, -1), blurRadius: 6),
        ]),
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (FirebaseAuthentication.isLoggedIn() == true) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return AddressPaymentScreen(totalPrice: totalCost);
                }));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 2,
                    backgroundColor: Colors.black,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Please Log in to Continue"),
                      ],
                    ),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: "OK",
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              }
            },
            child: Text(
              'PLACE ORDER',
              style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 1.2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
