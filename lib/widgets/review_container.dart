import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makdeck/models/review_model.dart';
import 'package:makdeck/utils/ui/colors.dart';

class ReviewContainer extends StatelessWidget {
  final ReviewModel review;
  ReviewContainer({Key? key, required this.review}) : super(key: key);
  final DateFormat _formatter = DateFormat.yMMMMd('en_US');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        review.rating.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  child: Text(
                    review.review,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children: [
                Text(review.userName),
                SizedBox(width: 10),
                Text(
                  _formatter.format(
                    DateTime.parse(review.date),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
