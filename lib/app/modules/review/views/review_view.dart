import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hallo_doctor_client/app/modules/dashboard/views/dashboard_view.dart';
import 'package:hallo_doctor_client/app/modules/widgets/submit_button.dart';

import '../../../routes/app_pages.dart';
import '../controllers/review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  double _currentindex=5;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Review Advisor'.tr),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundImage: CachedNetworkImageProvider(
                          controller.timeSlot.doctor!.doctorPicture!),
                    ),
                    title: Text(controller.timeSlot.doctor!.doctorName!),
                  ),
                  Divider(),
                  TextField(
                    controller: controller.textEditingReviewController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your Review'.tr),
                    maxLines: 10,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => controller.review = value,
                  ),
                  Divider(),
                  Obx(() => RatingBar.builder(
                        initialRating: controller.rating.value,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          // FocusManager.instance.primaryFocus?.unfocus();
                          // print(rating);

                          _currentindex=rating;

                          print(rating);
                          print(_currentindex);
                        },
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  submitButton(
                      onTap: () {
                        print("current index ${_currentindex}");
                        Fluttertoast.showToast(msg: 'Thankyou for your feedback.'.tr);
                        controller.saveReiew(_currentindex);
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(Routes.DASHBOARD, (Route<dynamic> route) => false);





                      },
                      text: "Send".tr)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
