import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makdeck/screens/Products/all_products.dart';
import 'package:makdeck/screens/Cart/cart_screen.dart';
import 'package:makdeck/screens/Users/wishlist_screen.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';

import 'package:makdeck/utils/ui/colors.dart';
import 'package:makdeck/widgets/Products/categories_container.dart';
import 'package:makdeck/widgets/Drawer/drawer_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _categories = [
    "Skincare",
    "Makeup",
    "Anti-Aging",
    "Skin Protection",
    "Hair Care",
    "Personal Care",
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.white,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: kPrimaryColor,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: Image.asset(
          "assets/images/Makdeck_logo.png",
          fit: BoxFit.contain,
          height: 60,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const WishListScreen();
              }));
            },
            icon: const Icon(Icons.favorite_outline),
            color: kPrimaryColor,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const CartScreen();
              }));
            },
            icon: const Icon(Icons.shopping_cart),
            color: kPrimaryColor,
          ),
        ],
      ),
      drawer: const DrawerContainer(),
      body: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<User?>(
                    stream: FirebaseAuthentication.getUserStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        User user = snapshot.data;
                        final name = user.displayName!.split(" ");
                        return Text(
                          "Hi ${name[0]},",
                          style: TextStyle(
                            fontSize: width / 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      }
                      return Text(
                        "Hi,",
                        style: TextStyle(
                          fontSize: width / 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    child: Text(
                      "Discover Your Products",
                      style: TextStyle(
                        fontSize: width / 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: width / 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 5,
                    width: width / 50 * "Categories".length,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 7,
              child: Center(
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllProducts(
                              productCategory: _categories[index],
                            ),
                          ),
                        );
                      },
                      child: CategoryContainer(
                          title: _categories[index], image: _categories[index]),
                    );
                  },
                ),
              ),
            ),
            // SizedBox(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Our Products",
            //         style: TextStyle(
            //           fontSize: width / 15,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.grey,
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 5,
            //       ),
            //       Container(
            //         height: 5,
            //         color: kPrimaryColor,
            //         width: width / 50 * "Our Products".length,
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Products",
                    style: TextStyle(
                      fontSize: width / 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 5,
                    width: width / 50 * "Categories".length,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Color(0xff2a93b5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Unveil Your True Beauty",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          width: 170,
                          child: Text(
                            "Discover premium beauty products tailored to your unique style. From skincare to makeup, find everything you need to shine",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                // kPrimaryColor.withOpacity(.16),
                                Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const AllProducts();
                            }));
                          },
                          child: const Text(
                            "Explore our Products",
                            style: TextStyle(
                                color: Color(0xff2a93b5),
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/woman.png",
                          fit: BoxFit.contain,
                          height: 180,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // FirestorePagination(
            //   limit: 6,
            //   query: CloudDatabase().getProductsData(),
            //   itemBuilder: (context, documentSnapshot, index) {
            //     final data = documentSnapshot.data() as Map<String, dynamic>;
            //     final product = ProductModel.fromMap(data);
            //     print(product.id);
            //     return Container();
            //   },
            // ),
            // FirestoreQueryBuilder<ProductModel>(
            //   query: CloudDatabase().getProductsData(),
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
            //       return GridView.builder(
            //           itemCount: 2,
            //           shrinkWrap: true,
            //           gridDelegate:
            //               const SliverGridDelegateWithFixedCrossAxisCount(
            //             childAspectRatio: 0.75,
            //             crossAxisCount: 2,
            //           ),
            //           itemBuilder: (BuildContext context, int index) {
            //             //     final hasreachedEnd = snapshot.hasMore &&
            //             //     index + 1 == snapshot.docs.length &&

            //             // if (hasreachedEnd) {
            //             //   snapshot.fetchMore();
            //             // }
            //             final product = snapshot.docs[index].data();
            //             return ProductContainer(
            //               product: product,
            //             );
            //           });
            //       // } else {
            //       //   return SizedBox(
            //       //     height: MediaQuery.of(context).size.height / 2.8,
            //       //     child: Align(
            //       //       alignment: Alignment.center,
            //       //       child: Center(
            //       //           child: Text(
            //       //         "No Internet Connection",
            //       //         style: Theme.of(context).textTheme.headline5,
            //       //       )),
            //       //     ),
            //       //   );
            //       // }
            //     } else if (snapshot.hasError) {
            //       return SizedBox(
            //         height: MediaQuery.of(context).size.height / 2.8,
            //         child: const Align(
            //           alignment: Alignment.center,
            //           child: Center(child: Text("No Internet Connection")),
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
          ],
        ),
      ),
    );
  }
}
