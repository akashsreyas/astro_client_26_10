import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/service/timeslot_service.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';

class AppointmentController extends GetxController
    with StateMixin<List<TimeSlot>> {
  final count = 0.obs;
  final TimeSlotService _appointmentService = Get.find();
  UserService userService = Get.find();
  @override
  void onInit() async {
    super.onInit();
    getListAppointment();
  }

  @override
  void onClose() {}

  Future<void> getListAppointment() async {
    try {
      var listOrderedTimeslot = await _appointmentService
          .getListAppointment(userService.currentUser!);
      if (listOrderedTimeslot.isEmpty) {
        return change([], status: RxStatus.empty());
      }
      change(listOrderedTimeslot, status: RxStatus.success());
    } catch (err) {
      change([], status: RxStatus.error(err.toString()));
    }
  }


  Future<void> getListAppointment1() async {
    try {
      var listOrderedTimeslot = await _appointmentService
          .getListAppointment(userService.currentUser!);
      if (listOrderedTimeslot.isEmpty) {
        return change([], status: RxStatus.empty());
      }
      for (var timeslot in listOrderedTimeslot) {
        print('Timeslot ID: ${timeslot.timeSlotId}');
        var roomSnapshot = FirebaseFirestore.instance
            .collection('RoomVideoCall')
            .doc(timeslot.timeSlotId!)
            .snapshots();
        roomSnapshot.listen((event) async {
          if (event.data() == null) {

          } else {
            await Future.delayed(const Duration(seconds: 3), () {

              Get.toNamed('/video-call', arguments: [
                {
                  'timeSlot': timeslot,
                  'room': timeslot.timeSlotId,
                  'token': event.data()!['token']
                }
              ]);

            });
          }
        });
      }

      change(listOrderedTimeslot, status: RxStatus.success());
    } catch (err) {
      change([], status: RxStatus.error(err.toString()));
    }
  }



}
