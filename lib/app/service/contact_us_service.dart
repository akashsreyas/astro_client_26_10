import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hallo_doctor_client/app/models/user_model.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';

class ContactUsService {
  Future sendMessage(String message) async {
    try {
      String userName = await UserService().getUsername();
      String email = UserService().currentUser!.email!;
      var contactUsData = {
        'message': message,
        'name': userName,
        'email': email,
        'dateCreated': Timestamp.fromDate(DateTime.now())
      };
      await FirebaseFirestore.instance
          .collection('ContactUs')
          .add(contactUsData);
    } catch (e) {
      return Future.error(e);
    }
  }
}
