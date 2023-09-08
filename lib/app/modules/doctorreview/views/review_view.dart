import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../models/Review.dart';
import '../../../service/FirebaseService.dart';


class DoctorReviewListWidget extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();
  String drid = Get.arguments[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advisor Reviews'),
      ),
      body: FutureBuilder<List<Review>>(
        future: firebaseService.getReviews(drid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Review>? reviews = snapshot.data;
            return ListView.separated(
              padding: EdgeInsets.all(10.0),
              itemCount: reviews!.length,
              separatorBuilder: (context, index) => SizedBox(height: 10.0), // Set the gap between reviews
              itemBuilder: (context, index) {
                Review review = reviews[index];
                return Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(review.displayName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review.description),
                          // RatingBar.builder(
                          //   initialRating: review.rating,
                          //   minRating: 1,
                          //   direction: Axis.horizontal,
                          //   allowHalfRating: true,
                          //   itemCount: 5,
                          //   itemSize: 20.0,
                          //   itemBuilder: (context, _) => Icon(
                          //     Icons.star,
                          //     color: Colors.amber,
                          //   ),
                          //   onRatingUpdate: (rating) {
                          //     // Do something with the rating if needed
                          //   },
                          // ),
                          RatingBarIndicator(
                            rating: review.rating.toDouble(),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 22.0,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
