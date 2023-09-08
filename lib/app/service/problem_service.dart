import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';


class ProblemService {
  final UserService userService = Get.find();
  Future sendProblem(String myProblem, TimeSlot timeSlot) async {
    try {
      await FirebaseFirestore.instance
          .collection('Problem')
          .add({'problem': myProblem,
        'timeSlot': timeSlot.timeSlotId,
      'advisor_name':timeSlot.doctor!.doctorName,
      'advisor_id':timeSlot.doctor!.doctorId,
        'Client_name':userService.currentUser!.displayName,
        'Client_id':userService.currentUser!.uid,
       'call_time':DateTime.now()


      });
    } on FirebaseException catch (e) {
      return Future.error(e.message!);
    }
  }
}
