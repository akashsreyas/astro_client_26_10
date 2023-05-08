import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  Future<bool> checkUserAlreadyLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      print('User Uid : ' + auth.currentUser!.uid);
      return true;
    } else {
      return false;
    }
  }

  Future userSetup(User user, String displayName) async {

    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    String uniquekey=String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));



    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference collection = firestore.collection('Users');
    // Check if the number exists in the collection

    while (true) {
      // Check if the number already exists in Firestore
      QuerySnapshot snapshot =
      await collection.where('uniquekey', isEqualTo: uniquekey).get();
      if (snapshot.size == 0) {

        CollectionReference users = FirebaseFirestore.instance.collection('Users');
        String uid = user.uid.toString();
        users.doc(uid).set({
          'displayName': displayName,
          'uid': uid,
          'email': user.email,
          'uniquekey' : uniquekey,
          'lastLogin': user.metadata.lastSignInTime!.millisecondsSinceEpoch,
          'createdAt': user.metadata.creationTime!.millisecondsSinceEpoch,
          'role': 'doctor',
          'app':'client'

        });

        break;
      } else {
        const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
        final random = Random();
         uniquekey=String.fromCharCodes(Iterable.generate(
            6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));

      }
    }









    }








  }



