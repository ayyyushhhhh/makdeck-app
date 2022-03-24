import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makdeck/models/Cart/order_model.dart';

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
}
