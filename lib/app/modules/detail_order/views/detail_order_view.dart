import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hallo_doctor_client/app/models/order_detail_model.dart';
import 'package:hallo_doctor_client/app/utils/constants/constants.dart';
import 'package:hallo_doctor_client/app/utils/constants/style_constants.dart';

import '../controllers/detail_order_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';


enum ChosePayment { addCard, creditCard }

class DetailOrderView extends GetView<DetailOrderController> {
  final String assetName = 'assets/icons/powered-by-stripe.svg';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Summary'.tr),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi '.tr + controller.username.value,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: mTitleColor),
                    ),
                    Text(
                      'Before making a payment, make sure the items below are correct'
                          .tr,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: mSubtitleColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 500,
                      width: double.infinity,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          detailOrderTable(),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 25,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 30),
                            child: Text(
                              'Amount : '.tr +
                                  currencySign +
                                  controller.selectedTimeSlot.price.toString(),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: mTitleColor),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(

                            width: double.infinity,
                            height: 25,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 30),

                            child: Text(
                              'CGST : '.tr +
                                  currencySign +
                                  ((controller.selectedTimeSlot.price! * controller.cgst)/100).toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: mTitleColor),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(

                            width: double.infinity,
                            height: 25,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 30),

                            child: Text(
                              'SGST : '.tr +
                                  currencySign +
                                  ((controller.selectedTimeSlot.price! * controller.sgst)/100).toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: mTitleColor),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(

                            width: double.infinity,
                            height: 25,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 30),

                            child: Text(
                              'IGST : '.tr +
                                  currencySign +
                                  ((controller.selectedTimeSlot.price! * controller.igst)/100).toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: mTitleColor),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(

                            width: double.infinity,
                            height: 25,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 30),

                            child: Text(
                              'Total Tax Amount : '.tr +
                                  currencySign +
                                  ((controller.selectedTimeSlot.price! * controller.totaltax)/100).toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: mTitleColor),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(

                            width: double.infinity,
                            height: 25,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 30),

                            child: Text(
                              'Total Amount : '.tr +
                                  currencySign +
                                  (((controller.selectedTimeSlot.price! * controller.totaltax)/100)+controller.selectedTimeSlot.price!).toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: mTitleColor),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(

                            width: double.infinity,
                            height: 25,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(right: 30),

                            child: Text(
                              'Billing Details ',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: mTitleColor),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(right: 30),
                            child: Text(
                              'Billing Address : '.tr + controller.usaddress.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: mTitleColor,
                              ),
                              textAlign: TextAlign.left,
                              maxLines: null, // Allow the text to wrap to multiple lines
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Container(

                            width: double.infinity,
                            height: 25,
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(right: 30),

                            child: Text(
                              'GST No : '.tr +
                                  controller.usgstno.toString(),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: mTitleColor),
                            ),
                          ),
                        ],
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    InkWell(
                      onTap: () async {


                         _showPopUpChooser(context);

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
                    )
                  ],
                )),
          ),
        ));
  }

  Widget detailOrderTable() {
    final column = ['Item'.tr, 'Duration'.tr, 'Time'.tr, 'Price'.tr];
    final listOrderItem = [controller.buildOrderDetail()];
    return DataTable(
      columns: getColumn(column),
      rows: getRows(listOrderItem),
      columnSpacing: 5,
    );
  }

  List<DataColumn> getColumn(List<String> column) => column
      .map((e) => DataColumn(
              label: Container(
            child: Text(e),
          )))
      .toList();

  List<DataRow> getRows(List<OrderDetailModel> orderDetailItem) =>
      orderDetailItem.map((e) {
        final cells = [e.itemName, e.duration, e.time, e.price];
        return DataRow(cells: getCells(cells));
      }).toList();
  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((e) => DataCell(Text(
            '$e',
            style: tableCellText,
          )))
      .toList();

  Widget bottomSheetPaymenMethod() {
    return Container(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Choose Payment Method",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: mTitleColor),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text("CREDIT CARD"),
              trailing: Icon(Icons.add_circle, color: secondaryColor),
              onTap: () {
                controller.makePayment();
              },
            ),
            ListTile(
              title: Text("TEST PAYMENT"),
              trailing: Icon(Icons.credit_card, color: secondaryColor),
              onTap: () {
                //
              },
            ),
            SizedBox(
              height: 30,
            ),
            SvgPicture.asset(
              assetName,
              color: secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
  void _showPopUpChooser(BuildContext context) {
    getPaymentModes().then((paymentModes) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Choose Payment Gateway',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  tileColor: Colors.blue,
                ),
                if (paymentModes['razorState'] == true)
                  ListTile(
                    leading: Image.asset(
                      'assets/icons/razicon.png', // Replace with the path to your asset icon
                      width: 50, // Set the desired width
                      height: 50, // Set the desired height
                    ),
                    title: Text('Razorpay(Card, UPI, Netbanking, Wallet)'),
                    onTap: () {
                      // Handle Razorpay payment
                      controller.payWithRazorpay();
                    },
                  ),
                if (paymentModes['instaState'] == true)
                  ListTile(
                    leading: Image.asset(
                      'assets/icons/instamojoicon.png', // Replace with the path to your asset icon
                      width: 50, // Set the desired width
                      height: 50, // Set the desired height
                    ),
                    title: Text('Instamojo(Upi, Netbanking, Wallet)'),
                    onTap: () {

                      controller.payWithInstamojo();

                    },
                  ),
                // Add more options if needed
              ],
            ),
          );
        },
      );
    });
  }



  Future<Map<String, bool>> getPaymentModes() async {
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('Settings').doc('instaMojo').get();

    Map<String, bool> paymentModes = {
      'instaState': snapshot.get('instaState') == 'true', // Convert to bool
      'razorState': snapshot.get('razorState') == 'true', // Convert to bool
    };

    return paymentModes;
  }
}
