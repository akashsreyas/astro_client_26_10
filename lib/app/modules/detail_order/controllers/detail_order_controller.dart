

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/doctor_model.dart';
import 'package:hallo_doctor_client/app/models/order_detail_model.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/service/notification_service.dart';
import 'package:hallo_doctor_client/app/service/payment_service.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';
import 'package:hallo_doctor_client/app/utils/constants/constants.dart';
import 'package:hallo_doctor_client/app/utils/environment.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_pages.dart';

class DetailOrderController extends GetxController {
  final username = ''.obs;
  final UserService userService = Get.find();
  List<OrderDetailModel> orderDetail = List.empty();
  TimeSlot selectedTimeSlot = Get.arguments[0];
  Doctor doctor = Get.arguments[1];
  String drname= Get.arguments[2];
  String draddress= Get.arguments[3];
  String drgstno= Get.arguments[4];
  String usname= Get.arguments[5];
  String usaddress= Get.arguments[6];
  String usgstno= Get.arguments[7];
  int cgst= Get.arguments[8];
  int sgst= Get.arguments[9];
  int igst= Get.arguments[10];
  int totaltax= Get.arguments[11];
  String uniquekey= Get.arguments[12];
  String drstate= Get.arguments[13];
  String drstcode= Get.arguments[14];
  String usstate= Get.arguments[15];
  String usstcode= Get.arguments[16];
  String sac= Get.arguments[17];
  String gsttype= Get.arguments[18];

  late double paidamt;






  PaymentService paymentService = Get.find();
  NotificationService notificationService = Get.find<NotificationService>();
  late String clientSecret;
  Razorpay _razorpay = Razorpay();
  late var options;
  late String orderId;

