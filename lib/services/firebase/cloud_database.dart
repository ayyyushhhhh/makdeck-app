import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makdeck/models/product_model.dart';
import 'package:makdeck/models/review_model.dart';

class CloudDatabase {
  late FirebaseFirestore _firestore;
  // ignore: non_constant_identifier_names
  CloudDatabase() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<List<ProductModel>> getProductsData() async {
    const String productpath = "Products/";

    try {
      final CollectionReference refrence = _firestore.collection(productpath);
      final QuerySnapshot productSnapshot = await refrence.get();
      final List<ProductModel> restoredProdcuts = [];
      final allData = productSnapshot.docs.map((doc) => doc.data()).toList();

      for (final data in allData) {
        restoredProdcuts
            .add(ProductModel.fromMap(data! as Map<String, dynamic>));
      }

      return restoredProdcuts;
    } on Exception {
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsbyCategory(
      {required String category}) async {
    final String productpath = "Category/Products/$category/";

    try {
      final CollectionReference refrence = _firestore.collection(productpath);
      final QuerySnapshot productSnapshot = await refrence.get();
      final List<ProductModel> restoredProdcuts = [];
      final allData = productSnapshot.docs.map((doc) => doc.data()).toList();

      for (final data in allData) {
        restoredProdcuts
            .add(ProductModel.fromMap(data! as Map<String, dynamic>));
      }

      return restoredProdcuts;
    } on Exception {
      rethrow;
    }
  }

  Future<void> uploadReview(
      {required Map<String, dynamic> review,
      required String reviewId,
      required String productId}) async {
    final String reviewpath = "ProductReviews/Reviews/$productId/$reviewId";
    try {
      final DocumentReference refrence = _firestore.doc(reviewpath);
      await refrence.set(review);
    } on Exception {
      rethrow;
    }
  }

  Future<List<ReviewModel>> getReviews({required String productID}) async {
    final String reviewpath = "ProductReviews/Reviews/$productID";
    try {
      final CollectionReference refrence = _firestore.collection(reviewpath);
      final QuerySnapshot productSnapshot = await refrence.get();
      final List<ReviewModel> allReviews = [];

      final allData = productSnapshot.docs.map((doc) => doc.data()).toList();

      for (final data in allData) {
        allReviews.add(ReviewModel.fromMap(data! as Map<String, dynamic>));
      }

      return allReviews;
    } on Exception {
      rethrow;
    }
  }

  Future<double> getRatings({required String productID}) async {
    final String reviewpath = "ProductReviews/Reviews/$productID";
    try {
      final CollectionReference refrence = _firestore.collection(reviewpath);
      final QuerySnapshot productSnapshot = await refrence.get();
      double ratings = 0;

      final allData = productSnapshot.docs.map((doc) => doc.data()).toList();

      for (final data in allData) {
        final review = ReviewModel.fromMap(data! as Map<String, dynamic>);
        ratings += review.rating;
      }
      if (allData.isNotEmpty) {
        ratings = ratings / allData.length;
        return ratings;
      }

      return 0.0;
    } on Exception {
      rethrow;
    }
  }

  Future<ReviewModel> getReview(
      {required String productID, required String uid}) async {
    final String reviewpath = "ProductReviews/Reviews/$productID/$uid";
    try {
      final DocumentReference refrence = _firestore.doc(reviewpath);
      final DocumentSnapshot productSnapshot = await refrence.get();

      final allData = productSnapshot.data();
      if (allData != null) {
        final ReviewModel review =
            ReviewModel.fromMap(allData as Map<String, dynamic>);
        return review;
      }

      return ReviewModel(
          id: "",
          userId: uid,
          userName: "",
          rating: 0,
          date: DateTime.now().toIso8601String(),
          review: "");
    } on Exception {
      rethrow;
    }
  }

  Future<String> getContactNumber() async {
    const String contactpath = "/ContactNumbers/contacts";
    try {
      final DocumentReference refrence = _firestore.doc(contactpath);
      final DocumentSnapshot productSnapshot = await refrence.get();

      final Map<String, dynamic> data =
          productSnapshot.data() as Map<String, dynamic>;
      return data["whatsapp"];
    } catch (e) {
      rethrow;
    }
  }
}
