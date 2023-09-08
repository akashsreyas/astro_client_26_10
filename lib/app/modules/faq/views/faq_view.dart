//import 'package:faq/faq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/faq_controller.dart';

// class FaqView extends GetView<FaqController> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('FAQ'),
//           centerTitle: true,
//         ),
//         body: Center(
//             child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//                 alignment: Alignment.center,
//                 height: 100,
//                 child: Text(
//                   'Frequently Asked Questions',
//                   style: TextStyle(fontSize: 20),
//                 )),
//             // GetBuilder<FaqController>(
//             //   builder: (_) {
//             //
//             //
//             //     return FaqFlutter(
//             //
//             //       data: controller.faqList,
//             //     );
//             //
//             //   },
//             // )
//           ],
//         )));
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FaqView());
}

class FAQItem {
  String question;
  String answer;

  FAQItem({required this.question, required this.answer});
}

class FaqView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAQ App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FAQScreen(),
    );
  }
}

class FAQScreen extends StatelessWidget {
  Future<List<FAQItem>> fetchFAQItems() async {
    List<FAQItem> faqItems = [];

    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('Faq').get();

    snapshot.docs.forEach((doc) {
      faqItems.add(FAQItem(
        question: doc['question'],
        answer: doc['answer'],
      ));
    });

    return faqItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        title: Text('FAQ'),
          centerTitle: true
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<FAQItem>>(
              future: fetchFAQItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.map((faqItem) {
                      return ExpansionPanelList.radio(
                        elevation: 1,
                        expandedHeaderPadding: EdgeInsets.zero,
                        children: [
                          ExpansionPanelRadio(
                            headerBuilder: (context, isExpanded) {
                              return ListTile(
                                title: Text(faqItem.question),
                              );
                            },
                            body: ListTile(
                              title: Text(faqItem.answer),
                            ),
                            value: faqItem,
                            canTapOnHeader: true,
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return Center(child: Text('No FAQ data found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
