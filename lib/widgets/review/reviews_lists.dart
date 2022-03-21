import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:makdeck/models/Review/review_model.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/review/review_container.dart';

class ReviewsListView extends StatefulWidget {
  final String productId;
  const ReviewsListView({Key? key, required this.productId}) : super(key: key);

  @override
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
        FirestoreQueryBuilder<ReviewModel>(
            query: CloudDatabase().getReviews(productID: widget.productId),
            pageSize: 3,
            builder: (context, snapshot, _) {
              if (snapshot.hasData) {
                if (snapshot.docs.isEmpty) {
                  return const Center(
                    child: Text("No Reviews Yet"),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.docs.length,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final hasreachedEnd = snapshot.hasMore &&
                        index + 1 == snapshot.docs.length &&
                        !snapshot.isFetchingMore;

                    if (hasreachedEnd) {
                      snapshot.fetchMore();
                    }
                    final review = snapshot.docs[index].data();

                    if (review.review != "") {
                      return ReviewContainer(review: review);
                    }
                    return Container();
                  },
                );
              } else {
                return const Center(
                  child: Text("No Reviews Yet"),
                );
              }
            }),
      ],
    );
  }
}
