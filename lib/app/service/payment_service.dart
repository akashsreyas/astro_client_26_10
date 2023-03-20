import 'package:cloud_functions/cloud_functions.dart';

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

  Future<String> payWithRazorpay(String timeSlotId, String uid) async {
    try {
      var callable =
          FirebaseFunctions.instance.httpsCallable('requestRazorpayPayment');
      final results = await callable({'timeSlotId': timeSlotId, 'userId': uid});
      var orderId = results.data;
      return orderId;
    } catch (e) {
      return Future.error(e);
    }
  }
}
