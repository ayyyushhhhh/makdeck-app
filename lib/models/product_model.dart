class ProductModel {
  late List<String> images;
  late String name;
  late String mrp;
  late String quantity;
  late String productDescription;
  late String features;
  late String benefits;
  late String ingredients;
  late bool inStocks;
  late bool crueltyFree;
  late String countryofOrigin;
  late String nameOfImporter;
  late String addressofImporter;
  late String id;
  late String category;
  late String originalPrice;
  ProductModel({
    required this.id,
    required this.images,
    required this.name,
    required this.mrp,
    required this.quantity,
    required this.productDescription,
    required this.features,
    required this.benefits,
    required this.ingredients,
    required this.inStocks,
    required this.crueltyFree,
    required this.countryofOrigin,
    required this.nameOfImporter,
    required this.addressofImporter,
    required this.category,
    required this.originalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'images': images,
      'name': name,
      'mrp': mrp,
      'quantity': quantity,
      'productDescription': productDescription,
      'features': features,
      'benefits': benefits,
      'ingredients': ingredients,
      'inStocks': inStocks,
      'crueltyFree': crueltyFree,
      'countryofOrigin': countryofOrigin,
      'nameOfImporter': nameOfImporter,
      'addressofImporter': addressofImporter,
      'category': category,
      "originalPrice": originalPrice,
    };
  }

  ProductModel.fromMap(Map<String, dynamic> map) {
    images = List<String>.from(map['images']);
    name = map['name'];
    mrp = map['mrp'];
    quantity = map['quantity'];
    productDescription = map['productDescription'];
    features = map['features'];
    benefits = map['benefits'];
    ingredients = map['ingredients'];
    inStocks = map['inStocks'];
    crueltyFree = map['crueltyFree'];
    countryofOrigin = map['countryofOrigin'];
    nameOfImporter = map['nameOfImporter'];
    addressofImporter = map['addressofImporter'];
    id = map['id'];
    category = map['category'] ?? "Skincare";
    originalPrice = map["originalPrice"];
  }
}
