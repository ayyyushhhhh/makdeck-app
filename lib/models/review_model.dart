class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String review;
  final int rating;
  final String date;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    this.review = "",
    required this.rating,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      userId: map['user_id'],
      userName: map['user_name'],
      userImage: map['user_image'],
      review: map['review'],
      rating: map['rating'],
      date: map['date'],
    );
  }
}
