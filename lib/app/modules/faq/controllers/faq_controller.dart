import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/faq_model.dart';
import 'package:hallo_doctor_client/app/service/settings_service.dart';

class FaqController extends GetxController {
  //TODO: Implement FaqController

  final count = 0.obs;
  List<FaqModel> faq = [];
  List<List<String>> faqList = [];
  @override
  void onInit() async {
    super.onInit();
    faq = await SettingsService().getFaq();
    if (faq.isEmpty) return;
    faqList = faq
        .map(
          (e) => [e.question!, e.answer!],
        )
        .toList();
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
