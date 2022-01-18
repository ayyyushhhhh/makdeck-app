import 'package:flutter/material.dart';
import 'package:makdeck/models/review_model.dart';
import 'package:makdeck/services/firebase/cloud_database.dart';
import 'package:makdeck/utils/ui/colors.dart';
import 'package:makdeck/widgets/review_container.dart';

class ReviewsListView extends StatefulWidget {
  final String productId;
  const ReviewsListView({Key? key, required this.productId}) : super(key: key);

  @override
  _ReviewsListViewState createState() => _ReviewsListViewState();
}

class _ReviewsListViewState extends State<ReviewsListView> {
  int numberOfReviews = 3;
  List<ReviewModel> reviews = [];
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
        FutureBuilder(
          future: CloudDatabase().getReviews(productID: widget.productId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              reviews = snapshot.data;
              if (reviews.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: numberOfReviews,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < reviews.length) {
                      ReviewModel review = reviews[index];
                      if (review.review != "") {
                        return ReviewContainer(review: review);
                      }
                    }

                    return Container();
                  },
                );
              }
              return const Center(
                child: Text("No Reviews Yet"),
              );
            } else {
              return const Center(
                child: Text("No Reviews Yet"),
              );
            }
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                numberOfReviews = reviews.length;
              });
            },
            child: Text(
              "View All Reviews",
              textAlign: TextAlign.right,
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: kPrimaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
