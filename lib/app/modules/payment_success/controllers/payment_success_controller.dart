import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/modules/appointment/controllers/appointment_controller.dart';
import 'package:hallo_doctor_client/app/modules/dashboard/controllers/dashboard_controller.dart';

class PaymentSuccessController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final count = 0.obs;
  late AnimationController animController;
  // TimeSlot timeSlot = Get.arguments;

  TimeSlot timeSlot = Get.arguments[0]['timeSlot'];
  double room = Get.arguments[0]['room'];
  String token = Get.arguments[0]['token'];

  var price = 0.obs;
  late int paidamt=0;
  late String a='';
  @override
  Future<void> onInit() async {
    super.onInit();
    animController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));








  }

  @override
  void onClose() {
    animController.dispose();
  }

  void increment() => count.value++;

  void goHome() {

    Get.offAllNamed('dashboard');
    Get.find<DashboardController>().selectedIndex = 2;
    Get.find<AppointmentController>().getListAppointment();
  }
}
