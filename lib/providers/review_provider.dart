import 'package:flutter/foundation.dart';
import 'package:labaneta_sweet/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Review> _reviews = [];

  List<Review> get reviews => [..._reviews];

  Future<void> fetchReviews() async {
    final querySnapshot = await _firestore.collection('reviews').get();
    _reviews = querySnapshot.docs.map((doc) => Review(
      id: doc.id,
      userId: doc['userId'],
      userName: doc['userName'],
      productId: doc['productId'],
      rating: doc['rating'],
      comment: doc['comment'],
      date: (doc['date'] as Timestamp).toDate(),
    )).toList();
    notifyListeners();
  }

  List<Review> getReviewsForProduct(String productId) {
    return _reviews.where((review) => review.productId == productId).toList();
  }

  double getAverageRatingForProduct(String productId) {
    final reviews = getReviewsForProduct(productId);
    if (reviews.isEmpty) {
      return 0;
    }
    final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  Future<void> addReview(Review review) async {
    final docRef = await _firestore.collection('reviews').add({
      'userId': review.userId,
      'userName': review.userName,
      'productId': review.productId,
      'rating': review.rating,
      'comment': review.comment,
      'date': review.date,
    });
    review = review.copyWith(id: docRef.id);
    _reviews.add(review);
    notifyListeners();
  }
}