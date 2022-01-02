import 'package:flutter/material.dart';
import 'package:makdeck/models/product_model.dart';
import 'package:makdeck/screens/all_products.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/utils/ui/colors.dart';
import 'package:makdeck/widgets/categories_container.dart';
import 'package:makdeck/widgets/product_container.dart';

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

  List<ProductModel> _products = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "MakDeck",
            style: TextStyle(fontSize: 26, color: Colors.black),
          ),
        ),
        body: Container(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi,", style: Theme.of(context).textTheme.headline2),
              Container(
                child: Text("Discover Your Products",
                    style: Theme.of(context).textTheme.headline2),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Categories", style: Theme.of(context).textTheme.headline3),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 5,
                width: 10.0 * "Categories".length,
                color: kPrimaryColor,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 6,
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
                          title: _categories[index], image: _categories[index]),
                    );
                  },
                ),
              ),
              Container(
                child: Text("Our Products",
                    style: Theme.of(context).textTheme.headline3),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 5,
                color: kPrimaryColor,
                width: 10.0 * "Our Products".length,
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
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      _products = snapshot.data;

                      return GridView.builder(
                        itemCount: 2,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.75,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return ProductContainer(
                            product: _products[index],
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
                    child: Text("No Products Available"),
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
