import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/widgets/empty_list.dart';

import '../../../utils/timeformat.dart';
import '../controllers/appointment_controller.dart';
import 'package:intl/intl.dart';

class AppointmentView extends GetView<AppointmentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'.tr),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return controller.getListAppointment();
        },
        child: Container(
          height: Get.height,
          child: controller.obx(
            (listTimeslot) => ListView.builder(
              itemCount: listTimeslot!.length,
              shrinkWrap: true,
              itemBuilder: (contex, index) {
                return Card(

                  child: ListTile(
                    onTap: () {
                      Get.toNamed('/appointment-detail',
                          arguments: listTimeslot[index]);
                    },
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          listTimeslot[index].doctor!.doctorPicture!),
                    ),
                    title: Text('Appointment with '.tr +
                        listTimeslot[index].doctor!.doctorName!),
                    subtitle: Text(
                      'at '.tr +
                          TimeFormat().formatDate(
                              listTimeslot[index].timeSlot as DateTime) + "\nStatus : "+listTimeslot[index].status!,
                      style: listTimeslot[index].status == 'Cancelled'
                          ? TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ):null,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
            onEmpty: Center(
              child: EmptyList(msg: 'you don\'t have an appointment yet'.tr),
            ),
          ),
        ),
      ),
    );
  }
  Color _getContainerColor(String? callStatus) {
    switch (callStatus) {
      case '1':
        return Colors.blue;
      case '0':
        return Colors.white;

      default:
        return Colors.white;
    }
  }
}
