
import 'dart:typed_data';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hallo_doctor_client/app/models/review_model.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/profile_controller.dart';
import 'InvoiceItem.dart';
import 'change_password.dart';


class InvoiceListScreen extends StatefulWidget {
  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<InvoiceListScreen> {
  DateTime now = DateTime.now();
  final CollectionReference invoicesCollection =
  FirebaseFirestore.instance.collection('Invoice');
  final ProfileController Controller = Get.put(ProfileController());
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedendDate = DateTime.now();

  final TextEditingController _dateControllerstart = TextEditingController();
  final TextEditingController _dateControllerend = TextEditingController();
  late String startdate,enddate;

  late String ff;
  late DateTime toDate=DateTime.now();
  late DateTime fromDate=DateTime.parse(ff);
  late int year,month;


  ///nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn//

  DateTime currentDate = DateTime.now();

// Determine the financial year based on the current date










  final firestoreInstance = FirebaseFirestore.instance;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateControllerstart.text = '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
        startdate= _dateControllerstart.text;


      });
    }
  }


  Future<void> _selectDateend(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedendDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedendDate) {
      setState(() {
        _selectedendDate = picked;

        _dateControllerend.text = '${_selectedendDate.year}-${_selectedendDate.month}-${_selectedendDate.day}';
        enddate= _dateControllerend.text;



      });
    }
  }





  Future<void> _exportData(DateTime start,DateTime end) async {
    String fromname,fromaddress,fromstate,fromstatecode;

    var languageSettingVersionRef = await FirebaseFirestore.instance
        .collection('Settings')
        .doc('withdrawSetting')
        .get();
    String bizName = languageSettingVersionRef.data()!['name'];
    String bizAddress = languageSettingVersionRef.data()!['address'];
    String bizState = languageSettingVersionRef.data()!['state'];
    String bizStatecode = languageSettingVersionRef.data()!['stateCode'];



    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Invoice').where('createdAt', isGreaterThanOrEqualTo:Timestamp.fromDate(start)).where('createdAt', isLessThanOrEqualTo: end).where('userId',isEqualTo:  UserService().currentUser!.uid).get();
    final List<List<dynamic>> csvData = [];
    csvData.add([
      'Invoice No', 'Description','Invoice Date','From Name', 'From Address','From State','From State Code','From GSTNo','To Name', 'To Address','To State','To State Code','To GSTNo','HSN/SAC',
      'Price','CGST','SGST','IGST',
      'Total Tax','Total Amount','Status',
    ]); // Header row for CSV

    snapshot.docs.forEach((doc) {
      DateTime createdAtDateTime = doc.data()['createdAt'].toDate();
      String formattedDate = DateFormat('dd-MM-yyyy').format(createdAtDateTime);
      String gsttype= doc.data()['gstType'];

      print(gsttype);
      print( doc.data()['invoiceno']);
      if(gsttype == 'Biz'){
        print("inside");
        fromname=bizName;
        fromaddress=bizAddress;
        fromstate=bizState;
        fromstatecode=bizStatecode;

        csvData.add([

          doc.data()['invoiceno'],
          doc.data()['description'],
          formattedDate,
          fromname,
          fromaddress,
          fromstate,
          fromstatecode,
          doc.data()['advisorGstno'],
          doc.data()['userName'],
          doc.data()['userAddress'],
          doc.data()['userState'],
          doc.data()['userStatecode'],
          doc.data()['userGstno'],
          doc.data()['sac'],
          doc.data()['excludedGstamt'],
          doc.data()['cgst'],
          doc.data()['sgst'],
          doc.data()['igst'],
          doc.data()['tax'],
          doc.data()['includedGstamt'],
          doc.data()['status'],
        ]);

      }else{
        fromname=doc.data()['advisorName'];
        fromaddress= doc.data()['advisorAddress'];
        fromstate=   doc.data()['advisorState'];
        fromstatecode= doc.data()['advisorStatecode'];

        csvData.add([

          doc.data()['invoiceno'],
          doc.data()['description'],
          formattedDate,
          fromname,
          fromaddress,
          fromstate,
          fromstatecode,
          doc.data()['advisorGstno'],
          doc.data()['userName'],
          doc.data()['userAddress'],
          doc.data()['userState'],
          doc.data()['userStatecode'],
          doc.data()['userGstno'],
          doc.data()['sac'],
          doc.data()['excludedGstamt'],
          doc.data()['cgst'],
          doc.data()['sgst'],
          doc.data()['igst'],
          doc.data()['tax'],
          doc.data()['includedGstamt'],
          doc.data()['status'],
        ]);
      }

    });









    //
    //  final csvString = const ListToCsvConverter().convert(csvData);
    //
    // final String currentDate = DateTime.now().toString().split(' ')[0];
    //
    // bool granted = await _requestStoragePermission();
    // if (granted) {
    //   String? folderPath = await FilePicker.platform.getDirectoryPath();
    //   if (folderPath != null) {
    //
    //     String filePath = '$folderPath/Invoice$currentDate.csv';
    //     File file = File(filePath);
    //     await file.writeAsString(csvString);
    //   } else {
    //     throw Exception('Folder selection cancelled.');
    //   }
    // } else {
    //   // Display error message
    // }

    final String currentDate = DateTime.now().toString().split(' ')[0];
    Directory? downloadDirectory = await getExternalStorageDirectory();
    String filePath = '${downloadDirectory!.path}/$currentDate.csv';
    String csv = const ListToCsvConverter().convert(csvData);
    File file = File(filePath);
    await file.writeAsString(csv);
    Share.shareFiles([filePath]);





  }




  @override
  Widget build(BuildContext context) {


     year = currentDate.year;
     month = currentDate.month;
    late String endYear;
    if (month <= 3) {
      endYear = "${year-1}";
    } else {
      endYear = "${year}";
    }


  ff=(endYear+"-04-01 00:00:00.000") as String;








    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice List'),
        actions: [

          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _exportData(fromDate,toDate);

              // showDialog(
              //   context: context,
              //   builder: (context) => AlertDialog(
              //     title: Text('Select Date Range'),
              //     content: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children:<Widget>[
              //         TextField(
              //           controller: _dateControllerstart,
              //           readOnly: true,
              //           onTap: () => _selectDate(context),
              //           decoration: InputDecoration(
              //             labelText: 'Start Date',
              //             hintText: 'Select start date',
              //             suffixIcon: Icon(Icons.calendar_today),
              //             border: OutlineInputBorder(),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         TextField(
              //           controller: _dateControllerend,
              //           readOnly: true,
              //           onTap: () => _selectDateend(context),
              //           decoration: InputDecoration(
              //             labelText: 'End Date',
              //             hintText: 'Select end date',
              //             suffixIcon: Icon(Icons.calendar_today),
              //             border: OutlineInputBorder(),
              //           ),
              //         ),
              //       ],
              //     ),
              //     actions: [
              //       TextButton(
              //         child: Text('Cancel'),
              //         onPressed: () {
              //           Navigator.of(context).pop();
              //         },
              //       ),
              //       ElevatedButton(
              //         child: Text('Export'),
              //         onPressed: () {
              //           Navigator.of(context).pop();
              //           _exportData(_selectedDate,_selectedendDate);
              //         },
              //       ),
              //     ],
              //   ),
              // );
            },
          ),



        ],


      ),



      body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {

                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2025),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            fromDate = value;
                            print(fromDate);
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Custom background color
                      onPrimary: Colors.white, // Custom text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Custom border radius
                      ),
                    ),
                    child: Text('Select From Date'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2025),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            toDate = value;
                          });
                        }
                      });

                    },

                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Custom background color
                      onPrimary: Colors.white,
                      // Custom text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // Custom border radius
                      ),
                    ),
                    child: Text('Select To Date') ,
                  ),
                ]
            ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            DateFormat('yyyy-MM-dd').format(fromDate),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
           'To',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            DateFormat('yyyy-MM-dd').format(toDate),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          )
      ],
      ),
      Expanded(
        child:
      StreamBuilder<QuerySnapshot>(


        stream: FirebaseFirestore.instance
            .collection('Invoice')
            .where('userId', isEqualTo: UserService().currentUser!.uid)
            .where('createdAt', isGreaterThanOrEqualTo: fromDate)
            .where('createdAt', isLessThanOrEqualTo: toDate)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documentSnapshots = snapshot.data!.docs;


          if (documentSnapshots.isEmpty) {
            return Center(
              child: Text(
                'No invoices available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: documentSnapshots.length,
            itemBuilder: (context, index) {
              final documentSnapshot = documentSnapshots[index];
              DateTime date = documentSnapshot['createdAt'].toDate();
              String type=documentSnapshot['gstType'].toString();
              return
                InkWell(
                  onTap: () {
    if(type=="Biz"){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvoiceScreen(invoiceNumber: documentSnapshot['invoiceno'].toString(),advisoraddress:Controller.bizaddress,
              useraddress:documentSnapshot['userAddress'].toString(),date:documentSnapshot['createdAt'].toDate(), excludedGstamt: documentSnapshot['excludedGstamt'],
              cgst:documentSnapshot['cgst'].toString(),sgst:documentSnapshot['sgst'].toString(),igst:documentSnapshot['igst'].toString(),
              includedGstamt:documentSnapshot['includedGstamt']
          ),

        ),
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvoiceScreen(invoiceNumber: documentSnapshot['invoiceno'].toString(),advisoraddress:documentSnapshot['advisorAddress'],
              useraddress:documentSnapshot['userAddress'].toString(),date:documentSnapshot['createdAt'].toDate(), excludedGstamt: documentSnapshot['excludedGstamt'],
              cgst:documentSnapshot['cgst'].toString(),sgst:documentSnapshot['sgst'].toString(),igst:documentSnapshot['igst'].toString(),
              includedGstamt:documentSnapshot['includedGstamt']
          ),

        ),
      );
    }

                  },
                  child:
                Card(

                elevation: 8.0,

                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  color: type=='Biz' ? Colors.blue[50] : Colors.white,

                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

                    title: Text(documentSnapshot['invoiceno'].toString(),
                      style: TextStyle(fontSize: 20.0),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(documentSnapshot['advisorName']),
                        Text(documentSnapshot['advisorAddress']),
                        Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),

                      ],
                    ),
                    trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text((documentSnapshot['includedGstamt']).toStringAsFixed(2)),
                        ]),
                  ),),),);
            },
          );
        },
      ),),
],),
    );

  }


}


