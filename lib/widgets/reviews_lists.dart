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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Ratings & Reviews",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        FutureBuilder(
          future: CloudDatabase().getReviews(productID: widget.productId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<ReviewModel> reviews = snapshot.data;
              double rating = 0;
              for (ReviewModel review in reviews) {
                rating += review.rating;
              }
              rating = rating / reviews.length;
              return Row(
                children: [
                  Text(
                    "Ratings - ",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(color: Colors.white),
                      ))),
                ],
              );
            } else {
              return Center(child: Text("No Reviews/Ratings"));
            }
          },
        ),
        FutureBuilder(
          future: CloudDatabase().getReviews(productID: widget.productId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ReviewModel review = snapshot.data[index];
                  return ReviewContainer(review: review);
                },
              );
            } else {
              return Center(
                child: Text("No Reviews Yet"),
              );
            }
          },
        ),
      ],
    ));
  }
}
