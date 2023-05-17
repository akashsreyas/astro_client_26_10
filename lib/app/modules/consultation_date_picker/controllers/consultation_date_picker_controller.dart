

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/doctor_model.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/service/doctor_service.dart';
import 'package:hallo_doctor_client/app/service/timeslot_service.dart';

import '../../../service/user_service.dart';


enum TimeSlotStatus { startUp, unselected, selected }

class ConsultationDatePickerController extends GetxController
    with StateMixin<List<TimeSlot>> {
  List<TimeSlot> allTimeSlot = List.empty();
  late List<TimeSlot> selectedDateTimeslot = List.empty();
  var selectedTimeSlot = TimeSlot().obs;
  Doctor doctor = Get.arguments[0];
  bool isReschedule = false;
  final UserService userService = Get.find();
  late String nav="1";



  late String drstate="",drname="",draddress="",drgstno="",usstate="",usname="",usaddress="",usgstno="",uniquekey="",drstcode="",usstcode="",gsttype="",timeslotbooking="",bookeduser="";
  @override
  Future<void> onInit() async {


    super.onInit();
    if (Get.arguments[1] != null) isReschedule = true;
    print('is Reschedule $isReschedule');
    DoctorService().getDoctorTimeSlot(doctor).then((timeSlot) {
      allTimeSlot = timeSlot;
      updateScheduleAtDate(
          DateTime.now().day, DateTime.now().month, DateTime.now().year);
    }).onError((error, stackTrace) {
      change([], status: RxStatus.error(error.toString()));
    });



    var languageSettingVersionRef = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doctor.doctorId)
        .get();
    drstate = languageSettingVersionRef.data()!['state'];
    drname = languageSettingVersionRef.data()!['doctorName'];
    draddress = languageSettingVersionRef.data()!['address'];
    drgstno = languageSettingVersionRef.data()!['gstno'];
    uniquekey = languageSettingVersionRef.data()!['uniquekey'];
    drstcode= languageSettingVersionRef.data()!['statecode'];
    gsttype=languageSettingVersionRef.data()!['gstType'];




    //Getting user details
    var languageSettingVersionRef1 = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userService.getUserId())
        .get();
    usname = languageSettingVersionRef1.data()!['displayName'];
    usstate = languageSettingVersionRef1.data()!['state'];
    usaddress = languageSettingVersionRef1.data()!['address'];
    usgstno = languageSettingVersionRef1.data()!['gstno'];
    usstcode = languageSettingVersionRef1.data()!['code'];


  }

  @override
  void onClose() {}

  void updateScheduleAtDate(int date, int month, int year) {
    var schedule = allTimeSlot
        .where((timeSlot) =>
            timeSlot.timeSlot!.day.isEqual(date) &&
            timeSlot.timeSlot!.month.isEqual(month) &&
            timeSlot.timeSlot!.year.isEqual(year))
        .toList();
    print('Schedule for date ${date.toString()} is : ' +
        schedule.length.toString());
    change(schedule, status: RxStatus.success());
  }
void billing(){

  Get.toNamed(
    '/billingdetails',
    arguments: nav,
  );
}
  void confirm() async {

    String user=userService.getUserId();

    var booking = await FirebaseFirestore.instance
        .collection('DoctorTimeslot')
        .doc(selectedTimeSlot.value.timeSlotId)
        .get();
    timeslotbooking = booking.data()!['booking'];
    bookeduser = booking.data()!['bookeduser'];


    if(timeslotbooking=="Open"){

      try {

        await FirebaseFirestore.instance
            .collection('DoctorTimeslot')
            .doc(selectedTimeSlot.value.timeSlotId)
            .update({'booking': 'Closed','bookeduser':userService.getUserId()});

      } catch (e) {
        return Future.error(e.toString());
      }





    try {
      if (isReschedule) {
        EasyLoading.show();
        await TimeSlotService()
            .rescheduleTimeslot(Get.arguments[1], selectedTimeSlot.value);
        Fluttertoast.showToast(
            msg: 'Appointment has been successfully rescheduled'.tr);
        EasyLoading.dismiss();
        Get.back();
      } else {

        var languageSettingVersionRef = await FirebaseFirestore.instance
            .collection('Settings')
            .doc('withdrawSetting')
            .get();
        String sac = languageSettingVersionRef.data()!['sacAdvisor'];


        //Check state is equal
        if(drstate==usstate){
          int cgst = languageSettingVersionRef.data()!['cgst'] as int;
          int sgst = languageSettingVersionRef.data()!['sgst'] as int;



            int totaltax=cgst+sgst;
            int igst=0;


              Get.toNamed(
                '/detail-order',
                arguments: [selectedTimeSlot.value, doctor,drname,draddress,drgstno,usname,usaddress,usgstno,cgst,sgst,igst,totaltax,uniquekey,drstate,drstcode,usstate,usstcode,sac,gsttype],
              );




        }else{

          int igst = languageSettingVersionRef.data()!['igst'] as int;

          int totaltax=igst;
          int cgst=0,sgst=0;



            Get.toNamed(
              '/detail-order',
              arguments: [selectedTimeSlot.value, doctor,drname,draddress,drgstno,usname,usaddress,usgstno,cgst,sgst,igst,totaltax,uniquekey,drstate,drstcode,usstate,usstcode,sac,gsttype],
            );
                  }



      }
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: e.toString());
    }
    }else if(timeslotbooking=="Closed" && user==bookeduser){
      try {
        if (isReschedule) {
          EasyLoading.show();
          await TimeSlotService()
              .rescheduleTimeslot(Get.arguments[1], selectedTimeSlot.value);
          Fluttertoast.showToast(
              msg: 'Appointment has been successfully rescheduled'.tr);
          EasyLoading.dismiss();
          Get.back();
        } else {

          var languageSettingVersionRef = await FirebaseFirestore.instance
              .collection('Settings')
              .doc('withdrawSetting')
              .get();
          String sac = languageSettingVersionRef.data()!['sacAdvisor'];


          //Check state is equal
          if(drstate==usstate){
            int cgst = languageSettingVersionRef.data()!['cgst'] as int;
            int sgst = languageSettingVersionRef.data()!['sgst'] as int;



            int totaltax=cgst+sgst;
            int igst=0;


            Get.toNamed(
              '/detail-order',
              arguments: [selectedTimeSlot.value, doctor,drname,draddress,drgstno,usname,usaddress,usgstno,cgst,sgst,igst,totaltax,uniquekey,drstate,drstcode,usstate,usstcode,sac,gsttype],
            );




          }else{

            int igst = languageSettingVersionRef.data()!['igst'] as int;

            int totaltax=igst;
            int cgst=0,sgst=0;



            Get.toNamed(
              '/detail-order',
              arguments: [selectedTimeSlot.value, doctor,drname,draddress,drgstno,usname,usaddress,usgstno,cgst,sgst,igst,totaltax,uniquekey,drstate,drstcode,usstate,usstcode,sac,gsttype],
            );
          }



        }
      } catch (e) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
    else{

      Fluttertoast.showToast(msg: 'Timeslot under process by another user may open after sometime'.tr);
      print('closed');
    }
  }




}
