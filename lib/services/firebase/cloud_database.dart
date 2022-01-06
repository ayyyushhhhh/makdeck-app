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
      ratings = ratings / allData.length;
      return ratings;
    } on Exception {
      rethrow;
    }
  }
}
