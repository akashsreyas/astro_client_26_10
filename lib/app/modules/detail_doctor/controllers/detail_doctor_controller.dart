import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/doctor_model.dart';
import 'package:hallo_doctor_client/app/models/review_model.dart';
import 'package:hallo_doctor_client/app/service/doctor_service.dart';
import 'package:hallo_doctor_client/app/service/review_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DetailDoctorController extends GetxController with StateMixin<Doctor> {
  final count = 0.obs;
  Doctor selectedDoctor = Get.arguments;
  List<ReviewModel> listReview = [];
  late int advhour=0,advminute=0;
  @override
  Future<void> onInit() async {
    super.onInit();
    ReviewService().getDoctorReview(doctor: selectedDoctor).then((value) {
      listReview = value;
      change(selectedDoctor, status: RxStatus.success());
    });

    var languageSettingVersionRef3 = await FirebaseFirestore.instance
        .collection('Settings')
        .doc('withdrawSetting')
        .get();
    advhour = languageSettingVersionRef3.data()!['advhour'];
    advminute = languageSettingVersionRef3.data()!['advminute'];

  }

  @override
  void onClose() {}
  void increment() => count.value++;

  void toChatDoctor() async {
    String doctorUserId = await DoctorService().getUserId(selectedDoctor);
    if (doctorUserId.isEmpty) {
      Fluttertoast.showToast(msg: 'Doctor no longger exist'.tr);
      return;
    }
    final otherUser = types.User(
        id: doctorUserId,
        displayName: selectedDoctor.doctorName,
        imageUrl: selectedDoctor.doctorPicture);
    print(otherUser);
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    Get.toNamed('/chat', arguments: [room, selectedDoctor]);
  }
}
