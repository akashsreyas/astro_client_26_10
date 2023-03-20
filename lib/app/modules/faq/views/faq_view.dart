//import 'package:faq/faq.dart';
import 'package:faqflutter/faqflutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FAQ'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: 100,
                child: Text(
                  'Frequently Asked Questions',
                  style: TextStyle(fontSize: 20),
                )),
            GetBuilder<FaqController>(
              builder: (_) {
                return FaqFlutter(
                  data: controller.faqList,
                );
              },
            )
          ],
        )));
  }
}
