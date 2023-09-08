import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Review.dart';
import '../models/doctor_model.dart';

class FirebaseService {

  final CollectionReference reviewsCollection =
  FirebaseFirestore.instance.collection('Review');

  Future<List<Review>> getReviews(String doctorid) async {
    QuerySnapshot snapshot = await reviewsCollection
        .where('doctorId', isEqualTo: doctorid)
        .get();
    return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
  }
}

