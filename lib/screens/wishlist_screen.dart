import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makdeck/models/Products/product_model.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/Products/product_container.dart';
import 'package:makdeck/widgets/Products/shimer_container.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: StreamBuilder<User?>(
          stream: FirebaseAuthentication.getUserStream,
          builder: (context, snapshot) {
            User? user = snapshot.data;
            if (user == null) {
              return Center(
                child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuthentication.signInWithGoogle();
                    },
                    child: const Text("Log In")),
              );
            }

            return Container(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<List<ProductModel>>(
                future: CloudDatabase().getWishlistProducts(uid: user.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                      itemCount: 2,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.75,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return const ShimmerLoader();
                      },
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 2.8,
                        child: Align(
                          alignment: Alignment.center,
                          child: Center(
                              child: Text(
                            "No Internet Connection",
                            style: Theme.of(context).textTheme.headline5,
                          )),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      List<ProductModel> products = snapshot.data;

                      if (products.isEmpty) {
                        return Center(
                          child: Text(
                            "Empty Wishlist",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        );
                      }
                      return GridView.builder(
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.75,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return ProductContainer(
                            product: products[index],
                          );
                        },
                      );
                    }
                  }

                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2.8,
                    child: Align(
                      alignment: Alignment.center,
                      child: Center(
                          child: Text(
                        "No Internet Connection",
                        style: Theme.of(context).textTheme.headline5,
                      )),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
