import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makdeck/models/Products/product_model.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/Products/product_container.dart';

class AllProducts extends StatelessWidget {
  final String? productCategory;

  const AllProducts({Key? key, this.productCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (productCategory != null) {
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
            child: StreamBuilder(
              stream: CloudDatabase().getProductsbyCategory(
                category: productCategory!,
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  List<ProductModel> products = snapshot.data!.docs
                      .map((QueryDocumentSnapshot<Object?> e) =>
                          ProductModel.fromMap(
                              e.data() as Map<String, dynamic>))
                      .toList();
                  if (products.isEmpty) {
                    return const Center(
                      child: Text("No Products"),
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
                      final product = products[index];
                      return ProductContainer(
                        product: product,
                      );
                    },
                  );
                  // return ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: products.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return ListTile(
                  //       title: Text(products[index].id),
                  //       subtitle: Text(products[index].productDescription),
                  //     );
                  //     // return OrderCard(
                  //     //     orderModel: orders[index],
                  //     //     onTap: () {
                  //     //       Navigator.of(context).push(MaterialPageRoute(
                  //     //           builder: (BuildContext context) {
                  //     //         return OrderUpdateScreen(
                  //     //           orderId: orders[index].orderId,
                  //     //         );
                  //     //       }));
                  //     //     });
                  //   },
                  // );
                }
                return const CircularProgressIndicator();
              },
            ),
            // child: FirestorePagination(
            //   query: CloudDatabase().getProductsbyCategory(
            //     category: productCategory!,
            //   ),
            //   itemBuilder: (context, documentSnapshot, index) {
            //     final data = documentSnapshot.data() as Map<String, dynamic>;
            //     print(data);
            //     final product = ProductModel.fromMap(data);
            //     print(product.id);
            //     return Container();
            //   },
            // ),

            // child: FirestoreQueryBuilder<ProductModel>(
            // query: CloudDatabase().getProductsbyCategory(
            //   category: productCategory!,
            // ),
            //   pageSize: 6,
            //   builder: (context, snapshot, _) {
            //     if (snapshot.isFetching) {
            //       return GridView.builder(
            //         itemCount: 2,
            //         shrinkWrap: true,
            //         gridDelegate:
            //             const SliverGridDelegateWithFixedCrossAxisCount(
            //           childAspectRatio: 0.75,
            //           crossAxisCount: 2,
            //         ),
            //         itemBuilder: (BuildContext context, int index) {
            //           return const ShimmerLoader();
            //         },
            //       );
            //     } else if (snapshot.hasData) {
            //       if (snapshot.hasError) {
            //         return SizedBox(
            //           height: MediaQuery.of(context).size.height / 2.8,
            //           child: Align(
            //             alignment: Alignment.center,
            //             child: Center(
            //                 child: Text(
            //               "No Internet Connection",
            //               textAlign: TextAlign.center,
            //               style: Theme.of(context).textTheme.headlineSmall,
            //             )),
            //           ),
            //         );
            //       }

            //       if (snapshot.hasData) {
            //         if (snapshot.docs.isEmpty) {
            //           return Center(
            //             child: Text(
            //               "No Products Available",
            //               textAlign: TextAlign.center,
            //               style: Theme.of(context).textTheme.headlineMedium,
            //             ),
            //           );
            //         }
            //         return GridView.builder(
            //           itemCount: snapshot.docs.length,
            //           gridDelegate:
            //               const SliverGridDelegateWithFixedCrossAxisCount(
            //             childAspectRatio: 0.75,
            //             crossAxisCount: 2,
            //           ),
            //           itemBuilder: (BuildContext context, int index) {
            //             final hasreachedEnd = snapshot.hasMore &&
            //                 index + 1 == snapshot.docs.length &&
            //                 !snapshot.isFetchingMore;

            //             if (hasreachedEnd) {
            //               snapshot.fetchMore();
            //             }
            //             final product = snapshot.docs[index].data();
            //             return ProductContainer(
            //               product: product,
            //             );
            //           },
            //         );
            //       }
            //     }

            //     return SizedBox(
            //       height: MediaQuery.of(context).size.height / 2.8,
            //       child: Align(
            //         alignment: Alignment.center,
            //         child: Center(
            //             child: Text(
            //           "No Internet Connection",
            //           textAlign: TextAlign.center,
            //           style: Theme.of(context).textTheme.headlineSmall,
            //         )),
            //       ),
            //     );
            //   },
            // ),
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
          child: StreamBuilder(
            stream: CloudDatabase().getProducts(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                List<ProductModel> products = snapshot.data!.docs
                    .map((QueryDocumentSnapshot<Object?> e) =>
                        ProductModel.fromMap(e.data() as Map<String, dynamic>))
                    .toList();
                if (products.isEmpty) {
                  return const Center(
                    child: Text("No Products"),
                  );
                }
                return GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.75,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final product = products[index];
                    return ProductContainer(
                      product: product,
                    );
                  },
                );
                // return ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: products.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return ListTile(
                //       title: Text(products[index].id),
                //       subtitle: Text(products[index].productDescription),
                //     );
                //     // return OrderCard(
                //     //     orderModel: orders[index],
                //     //     onTap: () {
                //     //       Navigator.of(context).push(MaterialPageRoute(
                //     //           builder: (BuildContext context) {
                //     //         return OrderUpdateScreen(
                //     //           orderId: orders[index].orderId,
                //     //         );
                //     //       }));
                //     //     });
                //   },
                // );
              }
              return const CircularProgressIndicator();
            },
          ),
          // child: FirestorePagination(
          //   query: CloudDatabase().getProductsbyCategory(
          //     category: productCategory!,
          //   ),
          //   itemBuilder: (context, documentSnapshot, index) {
          //     final data = documentSnapshot.data() as Map<String, dynamic>;
          //     print(data);
          //     final product = ProductModel.fromMap(data);
          //     print(product.id);
          //     return Container();
          //   },
          // ),

          // child: FirestoreQueryBuilder<ProductModel>(
          // query: CloudDatabase().getProductsbyCategory(
          //   category: productCategory!,
          // ),
          //   pageSize: 6,
          //   builder: (context, snapshot, _) {
          //     if (snapshot.isFetching) {
          //       return GridView.builder(
          //         itemCount: 2,
          //         shrinkWrap: true,
          //         gridDelegate:
          //             const SliverGridDelegateWithFixedCrossAxisCount(
          //           childAspectRatio: 0.75,
          //           crossAxisCount: 2,
          //         ),
          //         itemBuilder: (BuildContext context, int index) {
          //           return const ShimmerLoader();
          //         },
          //       );
          //     } else if (snapshot.hasData) {
          //       if (snapshot.hasError) {
          //         return SizedBox(
          //           height: MediaQuery.of(context).size.height / 2.8,
          //           child: Align(
          //             alignment: Alignment.center,
          //             child: Center(
          //                 child: Text(
          //               "No Internet Connection",
          //               textAlign: TextAlign.center,
          //               style: Theme.of(context).textTheme.headlineSmall,
          //             )),
          //           ),
          //         );
          //       }

          //       if (snapshot.hasData) {
          //         if (snapshot.docs.isEmpty) {
          //           return Center(
          //             child: Text(
          //               "No Products Available",
          //               textAlign: TextAlign.center,
          //               style: Theme.of(context).textTheme.headlineMedium,
          //             ),
          //           );
          //         }
          //         return GridView.builder(
          //           itemCount: snapshot.docs.length,
          //           gridDelegate:
          //               const SliverGridDelegateWithFixedCrossAxisCount(
          //             childAspectRatio: 0.75,
          //             crossAxisCount: 2,
          //           ),
          //           itemBuilder: (BuildContext context, int index) {
          //             final hasreachedEnd = snapshot.hasMore &&
          //                 index + 1 == snapshot.docs.length &&
          //                 !snapshot.isFetchingMore;

          //             if (hasreachedEnd) {
          //               snapshot.fetchMore();
          //             }
          //             final product = snapshot.docs[index].data();
          //             return ProductContainer(
          //               product: product,
          //             );
          //           },
          //         );
          //       }
          //     }

          //     return SizedBox(
          //       height: MediaQuery.of(context).size.height / 2.8,
          //       child: Align(
          //         alignment: Alignment.center,
          //         child: Center(
          //             child: Text(
          //           "No Internet Connection",
          //           textAlign: TextAlign.center,
          //           style: Theme.of(context).textTheme.headlineSmall,
          //         )),
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
