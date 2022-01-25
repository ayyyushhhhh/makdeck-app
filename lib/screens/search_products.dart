import 'package:flutter/material.dart';
import 'package:makdeck/models/Products/product_model.dart';
import 'package:makdeck/widgets/Products/product_container.dart';

class SearchProductsScreen extends StatefulWidget {
  final List<ProductModel> products;
  const SearchProductsScreen({Key? key, required this.products})
      : super(key: key);

  @override
  _SearchProductsScreenState createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  late TextEditingController _searchController;
  List<ProductModel> _filteredProducts = [];
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _searchController.addListener(() {
      _searchQuery();
    });
  }

  void _searchQuery() {
    List<ProductModel> allProducts = [];
    allProducts.addAll(widget.products);
    if (_searchController.text.isNotEmpty) {
      allProducts.retainWhere((note) {
        String searchTerm = _searchController.text.toLowerCase();
        String title = note.name.toLowerCase();

        if (title.contains(searchTerm)) {
          return true;
        }
        return false;
      });
      setState(() {
        _filteredProducts = allProducts;
      });
    } else {
      setState(() {
        _filteredProducts.removeRange(0, _filteredProducts.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 12,
                width: double.infinity,
                // margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                padding: const EdgeInsets.all(15),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      offset: (Offset(0, 3)),
                      blurRadius: 5,
                      color: Colors.grey),
                ]),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: _filteredProducts.isNotEmpty
                      ? _filteredProducts.length
                      : widget.products.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.75,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (_filteredProducts.isEmpty) {
                      return ProductContainer(product: widget.products[index]);
                    }

                    return ProductContainer(
                      product: _filteredProducts[index],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
