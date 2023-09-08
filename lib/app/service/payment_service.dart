import 'package:cloud_functions/cloud_functions.dart';

import 'OrderInfo.dart';

class PaymentService {
  Future<String> getClientSecret(String timeSlotId, String uid) async {
    try {
      var callable =
          FirebaseFunctions.instance.httpsCallable('purchaseTimeslot');
      final results = await callable({'timeSlotId': timeSlotId, 'userId': uid});
      var clientSecret = results.data;
      return clientSecret;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<String> payWithRazorpay(String timeSlotId, String uid, String username,String email,String phone,num amount) async {
    try {
      var callable =
          FirebaseFunctions.instance.httpsCallable('requestRazorpayPayment');
      final results = await callable({'timeSlotId': timeSlotId, 'userId': uid, 'username':username,'email':email,'phone':phone,'amount':amount});

      var orderId = results.data;

      return orderId;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<OrderInfo> payWithInstamojo(String timeSlotId, String uid, String username,String email,String phone,num amount) async {
    try {
      var callable =
      FirebaseFunctions.instance.httpsCallable('requestInstamojoPayment');
      final results = await callable({'timeSlotId': timeSlotId, 'userId': uid, 'username':username,'email':email,'phone':phone,'amount':amount});

      String orderId = results.data['orderId'];
      String paymentUrl = results.data['longurl'];

      return OrderInfo(orderId, paymentUrl);


    } catch (e) {
      return Future.error(e);
    }
  }
  Future<String> successInstamojoPayment(String orderid, num amount) async {
    try {
      var callable =
      FirebaseFunctions.instance.httpsCallable('successInstamojoPayment');
      final results = await callable({'order_id': orderid, 'amount': amount});
      var orderId = results.data;
      return orderId;
    } catch (e) {
      return Future.error(e);
    }
  }
}
