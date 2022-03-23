// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makdeck/models/Cart/cart_product.dart';
import 'package:makdeck/models/Cart/cart_screen_model.dart';
import 'package:makdeck/models/Cart/order_model.dart';
import 'package:makdeck/utils/ui/colors.dart';

// ignore: must_be_immutable
class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late OrderModel orderModel;

  void showDeliveryDetailsModal(BuildContext context1, double deviceWidth) {
    String name = "";
    String phone = "";
    String address = "";
    String city = "";
    String state = "";
    String pincode = "";
    String useremail = "";
    String userid = "";

    showModalBottomSheet<void>(
      context: context1,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      iconSize: 40,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value != "") {
                          name = value;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        fillColor: Colors.white10,
                        filled: true,
                        label: Text("Full Name"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value != "") {
                          useremail = value;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        fillColor: Colors.white10,
                        filled: true,
                        label: Text("Email Address"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value != "") {
                          phone = value;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        fillColor: Colors.white10,
                        filled: true,
                        label: Text("Phone Number"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      onChanged: (value) {
                        if (value != "") {
                          address = value;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        fillColor: Colors.white10,
                        filled: true,
                        label: Text("Address"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value != "") {
                          address += value;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        fillColor: Colors.white10,
                        filled: true,
                        label: Text("Pin Code"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value != "") {
                          address += value;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        fillColor: Colors.white10,
                        filled: true,
                        label: Text("State"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value != "") {
                          address += value;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        fillColor: Colors.white10,
                        filled: true,
                        label: Text("City"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          orderModel = OrderModel(
                              cartproducts: [],
                              orderDate: '',
                              orderid: '',
                              orderStatus: OrderStatus.pending,
                              orderTime: '',
                              paymentAmount: 0,
                              paymentMethod: PaymentMethod.cashOnDelivery,
                              trackingID: '',
                              userAddress: '',
                              userEmail: '',
                              userPaymentMethod: '',
                              userPhone: '',
                              userUID: '');
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 20,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "cancel",
                          style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
            double totalCost = 0;

            if (index < CartScreenModel.cartProducts.length) {
              CartProductModel cartProduct =
                  CartScreenModel.cartProducts[index];
              totalCost += cartProduct.price;

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
                    ],
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text(
                    "Payment Method",
                    style: TextStyle(fontSize: 20, color: kPrimaryColor),
                  ),
                ),
                ListTile(
                  title: const Text('Cash on Delivery'),
                  leading: Radio<PaymentMethod>(
                    value: PaymentMethod.cashOnDelivery,
                    onChanged: (value) {
                      print(value);
                    },
                    groupValue: PaymentMethod.cashOnDelivery,
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: () {
                    showDeliveryDetailsModal(
                        context, MediaQuery.of(context).size.width);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Text(
                      "Add Order Details",
                      style: TextStyle(fontSize: 20, color: kPrimaryColor),
                    ),
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
    );
  }
}
