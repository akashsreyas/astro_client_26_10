import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hallo_doctor_client/app/models/faq_model.dart';
import 'package:hallo_doctor_client/app/modules/widgets/faq_widget.dart';
import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart';

class SettingsService {
  Future<List<FaqModel>> getFaq() async {
    try {
      var faqRef = await FirebaseFirestore.instance.collection('Faq').get();
      List<FaqModel> faq = faqRef.docs
          .map((thisFaq) => FaqModel.fromFirestore(thisFaq))
          .toList();
      return faq;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future getTermsAndConditions() async {
    try {
      var termConditionRef = await FirebaseFirestore.instance
          .collection('TermsAndCondition')
          .where('app', isEqualTo: 'client')
          .get();
      String termCondition =
          termConditionRef.docs[0].data()['termsAndConditionHTML'] as String;
      return termCondition;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<int?> getLocalLanguageVersion() async {
    try {
      final settingsBox = await Hive.openBox('settings');
      final languageVersion =
          settingsBox.get('languageVersion', defaultValue: null) as int?;

      return languageVersion;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, String>> getLocalLanguage() async {
    try {
      final settingsBox = await Hive.openBox('settings');
      //var localLanguage = settingsBox.values.cast<Map<String, String>>();
      var localLanguage =
          settingsBox.get('clientLanguage') as Map<dynamic, dynamic>;
      Map<String, String> castLanguageFromHive =
          localLanguage.map((key, value) => MapEntry(key, value!.toString()));
      return castLanguageFromHive;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<int> getServerLanguageVersion() async {
    try {
      var languageSettingVersionRef = await FirebaseFirestore.instance
          .collection('Settings')
          .doc('languageVersion')
          .get();
      int languageVersion = languageSettingVersionRef.data()!['version'] as int;
      return languageVersion;
    } catch (e) {
      return Future.error(e);
    }
  }
  Future getPrivacyPolicy() async {
    try {
      var PrivacypolicyRef = await FirebaseFirestore.instance
          .collection('PrivacyPolicy')
          .where('app', isEqualTo: 'client/Advisor')
          .get();
      String privacyPolicy =
      PrivacypolicyRef.docs[0].data()['privacyPolicyHTML'] as String;
      return privacyPolicy;
    } catch (e) {
      return Future.error(e);
    }
  }
  Future<Map<String, String>> getDbLanguage() async {
    try {
      var refData = await FirebaseFirestore.instance
          .collection("Settings")
          .doc('clientLanguage')
          .get();
      Map<String, String> languageData = {};
      // Map<String, String> mapString = refData.data().map((key, value) => languageData.);
      // Map<String, String> mapString =
      //     Map<String, String>.from(json.decode(refData.data().toString()));
      Map<String, String> stringQueryParameters =
          refData.data()!.map((key, value) => MapEntry(key, value!.toString()));
      return stringQueryParameters;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future updateLocalLanguage() async {
    try {
      Map<String, String> dbLanguage = await getDbLanguage();
      final settingsBox = await Hive.openBox('settings');
      settingsBox.put('clientLanguage', dbLanguage);
      int serverLanguageVersion = await getServerLanguageVersion();
      settingsBox.put('languageVersion', serverLanguageVersion);
    } catch (e) {
      return Future.error(e);
    }
  }
}
