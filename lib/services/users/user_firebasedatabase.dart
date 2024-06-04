import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makdeck/models/Cart/order_model.dart';
import 'package:makdeck/models/Products/product_model.dart';

class UserDataBase {
  late FirebaseFirestore _firestore;
  // ignore: non_constant_identifier_names
  UserDataBase() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> addOrdertoUser(
      {required OrderModel order, required String uid}) async {
    final String orderPath = "users/$uid/orders/${order.orderid}";
    try {
      final DocumentReference<Map<String, dynamic>> cloudRef =
          _firestore.doc(orderPath);
      await cloudRef.set({"order": order.orderid});
    } on FirebaseException {
      rethrow;
    }
  }

  Future<List<ProductModel>> retrieveWishlist({required String uid}) async {
    List<ProductModel> orders = [];

    final String wishlistPath = "users/$uid/Wishlist/";

    try {
      final collectionReference = _firestore.collection(wishlistPath);
      // .limit(limit) ;

      final QuerySnapshot collectionsQuery = await collectionReference.get();

      if (collectionsQuery.docs.isEmpty) {
        return orders;
      }
      for (var document in collectionsQuery.docs) {
        orders.add(await retrieveProductById(id: document.id));
      }
      return orders;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<ProductModel> retrieveProductById({required String id}) async {
    final String orderPath = "Products/$id/";

    try {
      final DocumentReference documentReference = _firestore.doc(orderPath);
      final DocumentSnapshot orderDocumentSnapshot =
          await documentReference.get();

      ProductModel orderModel = ProductModel.fromMap(
          orderDocumentSnapshot.data() as Map<String, dynamic>);
      return orderModel;
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
      await cloudRef.set({"product": product.id});
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

  Stream<QuerySnapshot> retrieveUserOrders({required String uid}) {
    const String orderPath = "orders/";

    try {
      final CollectionReference refrence = _firestore.collection(orderPath);

      Stream<QuerySnapshot> querySnapshot =
          refrence.where("userUID", isEqualTo: uid).snapshots();
      return querySnapshot;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrderModel>> getUserOrders({required String uid}) async {
    List<OrderModel> orders = [];

    final String wishlistPath = "users/$uid/orders/";

    try {
      final collectionReference = _firestore.collection(wishlistPath);
      // .limit(limit) ;

      final QuerySnapshot collectionsQuery = await collectionReference.get();

      if (collectionsQuery.docs.isEmpty) {
        return orders;
      }
      for (var document in collectionsQuery.docs) {
        orders.add(await retrieveOrderById(id: document.id, uid: uid));
      }
      return orders;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<OrderModel> retrieveOrderById(
      {required String uid, required String id}) async {
    final String orderPath = "users/$uid/orders/$id";

    try {
      final DocumentReference documentReference = _firestore.doc(orderPath);
      final DocumentSnapshot orderDocumentSnapshot =
          await documentReference.get();

      OrderModel orderModel = OrderModel.fromMap(
          orderDocumentSnapshot.data() as Map<String, dynamic>);
      return orderModel;
    } on FirebaseException {
      rethrow;
    }
  }
}
