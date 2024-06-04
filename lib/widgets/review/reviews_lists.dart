import 'package:flutter/material.dart';

class ReviewsListView extends StatefulWidget {
  final String productId;
  const ReviewsListView({Key? key, required this.productId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReviewsListViewState createState() => _ReviewsListViewState();
}

class _ReviewsListViewState extends State<ReviewsListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Ratings & Reviews",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: width / 15,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // FirestorePagination(
        //   query: CloudDatabase().getReviews(productID: widget.productId),
        //   limit: 3,
        //   itemBuilder: (context, documentSnapshot, index) {
        //     final data = documentSnapshot.data() as Map<String, dynamic>;
        //     final review = ReviewModel.fromMap(data);
        //     return Container();

        //     // Do something cool with the data
        //   },
        // ),

        // FirestoreQueryBuilder<ReviewModel>(
        //     query: CloudDatabase().getReviews(productID: widget.productId),
        //     pageSize: 3,
        //     builder: (context, snapshot, _) {
        //       if (snapshot.hasData) {
        //         if (snapshot.docs.isEmpty) {
        //           return const Center(
        //             child: Text("No Reviews Yet"),
        //           );
        //         }

        //         return ListView.builder(
        //           shrinkWrap: true,
        //           itemCount: snapshot.docs.length,
        //           physics: const ScrollPhysics(),
        //           scrollDirection: Axis.vertical,
        //           itemBuilder: (BuildContext context, int index) {
        //             final hasreachedEnd = snapshot.hasMore &&
        //                 index + 1 == snapshot.docs.length &&
        //                 !snapshot.isFetchingMore;

        //             if (hasreachedEnd) {
        //               snapshot.fetchMore();
        //             }
        //             final review = snapshot.docs[index].data();

        //             if (review.review != "") {
        //               return ReviewContainer(review: review);
        //             }
        //             return Container();
        //           },
        //         );
        //       } else {
        //         return const Center(
        //           child: Text("No Reviews Yet"),
        //         );
        //       }
        //     }),
      ],
    );
  }
}
