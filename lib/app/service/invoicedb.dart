import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';
import 'package:intl/intl.dart';

class Invoicedb{
  String? orderId;
  Invoicedb(orderId);



  Future<void> addInvoice() async {
    final UserService userService = Get.find();

    var languageSettingVersionRef3 = await FirebaseFirestore.instance
        .collection('Order')
        .doc(orderId)
        .get();
    String timeSlotId = languageSettingVersionRef3.data()!['timeSlotId'];


    var languageSettingVersionRef4 = await FirebaseFirestore.instance
        .collection('DoctorTimeslot')
        .doc(timeSlotId)
        .get();
    String doctorId = languageSettingVersionRef4.data()!['doctorId'];
    String timeSlot = languageSettingVersionRef4.data()!['timeSlot'];
    int price = languageSettingVersionRef4.data()!['price'];



    var languageSettingVersionRef = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doctorId)
        .get();
    String drstate = languageSettingVersionRef.data()!['state'];
    String drname = languageSettingVersionRef.data()!['doctorName'];
    String draddress = languageSettingVersionRef.data()!['address'];
    String drgstno = languageSettingVersionRef.data()!['gstno'];
    String uniquekey = languageSettingVersionRef.data()!['uniquekey'];
    String drstcode = languageSettingVersionRef.data()!['statecode'];
    String gsttype = languageSettingVersionRef.data()!['gstType'];


