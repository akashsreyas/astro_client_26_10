import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/modules/review/views/review_view.dart';
import 'package:hallo_doctor_client/app/routes/app_pages.dart';
import 'package:hallo_doctor_client/app/service/order_service.dart';
import 'package:hallo_doctor_client/app/service/problem_service.dart';
import 'package:intl/intl.dart';

class ConsultationConfirmController extends GetxController {
 // TimeSlot timeSlot = Get.arguments;
  var problemVisible = false.obs;
  TimeSlot timeSlot = Get.arguments[0]['timeSlot'];
  String room = Get.arguments[0]['room'];
  String token = Get.arguments[0]['token'];



  late String adname="",adaddress="",adgstno="",bizaddress="",bizgstno="",uniquekey='Biz',adid="",adstcode,usstcode,adstate,bizstate,sac,gsttype,description,bizstcode,bizname;
  late String fy="null";
  late String invoiceno;
  late var tds=0,tcs=0,commision=0,exegst,ingst,cgst,sgst,igst;
  late String number='';
  late double netpayment,btds,btcs,cgstamt,sgstamt,igstamt,biztax;

  @override
  void onClose() {}

  sendProblem(String problem) {
    EasyLoading.show();
    ProblemService().sendProblem(problem, timeSlot).then((value) {
      Get.back();
      Get.defaultDialog(
          title: 'Info'.tr,
          onConfirm: () => Get.back(),
          middleText: 'Payment for '.tr +
              timeSlot.doctor!.doctorName! +
              ' will be delayed until the problem is resolved'.tr);
      EasyLoading.dismiss();
    });
  }

  confirmConsultation() async {
    try {
      EasyLoading.show();


     await OrderService().confirmOrder(timeSlot,room);
      invoice(room);
      EasyLoading.dismiss();
      Get.offNamed(Routes.REVIEW, arguments: timeSlot);
      //Get.toNamed(Routes.REVIEW, arguments: timeSlot);
      // Get.offNamedUntil('/review', ModalRoute.withName('/appointment-detail'),
      //     arguments: timeSlot);
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  invoice(String room) async{

    DateTime now = DateTime.now();

    String month = DateFormat('MM').format(now);

    CollectionReference<Map<String, dynamic>> collectionRef = FirebaseFirestore.instance.collection('Invoice');
    var querySnapshot1 = await collectionRef.where('timeslot', isEqualTo: room).get();
    adaddress = querySnapshot1.docs[0].data()['advisorAddress'];
    adgstno = querySnapshot1.docs[0].data()['advisorGstno'];
    adid = querySnapshot1.docs[0].data()['advisorId'];
    adname = querySnapshot1.docs[0].data()['advisorName'];
    exegst = querySnapshot1.docs[0].data()['excludedGstamt'];
    ingst = querySnapshot1.docs[0].data()['includedGstamt'];
    adstcode = querySnapshot1.docs[0].data()['advisorStatecode'];
    usstcode = querySnapshot1.docs[0].data()['userStatecode'];
    adstate = querySnapshot1.docs[0].data()['advisorState'];
    gsttype=querySnapshot1.docs[0].data()['gstType'];
    description=querySnapshot1.docs[0].data()['description'];
















    var languageSettingVersionRef1 = await FirebaseFirestore.instance
        .collection('Settings')
        .doc('withdrawSetting')
        .get();
    bizaddress = languageSettingVersionRef1.data()!['address'];
    bizgstno = languageSettingVersionRef1.data()!['gstno'];
    tds = languageSettingVersionRef1.data()!['tds'] as int;
    tcs = languageSettingVersionRef1.data()!['tcs'] as int;
    commision = languageSettingVersionRef1.data()!['percentage'] as int;
    cgst = languageSettingVersionRef1.data()!['cgst'] as int;
    sgst = languageSettingVersionRef1.data()!['sgst'] as int;
    igst = languageSettingVersionRef1.data()!['igst'] as int;
    bizstate= languageSettingVersionRef1.data()!['state'];
    sac= languageSettingVersionRef1.data()!['sacBizboost'];
    bizstcode= languageSettingVersionRef1.data()!['stateCode'];
    bizname= languageSettingVersionRef1.data()!['name'];












    //get current month & year

    int currentMonth = int.parse(month);
    int currentyear = now.year % 100;


    if(currentMonth >= 04){
      int y=currentyear+1;
      fy = '$currentyear' + '-' + '$y';

    }
    else{
      int y=currentyear-1;
      fy = '$y' + '-' + '$currentyear';

    }



    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference collection = firestore.collection('Bizinvoice');

    QuerySnapshot querySnapshot =
    await collection.where('financialYear', isEqualTo: fy).get();
    if (querySnapshot.size > 0) {

      QuerySnapshot querySnapshot = await collection.orderBy('createdAt', descending: true).limit(1).get();
      String num1=querySnapshot.docs.first.get('number');


      String num2 = "0001";
      int sum = int.parse(num1) + int.parse(num2);
      number = sum.toString().padLeft(4, '0');
      invoiceno='$uniquekey'+"_"+fy+"_"+number;

    }
    else{
      number = '0001';
      invoiceno='$uniquekey'+"_"+fy+"_"+number;
    }
    double bizcom=(exegst*commision)/100;
   if(adstate==bizstate){

     cgstamt=bizcom*cgst/100;
     sgstamt=bizcom*sgst/100;
     igstamt=0;
     biztax=cgstamt+sgstamt;

   }else{
      cgstamt=0;
      sgstamt=0;
      igstamt=bizcom*igst/100;
      biztax=igstamt;
   }

    if(gsttype=='Biz'){
         btds=0;
    }else {
        btds = exegst * tds / 100;
    }
    btcs=exegst*tcs/100;
    double bizz=bizcom+biztax;

    netpayment=ingst-bizz-btds-btcs;

    QuerySnapshot querySnapshot2 =
    await collection.where('timeslot', isEqualTo: room).get();
    if (querySnapshot2.size > 0) {

    }else{
      final CollectionReference invoiceCollection = FirebaseFirestore.instance
          .collection('Bizinvoice');
      return invoiceCollection
          .add({
        'invoiceNo': invoiceno,
        'advisorName': adname,
        'advisorAddress': adaddress,
        'advisorGstno': adgstno,
        'excludedGstamt': exegst,
        'includedGstamt': ingst,
        'createdAt': now,
        'advisorId': adid,
        'timeslot': room,
        'financialYear': fy,
        'uniquekey': uniquekey,
        'number': number,
        'bizAddress': bizaddress,
        'bizGstno': bizgstno,
        'tds': btds,
        'tcs': btcs,
        'cgst': cgstamt,
        'sgst': sgstamt,
        'igst': igstamt,
        'bizCommision': bizcom,
        'netPayment': netpayment,
        'advisorStatecode': adstcode,
        'userStatecode': usstcode,
        'sac': sac,
        'bizState': bizstate,
        'bizTax':biztax,
        'userTax':ingst-exegst,
        'gstType':gsttype,
        'description':description,
        'bizStatecode':bizstcode,
        'bizName':bizname,
        'advisorState':adstate,



      })
          .then((value) => print("Invoice Added"))
          .catchError((error) => print("Failed to add invoice: $error"));
    }
  }


}
