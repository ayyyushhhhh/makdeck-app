class ReviewModel {
  final String id;
  final String userId;
  final String userName;

  final String review;
  final int rating;
  final String date;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.review = "",
    required this.rating,
    required this.date,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      userId: map['user_id'],
      userName: map['user_name'],
      review: map['review'],
      rating: map['rating'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'review': review,
      'rating': rating,
      'date': date,
    };
  }
}
