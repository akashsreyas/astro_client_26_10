import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/privacy_policy_controller.dart';

class privacy_policy_binding extends Bindings {
  @override
  void dependencies() {
    Get.put(privacy_policy_controller());
  }
}
