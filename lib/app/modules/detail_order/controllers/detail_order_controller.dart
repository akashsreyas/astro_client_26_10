



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
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../../../service/OrderIdProvider.dart';
import '../../../service/OrderInfo.dart';
import '../../appointment/controllers/appointment_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../views/instamojoview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

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

  late String orderID="10";




  PaymentService paymentService = Get.find();
  NotificationService notificationService = Get.find<NotificationService>();
  late String clientSecret;
  Razorpay _razorpay = Razorpay();
  late var options;
  late String orderId="";
  late num bizamount=0;
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
  Future<void> payWithInstamojo()  async {
    String phone;

    // final String url = 'upi://pay?pa=instamojo.d482745ee9734336ae2e01b3f0b8aa32@icici&pn=Instamojo&tr=MOJa7d3dc327c29dcd6a51fbd5172756f51&cu=INR&mc=7392&am=10.00&/#Intent;scheme=upi;package=com.google.android.apps.nbu.paisa.user;end';
    //
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch Google Pay link.';
    // }

    var languageSettingVersionRef1 = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userService.getUserId())
        .get();
    String user = languageSettingVersionRef1.data()!['displayName'] ;

    String country = languageSettingVersionRef1.data()!['country'] ;

if(country=='India'){
   phone = languageSettingVersionRef1.data()!['phone'] ;
}else{
   phone = '';
}


    String transactionurl="";


    EasyLoading.show(status: 'Please wait... Connecting with payment gateway....');
    bizamount=((((selectedTimeSlot.price! * totaltax)/100)+selectedTimeSlot.price!)).toPrecision(2);
    OrderInfo orderInfo = await PaymentService().payWithInstamojo(
        selectedTimeSlot.timeSlotId!, userService.getUserId(),user,userService.getEmail(),phone,bizamount);




    orderId = orderInfo.orderId;
    transactionurl = orderInfo.url;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('orderId', orderId); // Example: saving a string
    prefs.setString('previoustransactionStatus', "NotPay");



  
    // bizamount=10;

    Get.to(() => instamojoview(instamojourl: transactionurl,amount:bizamount));
  }











  Future<void> Instamojosuccess(String paymentid) async {
    var user = userService.currentUser;
  orderId=  await PaymentService().successInstamojoPayment(orderId,bizamount);
  var pid=paymentid;
  var username=await userService.getUsername();
  var email=user?.email!;
  try {

    await FirebaseFirestore.instance
        .collection('Order')
        .doc(orderId)
        .update({'linkReceipt': pid,
                 'username': username,
                  'email':email,


        });

  } catch (e) {
    return Future.error(e.toString());
  }

  addInvoice();
  }

  Future<void> Instamojofail() async{
    var username=await userService.getUsername();
    try {

      await FirebaseFirestore.instance
          .collection('Order')
          .doc(orderId)
          .update({'username': username});

    } catch (e) {
      return Future.error(e.toString());
    }
  }
  void goHome() {

    Get.offAllNamed('dashboard');
    Get.find<DashboardController>().selectedIndex = 2;
    Get.find<AppointmentController>().getListAppointment();
  }
  void payWithRazorpay() async {
    String razid ="";

    Environment environment = Environment();
    environment.razorpayid().then((value) {
      razid = value;
    }).catchError((error) {
      print(error);
    });

    var languageSettingVersionRef1 = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userService.getUserId())
        .get();
    String user = languageSettingVersionRef1.data()!['displayName'] ;
    String phone = languageSettingVersionRef1.data()!['phone'] ;



    paidamt=(((selectedTimeSlot.price! * totaltax)/100)+selectedTimeSlot.price!);

    EasyLoading.show();
    try {
       orderId = await PaymentService().payWithRazorpay(
           selectedTimeSlot.timeSlotId!, userService.getUserId(),user,userService.getEmail(),phone,bizamount);

       SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.setString('orderId', orderId); // Example: saving a string
       prefs.setString('previoustransactionStatus', "NotPay");


      print('order id : $orderId');
      print('price : ${   ((((selectedTimeSlot.price! * totaltax)/100)+selectedTimeSlot.price!)*100).round()}');
      String username = await userService.getUsername();
      options = {
        'key': razid,
         // 'amount': 1*100,
        'amount': ((((selectedTimeSlot.price! * totaltax)/100)+selectedTimeSlot.price!)*100).round(),
        'name': username,
        'notes': {'order_id': orderId},
        'description': 'Timeslot Consultation',
        'prefill': {
          'contact': phone,
          'email': userService.currentUser!.email
        }
      };
       print('order id : $options');
      _razorpay.open(options);
      //PaymentService().payWithRazorpay();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {





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

  _handlePaymentError(PaymentFailureResponse response) async {


    var username=await userService.getUsername();
    try {

      await FirebaseFirestore.instance
          .collection('Order')
          .doc(orderId)
          .update({'username': username});

    } catch (e) {
      return Future.error(e.toString());
    }

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
      'status':'Success',
      'cancelled':now,
      'action':'success',




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