  @override
  void onInit() {
    super.onInit();
    userService.getUsername().then((value) {
      username.value = value;
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);


  }

  @override
  void onClose() {
    _razorpay.clear(); // Removes all listeners
  }

  OrderDetailModel buildOrderDetail() {


    var formatter = DateFormat('yyyy-MM-dd hh:mm a');
    var time = formatter.format(selectedTimeSlot.timeSlot!);

    var orderDetail = OrderDetailModel(
        itemId: selectedTimeSlot.timeSlotId!,
        itemName: 'Consultation with ' + doctor.doctorName!,
        time: time,
        duration: selectedTimeSlot.duration.toString() + ' minute',
        price: currencySign + selectedTimeSlot.price.toString());
    return orderDetail;
  }

  void makePayment() async {
    EasyLoading.show();
    try {
      var clientSecret = await paymentService.getClientSecret(
          selectedTimeSlot.timeSlotId!, userService.getUserId());
      if (clientSecret.isEmpty) return;

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'Helo Doctor',
        paymentIntentClientSecret: clientSecret,
      ));
      EasyLoading.dismiss();
      await Stripe.instance.presentPaymentSheet();

      Get.offNamed('/payment-success', arguments: selectedTimeSlot);
      //selectedTimeSlot.timeSlot
      notificationService
          .setNotificationAppointment(selectedTimeSlot.timeSlot!);
    } on StripeException catch (err) {
      Fluttertoast.showToast(msg: err.error.message!);
      return null;
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  void payWithRazorpay() async {



     // Output: April 26, 2023 at 11:53:00 AM

    paidamt=(((selectedTimeSlot.price! * totaltax)/100)+selectedTimeSlot.price!);

    EasyLoading.show();
    try {
       orderId = await PaymentService().payWithRazorpay(
          selectedTimeSlot.timeSlotId!, userService.getUserId());
      print('order id : $orderId');
      print('price : ${   ((((selectedTimeSlot.price! * totaltax)/100)+selectedTimeSlot.price!)*100).round()}');
      String username = await userService.getUsername();
      options = {
        'key': Environment.razorpayKeyId,
        'amount': ((((selectedTimeSlot.price! * totaltax)/100)+selectedTimeSlot.price!)*100).round(),
        'name': username,
        'notes': {'order_id': orderId},
        'description': 'Timeslot Consultation',
        'prefill': {
          'contact': '8888888888',
          'email': userService.currentUser!.email
        }
      };

      _razorpay.open(options);
      //PaymentService().payWithRazorpay();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {

    var pid=response.paymentId;
    try {

      await FirebaseFirestore.instance
          .collection('Order')
          .doc(orderId)
          .update({'linkReceipt': pid});

    } catch (e) {
      return Future.error(e.toString());
    }


    var username=await userService.getUsername();
    try {

      await FirebaseFirestore.instance
          .collection('Order')
          .doc(orderId)
          .update({'username': username});

    } catch (e) {
      return Future.error(e.toString());
    }
    addInvoice();


    Get.toNamed('/payment-success', arguments: [
      {
        'timeSlot': selectedTimeSlot,
        'room': paidamt,
        'token': 'token'

      }
    ]);


    //Get.offNamed('/payment-success', arguments: selectedTimeSlot);




    //selectedTimeSlot.timeSlot
    notificationService.setNotificationAppointment(selectedTimeSlot.timeSlot!);
  }

  _handlePaymentError(PaymentFailureResponse response) {

    Fluttertoast.showToast(
        msg: response.message.toString(), toastLength: Toast.LENGTH_LONG);
  }


  _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  Future<void> addInvoice() async {
    String fy="null";
    String invoiceno;
    String number;

    DateTime now = DateTime.now();

    DateTime dateTime = DateTime.parse(selectedTimeSlot.timeSlot.toString());
    String formattedDate = DateFormat("MMMM dd, y 'at' hh:mm:ss a").format(dateTime);
    print(formattedDate);


    String month = DateFormat('MM').format(now);
    int currentMonth = int.parse(month);
    int currentyear = now.year % 100;


    if(currentMonth >= 04){
      int y=currentyear+1;
       fy = '$currentyear' + '_' + '$y';

    }
    else{
      int y=currentyear-1;
      fy = '$y' + '_' + '$currentyear';

    }




    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference collection = firestore.collection('Invoice');

    QuerySnapshot querySnapshot =
    await collection.where('financialYear', isEqualTo: fy).where('uniqueKey',isEqualTo: uniquekey).get();
    if (querySnapshot.size > 0) {

      QuerySnapshot querySnapshot = await collection.orderBy('createdAt', descending: true).limit(1).get();
      String num1=querySnapshot.docs.first.get('number');


      String num2 = "001";
      int sum = int.parse(num1) + int.parse(num2);
      number = sum.toString().padLeft(3, '0');

      invoiceno='$uniquekey'+"_"+fy+"_"+number;

    }
    else{
      number = '001';
      invoiceno='$uniquekey'+"_"+fy+"_"+number;
    }


    final CollectionReference invoiceCollection = FirebaseFirestore.instance.collection('Invoice');
    return invoiceCollection
        .add({
      'invoiceno': invoiceno,
      'advisorName': drname,
      'advisorAddress':draddress,
      'advisorGstno':drgstno,
      'userName':usname,
      'userAddress':usaddress,
      'userGstno':usgstno,
      'excludedGstamt':selectedTimeSlot.price!,
      'includedGstamt':(((selectedTimeSlot.price! * totaltax)/100)+selectedTimeSlot.price!),
      'createdAt':now,
      'userId':userService.getUserId(),
      'advisorId':doctor.doctorId,
      'cgst':((selectedTimeSlot.price! * cgst)/100),
      'sgst':((selectedTimeSlot.price! * sgst)/100),
      'igst':((selectedTimeSlot.price! * igst)/100),
      'tax':((selectedTimeSlot.price! * totaltax)/100),
      'timeslot':selectedTimeSlot.timeSlotId,
      'financialYear':fy,
      'uniqueKey':uniquekey,
      'number':number,
      'advisorState':drstate,
      'advisorStatecode':drstcode,
      'userState':usstate,
      'userStatecode':usstcode,
      'sac':sac,
      'description':formattedDate+"_"+drname+"_"+usname,
      'gstType':gsttype,




    })
        .then((value) => print("Invoice Added"))
        .catchError((error) => print("Failed to add invoice: $error"));


  }


  void showAlertDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('title'),
        content: Text('message'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

}
