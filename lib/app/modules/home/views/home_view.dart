import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hallo_doctor_client/app/models/doctor_model.dart';
import 'package:hallo_doctor_client/app/modules/home/views/components/icon_card.dart';
import 'package:hallo_doctor_client/app/modules/home/views/components/list_doctor_card.dart';
import 'package:hallo_doctor_client/app/service/doctor_service.dart';
import 'package:hallo_doctor_client/app/utils/constants/style_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service/user_service.dart';
import '../../appointment/controllers/appointment_controller.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {



  AppointmentController controller1 = AppointmentController();

  Future<void> _fetchSharedPreferencesValues(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orderId = prefs.getString('orderId');
    String? previoustransactionStatus =
        prefs.getString('previoustransactionStatus');

    Stream<DocumentSnapshot<Map<String, dynamic>>> orderStream =
        FirebaseFirestore.instance
            .collection('Order') // Replace with the actual collection name
            .doc(orderId) // Replace with the actual document ID
            .snapshots();

    orderStream.listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        var orderData = documentSnapshot.data();
        var transactionStatus = orderData!['transactionStatus'];

        if (previoustransactionStatus == "NotPay" &&
            transactionStatus == "Success") {
          addInvoice(orderId);

          prefs.setString('previoustransactionStatus', "Success");
          // Display a dialog box
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Payment Success'),
                content: Text('Your payment successful.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        } else if (previoustransactionStatus == "NotPay" &&
            transactionStatus == "Failed") {
          prefs.setString('previoustransactionStatus', "Failed");
          // Display a dialog box
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Payment Failed'),
                content: Text('Your payment is failed.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CarouselController caoruselController = CarouselController();


    // controller1.getListAppointment1();
    _fetchSharedPreferencesValues(context);
    return WillPopScope(
        // Wrap with WillPopScope
        onWillPop: () => _onBackPressed(context),
        child: Scaffold(
          backgroundColor: mBackgroundColor,
          body: SafeArea(
            child: Obx(
              () => CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.fromLTRB(17, 15, 17, 10),
                          child: Container(
                            child: Row(
                              children: [
                                controller.userPicture.value.isEmpty
                                    ? Image.asset('assets/images/user.png')
                                    : CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                controller.userPicture.value),
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(left: 14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Welcome Back,'.tr,
                                        style: mWelcomeTitleStyle,
                                      ),
                                      Text(
                                        controller.userService.currentUser!
                                            .displayName!,
                                        style: mUsernameTitleStyle,
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'Owner App'.tr,
                                    style: GoogleFonts.abhayaLibre(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                                // Expanded(
                                //     child: Container(
                                //   alignment: Alignment.centerRight,
                                //   child: IconButton(
                                //       onPressed: () {},
                                //       icon: Icon(Icons.notifications_none)),
                                // ))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GetBuilder<HomeController>(
                            builder: (_) {
                              return CarouselSlider(
                                carouselController: caoruselController,
                                options: CarouselOptions(
                                    height: 200,
                                    autoPlay: true,
                                    aspectRatio: 2.0,
                                    viewportFraction: 0.9,
                                    onPageChanged: (index, reason) {
                                      controller.carouselChange(index);
                                    }),
                                items: imgListAssetSlider(
                                    controller.listImageCarousel),
                              );
                            },
                          ),
                        ),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: controller.listImageCarousel.isNotEmpty
                                ? controller.listImageCarousel
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                    return GestureDetector(
                                      onTap: () => caoruselController
                                          .animateToPage(entry.key),
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black)
                                                .withOpacity(controller
                                                            .getcaoruselIndex ==
                                                        entry.key
                                                    ? 0.9
                                                    : 0.4)),
                                      ),
                                    );
                                  }).toList()
                                : imgListAsset.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () => caoruselController
                                          .animateToPage(entry.key),
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black)
                                                .withOpacity(controller
                                                            .getcaoruselIndex ==
                                                        entry.key
                                                    ? 0.9
                                                    : 0.4)),
                                      ),
                                    );
                                  }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconCard(
                                iconData: Icons.category,
                                text: "Advisor Specialist".tr,
                                onTap: () {
                                  controller.toDoctorCategory();
                                },
                              ),
                              IconCard(
                                iconData: Icons.list_alt_rounded,
                                text: "Top Rated Advisor".tr,
                                onTap: () {
                                  controller.toTopRatedDoctor();
                                },
                              ),
                              IconCard(
                                iconData: Icons.search,
                                text: "Search Advisor".tr,
                                onTap: () {
                                  controller.toSearchDoctor();
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Top Rated Advisor'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: TextButton(
                                  onPressed: () {
                                    controller.toTopRatedDoctor();
                                  },
                                  child: Text('View All'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[300])),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            displacement: 10,
                            onRefresh: () => test(),
                            child: FutureBuilder<List<Doctor>>(
                              future: DoctorService().getTopRatedDoctor(),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: CircularProgressIndicator());
                                  default:
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('error '.tr +
                                            snapshot.error.toString()),
                                      );
                                    } else if (snapshot.data!.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'Top Rated Advisor is empty '.tr,
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (contex, index) =>
                                              DoctorCard(
                                                doctorName: snapshot
                                                    .data![index].doctorName,
                                                doctorSpecialty: snapshot
                                                    .data![index]
                                                    .doctorCategory!
                                                    .categoryName,
                                                imageUrl: snapshot
                                                    .data![index].doctorPicture,
                                                rating: snapshot
                                                    .data![index].doctorRating,
                                                onTap: () {
                                                  Get.toNamed('/detail-doctor',
                                                      arguments: snapshot
                                                          .data![index]);
                                                },
                                              ));
                                    }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> test() async {
    return Future.delayed(Duration(seconds: 5));
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

final List<String> imgListAsset = [
  'assets/icons/ic_launcher.png',
  'assets/icons/ic_launcher.png'
];

List<Widget> imgListAssetSlider(List<String?> imgCarouselList) {
  if (imgCarouselList.isEmpty) {
    return imgListAsset
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                      ],
                    )),
              ),
            ))
        .toList();
  }
  return imgCarouselList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item ?? "",
                          fit: BoxFit.cover, width: 1000.0),
                    ],
                  )),
            ),
          ))
      .toList();
}



