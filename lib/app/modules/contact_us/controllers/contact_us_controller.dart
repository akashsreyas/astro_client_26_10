import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/service/contact_us_service.dart';

class ContactUsController extends GetxController {
  //TODO: Implement ContactUsController
  TextEditingController messageTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future sendMessage() async {
    try {
      EasyLoading.show();
      await ContactUsService().sendMessage(messageTextController.text);
      Get.back(closeOverlays: true);
      Fluttertoast.showToast(msg: 'Succes send message');
    } catch (e) {
      return Future.error(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
