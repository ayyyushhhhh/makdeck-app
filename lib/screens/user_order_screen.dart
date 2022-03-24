import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:intl/intl.dart';
import 'package:makdeck/models/Cart/cart_product.dart';
import 'package:makdeck/models/Cart/order_model.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/users/user_firebasedatabase.dart';
import 'package:makdeck/utils/ui/colors.dart';

class UserOrderScreen extends StatelessWidget {
  const UserOrderScreen({Key? key}) : super(key: key);

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
            color: Colors.white,
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
        child: FirestoreListView<OrderModel>(
          query: UserDataBase()
              .getUserOrders(uid: FirebaseAuthentication.getUserUid),
          itemBuilder: (BuildContext context, snapshot) {
            final OrderModel order = snapshot.data();
            final List<CartProductModel> products = order.cartproducts;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    height: 170,
                    child: Row(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].productName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Order ID : " + order.orderid,
                                style: TextStyle(
                                    fontSize: 12, color: kPrimaryColor),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Quantiy : " +
                                    products[index].numOfItems.toString(),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Total Amount : ₹ " +
                                    products[index].price.toString(),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Ordered on : " +
                                    DateFormat.yMMMMd('en_US').format(
                                        DateTime.parse(order.orderTime)),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
