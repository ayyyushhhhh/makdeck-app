import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:makdeck/models/Cart/cart_product.dart';
import 'package:makdeck/models/Cart/order_model.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/users/user_firebasedatabase.dart';
import 'package:makdeck/utils/ui/colors.dart';

class UserOrderScreen extends StatelessWidget {
  const UserOrderScreen({Key? key}) : super(key: key);

  int getQuantity({
    required List<CartProductModel> products,
  }) {
    int quantity = 0;
    for (int i = 0; i < products.length; i++) {
      quantity += products[i].numOfItems;
    }
    return quantity;
  }

  double getPrice({
    required List<CartProductModel> products,
  }) {
    double price = 0;
    for (int i = 0; i < products.length; i++) {
      price += products[i].price;
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
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
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Color(0xFF8c52ff),

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: double.infinity,
        child: StreamBuilder(
            stream: UserDataBase()
                .retrieveUserOrders(uid: FirebaseAuthentication.getUserUid),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                List<OrderModel> orders = snapshot.data!.docs
                    .map((QueryDocumentSnapshot<Object?> e) =>
                        OrderModel.fromMap(e.data() as Map<String, dynamic>))
                    .toList();
                if (orders.isEmpty) {
                  return const Center(
                    child: Text("No Orders Yet"),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    OrderModel orderModel = orders[index];
                    final List<CartProductModel> products =
                        orderModel.cartproducts;

                    return Card(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Order ID : ${orderModel.orderid}",
                              style:
                                  TextStyle(fontSize: 12, color: kPrimaryColor),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Quantity : ${getQuantity(products: products)}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Total Amount : ₹ ${getPrice(products: products)}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Ordered on : ${DateFormat.yMMMMd('en_US').format(DateTime.parse(orderModel.orderTime))}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Column(
                              children: List.generate(
                                products.length,
                                (index) => Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: products[index].image),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            products[index].productName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            "Quantiy : ${products[index].numOfItems}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const CircularProgressIndicator();
            }),
        // child: FutureBuilder<List<OrderModel>>(
        //   future: UserDataBase()
        //       .getUserOrders(uid: FirebaseAuthentication.getUserUid),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return GridView.builder(
        //         itemCount: 2,
        //         shrinkWrap: true,
        //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //           childAspectRatio: 0.75,
        //           crossAxisCount: 2,
        //         ),
        //         itemBuilder: (BuildContext context, int index) {
        //           return const ShimmerLoader();
        //         },
        //       );
        //     } else if (snapshot.hasData) {
        //       if (snapshot.data!.isEmpty) {
        //         return Center(
        //           child: Text(
        //             "Empty Wishlist",
        //             style: Theme.of(context).textTheme.headlineMedium,
        //           ),
        //         );
        //       }
        //       List<OrderModel> orders = snapshot.data!;

        //     }
        //     if (snapshot.hasError) {

        //       return SizedBox(
        //         height: MediaQuery.of(context).size.height / 2.8,
        //         child: Align(
        //           alignment: Alignment.center,
        //           child: Center(
        //               child: Text(
        //             "No Internet Connection",
        //             style: Theme.of(context).textTheme.headlineSmall,
        //           )),
        //         ),
        //       );
        //     }

        //     return SizedBox(
        //       height: MediaQuery.of(context).size.height / 2.8,
        //       child: Align(
        //         alignment: Alignment.center,
        //         child: Center(
        //             child: Text(
        //           "No Internet Connection",
        //           style: Theme.of(context).textTheme.headlineSmall,
        //         )),
        //       ),
        //     );
        //   },
        // )

        // child: FirestoreListView<OrderModel>(
        //   shrinkWrap: true,

        //   itemBuilder: (BuildContext context, snapshot) {
        //     final OrderModel order = snapshot.data();
        //     final List<CartProductModel> products = order.cartproducts;
        //     return ListView.builder(
        //       shrinkWrap: true,
        //       itemCount: products.length,
        //       physics: const ClampingScrollPhysics(),
        //       itemBuilder: (BuildContext context, int index) {
        //         return Card(
        //           child: Container(
        //             padding: const EdgeInsets.all(20),
        //             color: Colors.white,
        //             height: 170,
        //             child: Row(
        //               children: [
        //                 ClipRRect(
        //                   borderRadius: BorderRadius.circular(10),
        //                   child: SizedBox(
        //                     width: 100,
        //                     height: 100,
        //                     child: CachedNetworkImage(
        //                         fit: BoxFit.cover,
        //                         imageUrl: products[index].image),
        //                   ),
        //                 ),
        //                 const SizedBox(
        //                   width: 6,
        //                 ),
        //                 Expanded(
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         products[index].productName,
        //                         style: const TextStyle(
        //                             fontWeight: FontWeight.bold, fontSize: 12),
        //                         overflow: TextOverflow.ellipsis,
        //                         maxLines: 3,
        //                       ),
        //                       const SizedBox(
        //                         height: 6,
        //                       ),
        //                       Text(
        //                         "Order ID : ${order.orderid}",
        //                         style: TextStyle(
        //                             fontSize: 12, color: kPrimaryColor),
        //                       ),
        //                       const SizedBox(
        //                         height: 6,
        //                       ),
        //                       Text(
        //                         "Quantiy : ${products[index].numOfItems}",
        //                         style: const TextStyle(
        //                             fontSize: 12, color: Colors.black),
        //                       ),
        //                       const SizedBox(
        //                         height: 6,
        //                       ),
        //                       Text(
        //                         "Total Amount : ₹ ${products[index].price}",
        //                         style: const TextStyle(
        //                             fontSize: 12, color: Colors.black),
        //                       ),
        //                       const SizedBox(
        //                         height: 6,
        //                       ),
        //                       Text(
        //                         "Ordered on : ${DateFormat.yMMMMd('en_US').format(DateTime.parse(order.orderTime))}",
        //                         style: const TextStyle(
        //                             fontSize: 12, color: Colors.black),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //                 const SizedBox(
        //                   width: 10,
        //                 ),
        //               ],
        //             ),
        //           ),
        //         );
        //       },
        //     );
        //   },
        // ),
      ),
    );
  }
}
