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

class DetailOrderController extends GetxController {
  final username = ''.obs;
  final UserService userService = Get.find();
  List<OrderDetailModel> orderDetail = List.empty();
  TimeSlot selectedTimeSlot = Get.arguments[0];
  Doctor doctor = Get.arguments[1];
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
    EasyLoading.show();
    try {
       orderId = await PaymentService().payWithRazorpay(
          selectedTimeSlot.timeSlotId!, userService.getUserId());
      print('order id : $orderId');
      print('price : ${selectedTimeSlot.price}');
      String username = await userService.getUsername();
      options = {
        'key': Environment.razorpayKeyId,
        'amount': selectedTimeSlot.price! * 100,
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

    Get.offNamed('/payment-success', arguments: selectedTimeSlot);
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
}
