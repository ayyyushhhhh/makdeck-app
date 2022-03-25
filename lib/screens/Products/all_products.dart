import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:makdeck/models/Products/product_model.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/Products/product_container.dart';
import 'package:makdeck/widgets/Products/shimer_container.dart';

class AllProducts extends StatelessWidget {
  final String? productCategory;

  const AllProducts({Key? key, this.productCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (productCategory != "") {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.navigate_before,
                color: Colors.black,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              productCategory!,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            // actions: [
            // IconButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (BuildContext context) {
            //           return const SearchProductsScreen();
            //         },
            //       ),
            //     );
            //   },
            //   icon: const Icon(
            //     Icons.search,
            //     color: Colors.black,
            //   ),
            // ),
            // ],
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: FirestoreQueryBuilder<ProductModel>(
              query: CloudDatabase().getProductsbyCategory(
                category: productCategory!,
              ),
              pageSize: 6,
              builder: (context, snapshot, _) {
                if (snapshot.isFetching) {
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
                } else if (snapshot.hasData) {
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
                    if (snapshot.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "No Products Available",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      );
                    }
                    return GridView.builder(
                      itemCount: snapshot.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.75,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final hasreachedEnd = snapshot.hasMore &&
                            index + 1 == snapshot.docs.length &&
                            !snapshot.isFetchingMore;

                        if (hasreachedEnd) {
                          snapshot.fetchMore();
                        }
                        final product = snapshot.docs[index].data();
                        return ProductContainer(
                          product: product,
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
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.navigate_before,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'All Products',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          // actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) {
          //           return const SearchProductsScreen();
          //         },
          //       ),
          //     );
          //   },
          //   icon: const Icon(
          //     Icons.search,
          //     color: Colors.black,
          //   ),
          // ),
          // ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: FirestoreQueryBuilder<ProductModel>(
            query: CloudDatabase().getProductsData(),
            pageSize: 6,
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
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
              } else if (snapshot.hasData) {
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
                  if (snapshot.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No Products Available",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    );
                  }
                  return GridView.builder(
                    itemCount: snapshot.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.75,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final hasreachedEnd = snapshot.hasMore &&
                          index + 1 == snapshot.docs.length &&
                          !snapshot.isFetchingMore;

                      if (hasreachedEnd) {
                        snapshot.fetchMore();
                      }
                      final product = snapshot.docs[index].data();
                      return ProductContainer(
                        product: product,
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
      ),
    );
  }
}
