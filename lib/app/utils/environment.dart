import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get stripePublishableKey {
    return dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  }

  static String get agoraAppId {
    return dotenv.env['AGORA_APP_ID'] ?? '';
  }

  static String get razorpayKeyId  {

    return dotenv.env['RAZORPAY_KEY_ID'] ?? '';
  }

  static String get razorpaySecretKey {
    return dotenv.env['RAZORPAY_KEY_SECRET'] ?? '';
  }

  Future razorpayid() async {
    String razid,mode;
    try {
      var languageSettingVersionRef1 = await FirebaseFirestore.instance
          .collection('Settings')
          .doc('instaMojo')
          .get();
       mode = languageSettingVersionRef1.data()!['razorMode'];
      if(mode == 'test'){
         razid = languageSettingVersionRef1.data()!['testKey'];
      }else{
         razid = languageSettingVersionRef1.data()!['liveKey'];
      }

      print(razid);
      return razid;
    } catch (e) {
      return Future.error(e.toString());
    }

  }

  Future instamojoid() async {
    String razid,mode;
    try {
      var languageSettingVersionRef1 = await FirebaseFirestore.instance
          .collection('Settings')
          .doc('instaMojo')
          .get();
      mode = languageSettingVersionRef1.data()!['instaMode'];
      if(mode == 'test'){
        razid = languageSettingVersionRef1.data()!['testUrl'];
      }else{
        razid = languageSettingVersionRef1.data()!['liveUrl'];
      }

      print(razid);
      return razid;
    } catch (e) {
      return Future.error(e.toString());
    }

  }
}
