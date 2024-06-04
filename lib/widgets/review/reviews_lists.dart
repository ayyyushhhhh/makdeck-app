import 'package:flutter/material.dart';
import 'package:makdeck/models/Review/review_model.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/widgets/review/review_container.dart';

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
        FutureBuilder<List<ReviewModel>>(
            future: CloudDatabase().getReviews(productID: widget.productId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                List<ReviewModel> reviews = snapshot.data!;
                if (reviews.isEmpty) {
                  return const Center(
                    child: Text("No Reviews Yet"),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: reviews.length,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final review = reviews[index];
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
            })
      ],
    );
  }
}
