import 'package:flutter/material.dart';
import 'package:makdeck/models/product_model.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/product_container.dart';

class AllProducts extends StatelessWidget {
  final List<ProductModel> products;
  final String? productCategory;
  const AllProducts({Key? key, required this.products, this.productCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty && productCategory != "") {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
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
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: FutureBuilder(
              future: CloudDatabase()
                  .getProductsbyCategory(category: productCategory!),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<ProductModel> products = snapshot.data;
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.75,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductContainer(
                          product: products[index],
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
            icon: Icon(
              Icons.navigate_before,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'All Products',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
