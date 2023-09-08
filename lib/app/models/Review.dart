import 'package:cloud_firestore/cloud_firestore.dart';

class Review {

  final String id;
  final String title;
  final String description;
  final double rating;
  final String displayName;

  Review({

    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.displayName,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Review(
      id: doc.id,
      title: data?['displayName'] ?? '',
      description: data?['review'] ?? '',
      rating: data?['rating']?.toDouble() ?? 0.0,
      displayName: data?['user']?['displayName'] ?? '',
    );
  }
}