Future<void> addInvoice(String? orderId) async {
  final UserService userService = Get.find();

  var languageSettingVersionRef3 =
      await FirebaseFirestore.instance.collection('Order').doc(orderId).get();
  String timeSlotId = languageSettingVersionRef3.data()!['timeSlotId'];

  var languageSettingVersionRef4 = await FirebaseFirestore.instance
      .collection('DoctorTimeslot')
      .doc(timeSlotId)
      .get();
  String doctorId = languageSettingVersionRef4.data()!['doctorId'];
  Timestamp timeSlot = languageSettingVersionRef4.data()!['timeSlot'];

  DateTime? dateTime1 = timeSlot.toDate();
  String formattedDateval =
      DateFormat("MMMM dd, y 'at' hh:mm:ss a").format(dateTime1);

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
    int cgst = languageSettingVersionRef2.data()!['cgst'] as int;
    int sgst = languageSettingVersionRef2.data()!['sgst'] as int;

    int totaltax = cgst + sgst;
    int igst = 0;

    DateTime now = DateTime.now();

    String month = DateFormat('MM').format(now);
    int currentMonth = int.parse(month);
    int currentyear = now.year % 100;

    if (currentMonth >= 04) {
      int y = currentyear + 1;
      fy = '$currentyear' + '_' + '$y';
    } else {
      int y = currentyear - 1;
      fy = '$y' + '_' + '$currentyear';
    }

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference collection = firestore.collection('Invoice');

    QuerySnapshot querySnapshot = await collection
        .where('financialYear', isEqualTo: fy)
        .where('uniqueKey', isEqualTo: uniquekey)
        .get();
    if (querySnapshot.size > 0) {
      QuerySnapshot querySnapshot = await collection
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      String num1 = querySnapshot.docs.first.get('number');

      String num2 = "001";
      int sum = int.parse(num1) + int.parse(num2);
      number = sum.toString().padLeft(3, '0');

      invoiceno = '$uniquekey' + "_" + fy + "_" + number;
    } else {
      number = '001';
      invoiceno = '$uniquekey' + "_" + fy + "_" + number;
    }

    final CollectionReference invoiceCollection =
        FirebaseFirestore.instance.collection('Invoice');
    final includedGstamt = ((price! * totaltax) / 100) + price!;
    final roundedIncludedGstamt =
        double.parse(includedGstamt.toStringAsFixed(2));
    return invoiceCollection
        .add({
          'invoiceno': invoiceno,
          'advisorName': drname,
          'advisorAddress': draddress,
          'advisorGstno': drgstno,
          'userName': usname,
          'userAddress': usaddress,
          'userGstno': usgstno,
          'excludedGstamt': double.parse(price!.toStringAsFixed(2)),
          'includedGstamt': roundedIncludedGstamt,
          'createdAt': now,
          'userId': userService.getUserId(),
          'advisorId': doctorId,
          'cgst': double.parse(((price! * cgst) / 100).toStringAsFixed(2)),
          'sgst': double.parse(((price! * sgst) / 100).toStringAsFixed(2)),
          'igst': double.parse(((price! * igst) / 100).toStringAsFixed(2)),
          'tax': double.parse(((price! * totaltax) / 100).toStringAsFixed(2)),
          'timeslot': timeSlotId,
          'financialYear': fy,
          'uniqueKey': uniquekey,
          'number': number,
          'advisorState': drstate,
          'advisorStatecode': drstcode,
          'userState': usstate,
          'userStatecode': usstcode,
          'sac': sac,
          'description': formattedDateval + "_" + drname + "_" + usname,
          'gstType': gsttype,
          'status': 'Success',
          'cancelled': now,
          'action': 'success',
        })
        .then((value) => print("Invoice Added"))
        .catchError((error) => print("Failed to add invoice: $error"));
  } else {
    int igst = languageSettingVersionRef2.data()!['igst'] as int;

    int totaltax = igst;
    int cgst = 0, sgst = 0;
    DateTime now = DateTime.now();

    // DateTime dateTime = DateTime.parse(timeSlot.toString());
    // String formattedDate = DateFormat("MMMM dd, y 'at' hh:mm:ss a").format(
    //     dateTime);
    // print("formattedDate");
    // print(formattedDate);

    String month = DateFormat('MM').format(now);
    int currentMonth = int.parse(month);
    int currentyear = now.year % 100;

    if (currentMonth >= 04) {
      int y = currentyear + 1;
      fy = '$currentyear' + '_' + '$y';
    } else {
      int y = currentyear - 1;
      fy = '$y' + '_' + '$currentyear';
    }

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference collection = firestore.collection('Invoice');

    QuerySnapshot querySnapshot = await collection
        .where('financialYear', isEqualTo: fy)
        .where('uniqueKey', isEqualTo: uniquekey)
        .get();
    if (querySnapshot.size > 0) {
      QuerySnapshot querySnapshot = await collection
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      String num1 = querySnapshot.docs.first.get('number');

      String num2 = "001";
      int sum = int.parse(num1) + int.parse(num2);
      number = sum.toString().padLeft(3, '0');

      invoiceno = '$uniquekey' + "_" + fy + "_" + number;
    } else {
      number = '001';
      invoiceno = '$uniquekey' + "_" + fy + "_" + number;
    }

    final CollectionReference invoiceCollection =
        FirebaseFirestore.instance.collection('Invoice');
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
          'includedGstamt': (((price! * totaltax) / 100) + price!),
          'createdAt': now,
          'userId': userService.getUserId(),
          'advisorId': doctorId,
          'cgst': ((price! * cgst) / 100),
          'sgst': ((price! * sgst) / 100),
          'igst': ((price! * igst) / 100),
          'tax': ((price! * totaltax) / 100),
          'timeslot': timeSlotId,
          'financialYear': fy,
          'uniqueKey': uniquekey,
          'number': number,
          'advisorState': drstate,
          'advisorStatecode': drstcode,
          'userState': usstate,
          'userStatecode': usstcode,
          'sac': sac,
          'description': formattedDateval + "_" + drname + "_" + usname,
          'gstType': gsttype,
          'status': 'Success',
          'cancelled': now,
          'action': 'success',
        })
        .then((value) => print("Invoice Added"))
        .catchError((error) => print("Failed to add invoice: $error"));
  }


}
