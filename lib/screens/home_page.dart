import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makdeck/models/product_model.dart';
import 'package:makdeck/screens/all_products.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/utils/ui/colors.dart';
import 'package:makdeck/widgets/categories_container.dart';
import 'package:makdeck/widgets/drawer_container.dart';
import 'package:makdeck/widgets/product_container.dart';
import 'package:makdeck/widgets/shimer_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
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
  List<ProductModel> _products = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            color: kPrimaryColor,
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
          title: Image.asset(
            "assets/images/Makdeck_logo.png",
            fit: BoxFit.contain,
            height: 60,
          ),
        ),
        drawer: DrawerContainer(),
        body: Container(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<User?>(
                stream: FirebaseAuthentication.getUserStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    User user = snapshot.data;
                    final name = user.displayName!.split(" ");
                    return Text(
                      "Hi " + name[0] + ",",
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
              Container(
                child: Text(
                  "Discover Your Products",
                  style: TextStyle(
                    fontSize: width / 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: width / 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 5,
                width: width / 50 * "Categories".length,
                color: kPrimaryColor,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
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
                                products: [],
                              ),
                            ),
                          );
                        },
                        child: CategoryContainer(
                            title: _categories[index],
                            image: _categories[index]),
                      );
                    },
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Our Products",
                  style: TextStyle(
                    fontSize: width / 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 5,
                color: kPrimaryColor,
                width: width / 50 * "Our Products".length,
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: CloudDatabase().getProductsData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                      itemCount: 2,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.75,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ShimmerLoader();
                      },
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      _products = snapshot.data;
                      final _random = new Random();
                      return GridView.builder(
                        itemCount: 2,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.75,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return ProductContainer(
                            product:
                                _products[_random.nextInt(_products.length)],
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text("No Products Available"),
                      );
                    }
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text("No Internet Connection"),
                    );
                  }
                  return Center(
                    child: Text("No Internet Connection"),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (_products.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AllProducts(
                            products: _products,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "View All Products →",
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
