import 'package:flutter/material.dart';
import 'package:makdeck/models/Products/product_model.dart';
import 'package:makdeck/screens/search_products.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/Products/product_container.dart';
import 'package:makdeck/widgets/Products/shimer_container.dart';

class AllProducts extends StatelessWidget {
  final List<ProductModel> products;
  final String? productCategory;

  const AllProducts({Key? key, required this.products, this.productCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty && productCategory != "") {
      List<ProductModel> categoryProducts = [];
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
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SearchProductsScreen(products: categoryProducts);
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder<List<ProductModel>>(
              future: CloudDatabase()
                  .getProductsbyCategory(category: productCategory!),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                    categoryProducts = products;
                    if (products.isEmpty) {
                      return Center(
                        child: Text(
                          "No Products Available",
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SearchProductsScreen(products: products);
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.75,
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ProductContainer(
                product: products[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
