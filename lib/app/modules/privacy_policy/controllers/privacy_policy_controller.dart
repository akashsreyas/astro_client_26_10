import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../service/settings_service.dart';




class privacy_policy_controller extends GetxController{
  //TODO: Implement TermAndConditionController
  final Completer<WebViewController> completerController =
  Completer<WebViewController>();
  late WebViewController con;

  var privacyPolicy = ''.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadPrivacyPolicy();
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

  Future loadPrivacyPolicy() async {
    try {
      EasyLoading.show();
      privacyPolicy.value =
      await SettingsService().getPrivacyPolicy();
    } catch (e) {
      return Future.error(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}