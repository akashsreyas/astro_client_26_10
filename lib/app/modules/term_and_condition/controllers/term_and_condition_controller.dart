import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/service/settings_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermAndConditionController extends GetxController {
  //TODO: Implement TermAndConditionController
  final Completer<WebViewController> completerController =
      Completer<WebViewController>();
  late WebViewController con;

  var termsAndConditions = ''.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadTermsAndConditions();
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

  Future loadTermsAndConditions() async {
    try {
      EasyLoading.show();
      termsAndConditions.value =
          await SettingsService().getTermsAndConditions();
    } catch (e) {
      return Future.error(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
