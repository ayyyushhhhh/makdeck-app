import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makdeck/models/Cart/order_model.dart';
import 'package:makdeck/models/Products/product_model.dart';

class UserDataBase {
  late FirebaseFirestore _firestore;
  // ignore: non_constant_identifier_names
  UserDataBase() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> addOrdertoFirebase(
      {required OrderModel order, required String uid}) async {
    final String orderPath = "users/$uid/orders/${order.orderid}";
    try {
      final DocumentReference<Map<String, dynamic>> cloudRef =
          _firestore.doc(orderPath);
      await cloudRef.set(order.toMap());
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> addProducttoWishlist(
      {required ProductModel product, required String uid}) async {
    final String orderPath = "users/$uid/Wishlist/${product.id}";
    try {
      final DocumentReference<Map<String, dynamic>> cloudRef =
          _firestore.doc(orderPath);
      await cloudRef.set(product.toMap());
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> deleteProductFromWishlist(
      {required String productID, required String uid}) async {
    final String orderPath = "users/$uid/Wishlist/$productID";

    try {
      final DocumentReference<Map<String, dynamic>> cloudRef =
          _firestore.doc(orderPath);
      await cloudRef.delete();
    } on FirebaseException {
      rethrow;
    }
  }

  Query<ProductModel> getWishlistProducts({required String uid}) {
    final String productpath = "users/$uid/Wishlist/";

    try {
      final CollectionReference refrence = _firestore.collection(productpath);

      final querypost = refrence.orderBy("name").withConverter<ProductModel>(
          fromFirestore: (snapshot, _) =>
              ProductModel.fromMap(snapshot.data()!),
          toFirestore: (product, _) => product.toMap());

      return querypost;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<List<String>> getWishlistProductsid({required String uid}) async {
    final String productpath = "users/$uid/Wishlist/";

    try {
      var collection = FirebaseFirestore.instance.collection(productpath);
      var querySnapshots = await collection.get();
      List<String> documentID = [];
      for (var snapshot in querySnapshots.docs) {
        documentID.add(snapshot.id);
      }
      return documentID;
    } on Exception {
      rethrow;
    }
  }

  Query<OrderModel> getUserOrders({required String uid}) {
    final String orderPath = "users/$uid/orders/";
    try {
      final CollectionReference refrence = _firestore.collection(orderPath);

      final querypost = refrence
          .orderBy('orderDate', descending: true)
          .withConverter<OrderModel>(
              fromFirestore: (snapshot, _) =>
                  OrderModel.fromMap(snapshot.data()!),
              toFirestore: (order, _) => order.toMap());

      return querypost;
    } on Exception {
      rethrow;
    }
  }
}
