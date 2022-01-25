import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makdeck/models/Review/review_model.dart';
import 'package:makdeck/utils/ui/colors.dart';

class ReviewContainer extends StatelessWidget {
  final ReviewModel review;
  ReviewContainer({Key? key, required this.review}) : super(key: key);
  final DateFormat _formatter = DateFormat.yMMMMd('en_US');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.rating.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.review,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(review.userName),
              const SizedBox(width: 10),
              Text(
                _formatter.format(
                  DateTime.parse(review.date),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
