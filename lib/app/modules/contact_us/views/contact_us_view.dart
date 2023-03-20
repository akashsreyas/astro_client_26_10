import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/widgets/submit_button.dart';

import '../controllers/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contact Us'),
          centerTitle: true,
        ),
        body: Builder(builder: (context) {
          var bodyHeight = MediaQuery.of(context).size.height -
              Scaffold.of(context).appBarMaxHeight!;
          return Container(
            padding: EdgeInsets.all(20),
            height: bodyHeight,
            child: Column(
              children: [
                Container(
                    width: Get.width,
                    child: Text('Contact us by filling out the form below')),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: controller.messageTextController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your Message'.tr),
                    maxLines: 10,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {}),
                Spacer(),
                submitButton(
                    onTap: () {
                      Get.defaultDialog(
                          title: 'Submit Message',
                          content: Text(
                              'Are you sure you want to send this message'),
                          textCancel: 'Cancel',
                          textConfirm: 'Submit',
                          onConfirm: () {
                            controller.sendMessage();
                          });
                    },
                    text: 'Submit')
              ],
            ),
          );
        }));
  }
}
