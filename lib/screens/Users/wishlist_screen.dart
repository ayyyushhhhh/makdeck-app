import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makdeck/models/Products/product_model.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/users/user_firebasedatabase.dart';
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
                  future: UserDataBase().retrieveWishlist(uid: user.uid),
                  builder: (context, snapshot) {
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
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "Empty Wishlist",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        );
                      }
                      return GridView.builder(
                        itemCount: snapshot.data!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.75,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final product = snapshot.data![index];
                          return ProductContainer(
                            product: product,
                          );
                        },
                      );
                    }
                    if (snapshot.hasError) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 2.8,
                        child: Align(
                          alignment: Alignment.center,
                          child: Center(
                              child: Text(
                            "No Internet Connection",
                            style: Theme.of(context).textTheme.headlineSmall,
                          )),
                        ),
                      );
                    }

                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 2.8,
                      child: Align(
                        alignment: Alignment.center,
                        child: Center(
                            child: Text(
                          "No Internet Connection",
                          style: Theme.of(context).textTheme.headlineSmall,
                        )),
                      ),
                    );
                  },
                )

                // child: FirestoreQueryBuilder<ProductModel>(
                //   query: UserDataBase().getWishlistProducts(uid: user.uid),
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
                //       if (snapshot.docs.isEmpty) {
                //         return Center(
                //           child: Text(
                //             "Empty Wishlist",
                //             style: Theme.of(context).textTheme.headlineMedium,
                //           ),
                //         );
                //       }
                //       return GridView.builder(
                //         itemCount: snapshot.docs.length,
                //         gridDelegate:
                //             const SliverGridDelegateWithFixedCrossAxisCount(
                //           childAspectRatio: 0.75,
                //           crossAxisCount: 2,
                //         ),
                //         itemBuilder: (BuildContext context, int index) {
                //           final hasreachedEnd = snapshot.hasMore &&
                //               index + 1 == snapshot.docs.length &&
                //               !snapshot.isFetchingMore;

                //           if (hasreachedEnd) {
                //             snapshot.fetchMore();
                //           }
                //           final product = snapshot.docs[index].data();
                //           return ProductContainer(
                //             product: product,
                //           );
                //         },
                //       );
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
                // ),
                );
          }),
    );
  }
}
