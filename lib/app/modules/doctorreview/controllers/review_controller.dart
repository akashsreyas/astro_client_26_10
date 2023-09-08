import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../models/doctor_model.dart';
import '../../../models/review_model.dart';
import '../../../service/doctor_service.dart';
import '../../../service/review_service.dart';


class ReviewController extends GetxController
    with StateMixin<List<ReviewModel>> {
  //TODO: Implement ReviewController

  final count = 0.obs;
  List<ReviewModel> listReview = [];
  @override
  void onInit() async {
    super.onInit();
    EasyLoading.show();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  void increment() => count.value++;
}
