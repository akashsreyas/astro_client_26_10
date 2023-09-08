import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:hallo_doctor_client/app/utils/constants/constants.dart';
import 'package:hallo_doctor_client/app/utils/constants/style_constants.dart';

import '../../appointment/controllers/appointment_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/transaction_success_controller.dart';

class TransactionSuccessView extends GetView<TransactionSuccessController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment Success'.tr),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  child: Lottie.asset('assets/animations/done.json',
                      height: 250,
                      repeat: false,
                      controller: controller.animController,
                      onLoaded: (composition) {
                    controller.animController.forward();
                  })),
              Text(
                'Payment Successfull'.tr,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.green),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Your payment has been processed! \n Details of transaction are included below'
                    .tr,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: mSubtitleColor),
                textAlign: TextAlign.center,
              ),
              Divider(
                height: 30,
              ),
           Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('TOTAL AMOUNT PAID'.tr),
                      Text(currencySign + "controller.room.toString()")
                    ],
                  ),
              Divider(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('TRANSACTION DATE'.tr),
                  Text(DateTime.now().toLocal().toString())
                ],
              ),
              Divider(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {

                },
                child: Text('Go Home'.tr),
              )
              // ElevatedButton(
              //     onPressed: () {
              //       // controller.goHome();
              //       Get.offNamed('/');
              //
              //
              //       print('click');
              //
              //
              //     },
              //     child: Text('Go Home'.tr))
            ],
          ),
        ));
  }

}
