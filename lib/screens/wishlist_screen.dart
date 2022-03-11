import 'package:flutter/material.dart';
import 'package:makdeck/models/Products/product_model.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/Products/shimer_container.dart';
import 'package:makdeck/widgets/Products/wishlist_product_container.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<ProductModel>>(
          future: CloudDatabase()
              .getWishlistProducts(uid: FirebaseAuthentication.getUserUid),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                itemCount: 2,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                final wishlistProducts = products;
                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      "Empty WishList",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return WishlistProductContainer(
                      productModel: wishlistProducts[index],
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
      ),
    );
  }
}
