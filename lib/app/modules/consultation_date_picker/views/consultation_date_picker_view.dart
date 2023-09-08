import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hallo_doctor_client/app/utils/constants/style_constants.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_pages.dart';
import '../../detail_order/views/detail_order_view.dart';
import '../../profile/views/pages/billingdetails.dart';
import '../controllers/consultation_date_picker_controller.dart';

class ConsultationDatePickerView extends StatefulWidget {

  _MyPageState createState() => _MyPageState();


}
class _MyPageState extends State<ConsultationDatePickerView> {
  @override
  final ConsultationDatePickerController _consultationController = Get.put(
      ConsultationDatePickerController());
  late bool isExpired;
  late bool isExpiredcheck;
  late bool isadvExpired;
  late bool isadvExpiredcheck;

  late int advhour=0,advminute=0;
  @override
  void initState() {
    super.initState();
    _consultationController.onInit();

 }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Timeslot'.tr),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Choose Date'.tr,
              style: titleTextStyle,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 90,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: DatePicker(
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              daysCount: 30,
              selectionColor: secondaryColor,
              onDateChange: (date) {
                _consultationController.updateScheduleAtDate(
                    date.day, date.month, date.year);
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Choose Time'.tr,
              style: titleTextStyle,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: _consultationController.obx(
                (timeSlot) => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: timeSlot!.length,
                  itemBuilder: (BuildContext ctx, index) {
                    var timeStartFormat =
                        DateFormat("hh:mm a").format(timeSlot[index].timeSlot!);
                    var timeEnd = timeSlot[index]
                        .timeSlot!
                        .add(Duration(minutes: timeSlot[index].duration!));

                    var timeEndFormat = DateFormat("hh:mm a").format(timeEnd);
                    var amt=  timeSlot[index].price!;




                    if (timeSlot[index].available!) {
                      // if(timeSlot[index].booking=='Closed'){
                      //   DateTime currentTime = DateTime.now();
                      //
                      //   // Get the start and end times of the slot
                      //   DateTime startTime = timeSlot[index].timeSlot!;
                      //   DateTime endTime = startTime.add(Duration(minutes: timeSlot[index].duration!));
                      //
                      //   // Check if the slot is expired (past the current time)
                      //   isExpired = currentTime.isAfter(endTime);
                      //
                      //
                      //   // advhour =2;
                      //   // advminute=15;
                      //   DateTime advendTime = currentTime.add(Duration(hours: 2,minutes: 15));
                      //   isadvExpired = startTime.isBefore(advendTime);
                      //
                      //   return InkWell(
                      //     onTap: () {
                      //       _consultationController.selectedTimeSlot.value = timeSlot[index];
                      //     },
                      //     child: Obx(
                      //           () => Container(
                      //         alignment: Alignment.center,
                      //             child:
                      //             // Text(
                      //             //   isExpired ? '$timeStartFormat - $timeEndFormat\n${amt!}Expired' : '$timeStartFormat - $timeEndFormat\n${amt!}${'\n Under Processing'.tr}',
                      //             //   textAlign: TextAlign.center,
                      //             // ),
                      //             Text(
                      //               isExpired
                      //                   ? '$timeStartFormat - $timeEndFormat\n${amt!}\nExpired'
                      //                   : isadvExpired
                      //                   ? '$timeStartFormat - $timeEndFormat\n${amt!}\nAdvanced Expired'
                      //                   : '$timeStartFormat - $timeEndFormat\n${amt!}${'\n Under Processing'.tr}'
                      //               ,
                      //               textAlign: TextAlign.center,
                      //             ),
                      //
                      //             decoration: (_consultationController.selectedTimeSlot.value == timeSlot[index])
                      //                 ? BoxDecoration(
                      //               color: isExpired ? Colors.grey[300] : (isadvExpired ? Colors.orange[100] : Colors.lightBlue[100]),
                      //               border: Border.all(color: isExpired ? Colors.red : (isadvExpired ? Colors.red : Colors.deepOrange), width: 5  ),
                      //               borderRadius: BorderRadius.circular(15),
                      //             )
                      //                 : BoxDecoration(
                      //               color: isExpired ? Colors.blueAccent[300] : (isadvExpired ? Colors.brown[100] : Colors.amber[400]),
                      //               borderRadius: BorderRadius.circular(15),
                      //             ),
                      //       ),
                      //     ),
                      //   );
                      // }
                      // else {
                        return InkWell(
                          onTap: () {
                            _consultationController.selectedTimeSlot.value =
                            timeSlot[index];
                          },
                          child: Obx(
                                () {
                              // Get the current time
                              DateTime currentTime = DateTime.now();

                              // Get the start and end times of the slot
                              DateTime startTime = timeSlot[index].timeSlot!;
                              DateTime endTime = startTime.add(
                                  Duration(minutes: timeSlot[index].duration!));

                              // Check if the slot is expired (past the current time)
                              isExpired = currentTime.isAfter(endTime);



                              DateTime advendTime = currentTime.add(
                                  Duration(hours: _consultationController.advhour, minutes: _consultationController.advminute));
                              isadvExpired = startTime.isBefore(advendTime);


                              advhour=_consultationController.advhour;
                              advminute=_consultationController.advminute;

    if (timeSlot[index].booking == 'Closed') {
      return Container(
        alignment: Alignment.center,
        child:
        // Text(
        //   isExpired ? '$timeStartFormat - $timeEndFormat\n${amt!}\nExpired' : '$timeStartFormat - $timeEndFormat\n${amt!}${'\n Available'.tr}',
        //   textAlign: TextAlign.center,
        // ),
        Text(
          isExpired
              ? '$timeStartFormat - $timeEndFormat\n${amt!}\nExpired'
              : isadvExpired
              ? '$timeStartFormat - $timeEndFormat\n${amt!}\nExpired - $advhour:$advminute hour limit'
              : '$timeStartFormat - $timeEndFormat\n${amt!}${'\n Under Processing...'
              .tr}'
          ,
          textAlign: TextAlign.center,
        ),
        decoration: (_consultationController
            .selectedTimeSlot.value == timeSlot[index])
            ? BoxDecoration(
          color: isExpired
              ? Colors.grey[300]
              : (isadvExpired
              ? Colors.orange[100]
              : Colors.deepOrange[100]),
          border: Border.all(color: isExpired
              ? Colors.red
              : (isadvExpired ? Colors.red : Colors
              .deepOrange), width: 5),
          borderRadius: BorderRadius.circular(15),
        )
            : BoxDecoration(
          color: isExpired
              ? Colors.grey[300]
              : (isadvExpired
              ? Colors.orange[100]
              : Colors.deepOrange[400]),
          borderRadius: BorderRadius.circular(15),
        ),


      );
    } else {
      return Container(
        alignment: Alignment.center,
        child:
        // Text(
        //   isExpired ? '$timeStartFormat - $timeEndFormat\n${amt!}\nExpired' : '$timeStartFormat - $timeEndFormat\n${amt!}${'\n Available'.tr}',
        //   textAlign: TextAlign.center,
        // ),
        Text(
          isExpired
              ? '$timeStartFormat - $timeEndFormat\n${amt!}\nExpired'
              : isadvExpired
              ? '$timeStartFormat - $timeEndFormat\n${amt!}\n Expired - $advhour:$advminute hour limit'
              : '$timeStartFormat - $timeEndFormat\n${amt!}${'\n Available'
              .tr}'
          ,
          textAlign: TextAlign.center,
        ),
        decoration: (_consultationController
            .selectedTimeSlot.value == timeSlot[index])
            ? BoxDecoration(
          color: isExpired
              ? Colors.grey[300]
              : (isadvExpired
              ? Colors.orange[100]
              : Colors.green[100]),
          border: Border.all(color: isExpired
              ? Colors.red
              : (isadvExpired ? Colors.red : Colors
              .green), width: 5),
          borderRadius: BorderRadius.circular(15),
        )
            : BoxDecoration(
          color: isExpired
              ? Colors.grey[300]
              : (isadvExpired
              ? Colors.orange[100]
              : Colors.green[400]),
          borderRadius: BorderRadius.circular(15),
        ),


      );
    }
                            },
                          ),
                        );
                     // }

                      // return InkWell(
                      //   onTap: () {
                      //     _consultationController.selectedTimeSlot.value = timeSlot[index];
                      //   },
                      //   child: Obx(
                      //     () => Container(
                      //
                      //       alignment: Alignment.center,
                      //       child: Text(
                      //         '$timeStartFormat - $timeEndFormat\n${amt!}${'\n Available'.tr}',
                      //         textAlign: TextAlign.center,
                      //       ),
                      //
                      //       decoration: (_consultationController.selectedTimeSlot.value ==
                      //               timeSlot[index])
                      //           ? BoxDecoration(
                      //               color: Colors.green[100],
                      //               border: Border.all(
                      //                   color: Colors.green, width: 5),
                      //               borderRadius: BorderRadius.circular(15),
                      //             )
                      //           : BoxDecoration(
                      //               color: Colors.green[400],
                      //               borderRadius: BorderRadius.circular(15),
                      //             ),
                      //     ),
                      //   ),
                      // );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          '$timeStartFormat - $timeEndFormat\n${amt!}${'\n Unavailable'.tr}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(15),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                DateTime currentTime = DateTime.now();

                // Get the start and end times of the slot
                DateTime startTime = _consultationController.selectedTimeSlot.value.timeSlot!;
                DateTime endTime = startTime.add(Duration(minutes: _consultationController.selectedTimeSlot.value.duration!));

                // Check if the slot is expired (past the current time)
                isExpiredcheck = currentTime.isAfter(endTime);


                DateTime advendTime = currentTime.add(Duration(hours: _consultationController.advhour,minutes: _consultationController.advminute));
                isadvExpiredcheck = startTime.isBefore(advendTime);



                // _consultationController.onInit();
                if (_consultationController.selectedTimeSlot.value.timeSlotId == null && _consultationController.numberoftimeslot != '0') {
                  Fluttertoast.showToast(msg: 'Please select time slot'.tr);
                  return;
                  }
                else if(_consultationController.numberoftimeslot == '0'){
                  Fluttertoast.showToast(msg: 'Advisor not available'.tr);
                }
                else if (_consultationController.usaddress.isEmpty||_consultationController.usstate.isEmpty){
                  Fluttertoast.showToast(msg: 'Please Add Billing Details'.tr);
                  _consultationController.billing();
                }
                else if (isExpiredcheck) {
                  Fluttertoast.showToast(msg: 'Time Expired'.tr);

                return;
              } else if (isadvExpiredcheck) {
                  Fluttertoast.showToast(msg: 'Expired - $advhour:$advminute hour limit'.tr);

                return;
              }
               else{
                  _consultationController.confirm();
                }






              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: secondaryColor,
                ),
                child: Text(
                  'Confirm'.tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }


  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            child: Text("OK"),
            onPressed: () {


              Navigator.pop(context);// close the dialog
            },
          ),
        ],
      ),
    );
  }
}


