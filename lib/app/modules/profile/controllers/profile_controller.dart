import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/chat/views/list_users_view.dart';
//import 'package:package_info_plus/package_info_plus.dart';
import 'package:hallo_doctor_client/app/modules/profile/views/pages/change_password.dart';
import 'package:hallo_doctor_client/app/modules/profile/views/pages/edit_image_page.dart';
import 'package:hallo_doctor_client/app/modules/profile/views/pages/update_email_page.dart';
import 'package:hallo_doctor_client/app/service/auth_service.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';
import 'package:hallo_doctor_client/app/translation/en_US.dart';

import '../views/pages/billingdetails.dart';
import '../views/pages/invoice.dart';

import 'package:intl/intl.dart';


class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  final count = 0.obs;
  AuthService authService = Get.find();
  UserService userService = Get.find();
  var username = ''.obs;
  var profilePic = ''.obs;
  var appVersion = ''.obs;
  var email = ''.obs;
  var newPassword = ''.obs;
  var formkey = GlobalKey<FormState>();
  var userids=UserService().currentUser!.uid;
  late String v="1";
  @override
  void onInit() async {
    super.onInit();
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // appVersion.value = packageInfo.version;
  }

  @override
  void onReady() {
    super.onReady();
    var user = userService.currentUser;
    print('user : ' + user.toString());

    profilePic.value = userService.getProfilePicture()!;
    username.value = user!.displayName!;
    email.value = user.email!;
  }

  @override
  void onClose() {}

  void logout() async {
    Get.defaultDialog(
      title: 'Logout'.tr,
      middleText: 'Are you sure you want to Logout'.tr,
      radius: 15,
      textCancel: 'Cancel'.tr,
      textConfirm: 'Logout'.tr,
      onConfirm: () {
        authService.logout().then(
              (value) => Get.offAllNamed('/login'),
            );
      },
    );
  }

  toEditImage() {
    Get.to(() => EditImagePage());
  }

  toUpdateEmail() {
    Get.to(() => UpdateEmailPage());
  }

  toChangePassword() {
    Get.to(() => ChangePasswordPage());
  }
  toBilling() {
    Get.toNamed(
      '/billingdetails',
      arguments: '0',
    );
   // Get.to(() => Billing_Details());
  }

  toInvoice() async {




    Get.to(() => InvoiceListScreen());
  }
  void updateProfilePic(File filePath) {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    userService.updateProfilePic(filePath).then((updatedUrl) {
      profilePic.value = updatedUrl;
      Get.back();
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: error.toString(), toastLength: Toast.LENGTH_LONG);
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void updateEmail(String email) async {
    // if (!(await checkGoogleLogin())) return;
    try {
      EasyLoading.show();
      UserService().updateEmail(email).then((value) {
        Get.back();
        this.email.value = email;
        update();
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void changePassword(String currentPassword, String newPassword) async {
    // if (!(await checkGoogleLogin())) return;

    try {
      await UserService().changePassword(currentPassword, newPassword);
      currentPassword = '';
      newPassword = '';
      Get.back();
      Fluttertoast.showToast(msg: 'Successfully change password'.tr);
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
    EasyLoading.dismiss();
  }

//user for testing something
  Future testButton() async {
    try {
      print('my uid : ' + UserService().currentUser!.uid);
      Get.to(() => ListUser());
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Future<bool> checkGoogleLogin() async {
  //   bool loginGoogle = await AuthService().checkIfGoogleLogin();
  //   print('is login google : ' + loginGoogle.toString());
  //   if (loginGoogle) {
  //     Fluttertoast.showToast(
  //         msg: 'your login method, it is not possible to change this data');
  //     return false;
  //   }
  //   return loginGoogle;
  // }
  Future uploadLanguage() async {
    try {
      await FirebaseFirestore.instance
          .collection("Settings")
          .doc('clientLanguage')
          .set(en);

      // var refData = await FirebaseFirestore.instance
      //     .collection("Settings")
      //     .doc('clientLanguage')
      //     .get();
      // Map<String, String> mapString = refData.data() as Map<String, String>;
      // return mapString;
    } catch (e) {
      return Future.error(e);
    }
  }

  void addDataWithId(String _selectedValue,String state,String statecode,String gstno,String address) async {
    var user =UserService().currentUser!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user)
          .update({
        'country': _selectedValue,
        'state': state,
        'code': statecode,
        'gstno':gstno,
        'address':address,
      });
      print('Data updated successfully!');
    notifyChildrens();

      Fluttertoast.showToast(msg: 'Data updated successfully!'.tr);
    } catch (error) {
      print('Failed to update data: $error');
    }
  }

  void billing(){
    Get.toNamed(
      '/detail-doctor',
      arguments: [],
    );
  }

  void profile(){
    Get.toNamed(
      '/profile',
      arguments: [],
    );
  }

}