    //Getting user details
    var languageSettingVersionRef1 = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userService.getUserId())
        .get();
    String usname = languageSettingVersionRef1.data()!['displayName'];
    String usstate = languageSettingVersionRef1.data()!['state'];
    String usaddress = languageSettingVersionRef1.data()!['address'];
    String usgstno = languageSettingVersionRef1.data()!['gstno'];
    String usstcode = languageSettingVersionRef1.data()!['code'];


    var languageSettingVersionRef2 = await FirebaseFirestore.instance
        .collection('Settings')
        .doc('withdrawSetting')
        .get();
    String sac = languageSettingVersionRef2.data()!['sacAdvisor'];


    String fy = "null";
    String invoiceno;
    String number;

    if (drstate == usstate) {

      int cgst = languageSettingVersionRef.data()!['cgst'] as int;
      int sgst = languageSettingVersionRef.data()!['sgst'] as int;



      int totaltax=cgst+sgst;
      int igst=0;

      DateTime now = DateTime.now();

      DateTime dateTime = DateTime.parse(timeSlot);
      String formattedDate = DateFormat("MMMM dd, y 'at' hh:mm:ss a").format(
          dateTime);
      print(formattedDate);


      String month = DateFormat('MM').format(now);
      int currentMonth = int.parse(month);
      int currentyear = now.year % 100;


      if (currentMonth >= 04) {
        int y = currentyear + 1;
        fy = '$currentyear' + '_' + '$y';
      }
      else {
        int y = currentyear - 1;
        fy = '$y' + '_' + '$currentyear';
      }


      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference collection = firestore.collection('Invoice');

      QuerySnapshot querySnapshot =
      await collection.where('financialYear', isEqualTo: fy).where(
          'uniqueKey', isEqualTo: uniquekey).get();
      if (querySnapshot.size > 0) {
        QuerySnapshot querySnapshot = await collection.orderBy(
            'createdAt', descending: true).limit(1).get();
        String num1 = querySnapshot.docs.first.get('number');


        String num2 = "001";
        int sum = int.parse(num1) + int.parse(num2);
        number = sum.toString().padLeft(3, '0');

        invoiceno = '$uniquekey' + "_" + fy + "_" + number;
      }
      else {
        number = '001';
        invoiceno = '$uniquekey' + "_" + fy + "_" + number;
      }


      final CollectionReference invoiceCollection = FirebaseFirestore.instance
          .collection('Invoice');
      return invoiceCollection
          .add({
        'invoiceno': invoiceno,
        'advisorName': drname,
        'advisorAddress': draddress,
        'advisorGstno': drgstno,
        'userName': usname,
        'userAddress': usaddress,
        'userGstno': usgstno,
        'excludedGstamt': price!,
        'includedGstamt': (((price! * totaltax) / 100) +
           price!),
        'createdAt': now,
        'userId': userService.getUserId(),
        'advisorId': doctorId,
        'cgst': ((price! * cgst) / 100),
        'sgst': ((price! * sgst) / 100),
        'igst': ((price! * igst) / 100),
        'tax': ((price! * totaltax) / 100),
        'timeslot':timeSlotId,
        'financialYear': fy,
        'uniqueKey': uniquekey,
        'number': number,
        'advisorState': drstate,
        'advisorStatecode': drstcode,
        'userState': usstate,
        'userStatecode': usstcode,
        'sac': sac,
        'description': formattedDate + "_" + drname + "_" + usname,
        'gstType': gsttype,
        'status': 'Success',
        'cancelled': now,
        'action': 'success',


      })
          .then((value) => print("Invoice Added"))
          .catchError((error) => print("Failed to add invoice: $error"));
    }else{
      int igst = languageSettingVersionRef.data()!['igst'] as int;

      int totaltax=igst;
      int cgst=0,sgst=0;
      DateTime now = DateTime.now();

      DateTime dateTime = DateTime.parse(timeSlot);
      String formattedDate = DateFormat("MMMM dd, y 'at' hh:mm:ss a").format(
          dateTime);
      print(formattedDate);


      String month = DateFormat('MM').format(now);
      int currentMonth = int.parse(month);
      int currentyear = now.year % 100;


      if (currentMonth >= 04) {
        int y = currentyear + 1;
        fy = '$currentyear' + '_' + '$y';
      }
      else {
        int y = currentyear - 1;
        fy = '$y' + '_' + '$currentyear';
      }


      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference collection = firestore.collection('Invoice');

      QuerySnapshot querySnapshot =
      await collection.where('financialYear', isEqualTo: fy).where(
          'uniqueKey', isEqualTo: uniquekey).get();
      if (querySnapshot.size > 0) {
        QuerySnapshot querySnapshot = await collection.orderBy(
            'createdAt', descending: true).limit(1).get();
        String num1 = querySnapshot.docs.first.get('number');


        String num2 = "001";
        int sum = int.parse(num1) + int.parse(num2);
        number = sum.toString().padLeft(3, '0');

        invoiceno = '$uniquekey' + "_" + fy + "_" + number;
      }
      else {
        number = '001';
        invoiceno = '$uniquekey' + "_" + fy + "_" + number;
      }


      final CollectionReference invoiceCollection = FirebaseFirestore.instance
          .collection('Invoice');
      return invoiceCollection
          .add({
        'invoiceno': invoiceno,
        'advisorName': drname,
        'advisorAddress': draddress,
        'advisorGstno': drgstno,
        'userName': usname,
        'userAddress': usaddress,
        'userGstno': usgstno,
        'excludedGstamt': price!,
        'includedGstamt': (((price! * totaltax) / 100) +
            price!),
        'createdAt': now,
        'userId': userService.getUserId(),
        'advisorId': doctorId,
        'cgst': ((price! * cgst) / 100),
        'sgst': ((price! * sgst) / 100),
        'igst': ((price! * igst) / 100),
        'tax': ((price! * totaltax) / 100),
        'timeslot':timeSlotId,
        'financialYear': fy,
        'uniqueKey': uniquekey,
        'number': number,
        'advisorState': drstate,
        'advisorStatecode': drstcode,
        'userState': usstate,
        'userStatecode': usstcode,
        'sac': sac,
        'description': formattedDate + "_" + drname + "_" + usname,
        'gstType': gsttype,
        'status': 'Success',
        'cancelled': now,
        'action': 'success',


      })
          .then((value) => print("Invoice Added"))
          .catchError((error) => print("Failed to add invoice: $error"));
    }
  }
}