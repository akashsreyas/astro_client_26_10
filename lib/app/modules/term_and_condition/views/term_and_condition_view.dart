import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../controllers/term_and_condition_controller.dart';

class TermAndConditionView extends GetView<TermAndConditionController> {
  const TermAndConditionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Terms And Conditions'.tr),
          centerTitle: true,
        ),
        body: Container(
          child: Obx(() {
            String myValue = controller.termsAndConditions.value;
            print(myValue);
            if (myValue.isEmpty) {
              return SizedBox();
            } else {
              return WebViewPlus(
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (webController) {
                  webController.loadString(myValue);
                },
              );
            }
          }),
        ));
  }
}
