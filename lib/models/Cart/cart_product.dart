class CartProductModel {
  final String productName;
  final String productId;
  final int numOfItems;
  final double price;
  final String image;

  CartProductModel({
    required this.productName,
    required this.productId,
    required this.numOfItems,
    required this.price,
    required this.image,
  });

  factory CartProductModel.fromMap(Map<String, dynamic> map) {
    return CartProductModel(
      productName: map['product_name'],
      productId: map['product_id'],
      numOfItems: map['num_of_items'],
      price: map['price'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productId': productId,
      'numOfItems': numOfItems,
      'price': price,
      'image': image,
    };
  }
}
