import 'package:intl/intl.dart';

class Review {
  final String id;
  final String userId;
  final String userName;
  final String productId;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    String? productId,
    double? rating,
    String? comment,
    DateTime? date,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      productId: productId ?? this.productId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  String get formattedDate => DateFormat('MMMM d, y').format(date);
}