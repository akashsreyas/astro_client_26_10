import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../controllers/privacy_policy_controller.dart';

class Privacy_Policy_View extends GetView<privacy_policy_controller>{
  const Privacy_Policy_View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Privacy Policy'.tr),
          centerTitle: true,
        ),
        body: Container(
          child: Obx(() {
            String myValue = controller.privacyPolicy.value;
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