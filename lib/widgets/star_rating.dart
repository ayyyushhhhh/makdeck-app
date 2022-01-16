import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final Function(int rating) onRatingChanged;
  final int rating;
  const StarRating(
      {Key? key, required this.onRatingChanged, required this.rating})
      : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _rating = 0;
  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    double iconsize = 50;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.star),
            color: _rating >= 1 ? Colors.yellow : Colors.grey,
            iconSize: iconsize,
            onPressed: () {
              widget.onRatingChanged(1);
              setState(() {
                _rating = 1;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            color: _rating >= 2 ? Colors.yellow : Colors.grey,
            iconSize: iconsize,
            onPressed: () {
              widget.onRatingChanged(2);

              setState(() {
                _rating = 2;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            color: _rating >= 3 ? Colors.yellow : Colors.grey,
            iconSize: iconsize,
            onPressed: () {
              widget.onRatingChanged(3);
              setState(() {
                _rating = 3;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            color: _rating >= 4 ? Colors.yellow : Colors.grey,
            iconSize: iconsize,
            onPressed: () {
              widget.onRatingChanged(4);
              setState(() {
                _rating = 4;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            color: _rating >= 5 ? Colors.yellow : Colors.grey,
            iconSize: iconsize,
            onPressed: () {
              widget.onRatingChanged(5);
              setState(() {
                _rating = 5;
              });
            },
          ),
        ],
      ),
    );
  }
}
