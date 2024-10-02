import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/review_provider.dart';
import 'package:labaneta_sweet/models/review.dart';
import 'package:labaneta_sweet/models/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:labaneta_sweet/providers/auth_provider.dart'; // Add this import

class ReviewScreen extends StatefulWidget {
  final Product product;

  const ReviewScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _rating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews for ${widget.product.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ReviewProvider>(
              builder: (context, reviewProvider, child) {
                final reviews = reviewProvider.getReviewsForProduct(widget.product.id);
                if (reviews.isEmpty) {
                  return _buildEmptyReviews();
                } else {
                  return _buildReviewList(reviews);
                }
              },
            ),
          ),
          _buildAddReviewForm(),
        ],
      ),
    );
  }

  Widget _buildEmptyReviews() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.rate_review, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No reviews yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to review this product!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildReviewList(List<Review> reviews) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _buildReviewItem(review);
      },
    );
  }

  Widget _buildReviewItem(Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              review.userName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            RatingBarIndicator(
              rating: review.rating,
              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 20,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          review.comment,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          review.formattedDate,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildAddReviewForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a Review',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reviewController,
              decoration: const InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your review';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReview() {
    if (_formKey.currentState!.validate() && _rating > 0) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final review = Review(
        id: '',
        userId: authProvider.user!.uid,
        userName: authProvider.userData!['name'],
        productId: widget.product.id,
        rating: _rating,
        comment: _reviewController.text,
        date: DateTime.now(),
      );
      Provider.of<ReviewProvider>(context, listen: false).addReview(review);
      _reviewController.clear();
      setState(() {
        _rating = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
    }
  }
}