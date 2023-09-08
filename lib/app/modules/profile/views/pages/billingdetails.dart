import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/profile/controllers/profile_controller.dart';
import 'package:hallo_doctor_client/app/modules/widgets/submit_button.dart';

class Billing_Details extends GetView<ProfileController> {
  final _formKey = GlobalKey<FormBuilderState>();
  String token = Get.arguments;

  Billing_Details({Key? key}) : super(key: key);
  TextEditingController _textController = TextEditingController();
  TextEditingController _textgstno = TextEditingController();
  TextEditingController _textaddress = TextEditingController();
  TextEditingController _textmobile = TextEditingController();


  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _selectedValue, _selectedValueState;
  bool _showIndianStateSelection = false;
  late String state="", statecode = "Code", gstno, address="",mobile="";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Billing Details'),
        // Add any other app bar customization properties you need
      ),
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: Container(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: controller.formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(
                        height: 50,
                      ),

                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.blue,
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Color(0xFFF5F6F9),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return StreamBuilder<QuerySnapshot>(
                                stream: _db.collection('Country').snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.docs.isNotEmpty) {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var doc = snapshot.data!.docs[index];
                                        return ListTile(
                                          title: Text(doc['name']),
                                          onTap: () {
                                            //  Navigator.pop(context, doc['name']);
                                            _selectedValue = doc['name'];
                                            if (_selectedValue != 'India') {
                                              _showIndianStateSelection = true;
                                            } else {
                                              _showIndianStateSelection = false;
                                            }
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              );
                            },
                          ).then((_selectedValue) {
                            print(_selectedValue);
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Expanded(
                                child:
                                    Text(_selectedValue ?? 'Select Country')),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: _selectedValue == 'India',
                        child:
                        Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),),
                      Visibility(
                        visible: _selectedValue == 'India',
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.blue,
                            padding: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Color(0xFFF5F6F9),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return StreamBuilder<QuerySnapshot>(
                                  stream: _db
                                      .collection('State')
                                      .orderBy('name')
                                      .snapshots(), // Order the query by 'name' field
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.docs.isNotEmpty) {
                                      // Get the sorted list of documents
                                      List<DocumentSnapshot> sortedDocs =
                                          snapshot.data!.docs.toList();
                                      sortedDocs.sort((a, b) => a['name']
                                          .compareTo(b[
                                              'name'])); // Sort the documents alphabetically by 'name'

                                      return ListView.builder(
                                        itemCount: sortedDocs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var doc = sortedDocs[index];
                                          return ListTile(
                                            title: Text(doc['name']),
                                            onTap: () {
                                              _selectedValueState = doc['name'];
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                );
                              },
                            ).then((_selectedValueState) {
                              print(_selectedValueState);
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              Expanded(
                                  child: Text(
                                      _selectedValueState ?? 'Select State')),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Visibility(
                        visible: _showIndianStateSelection,
                        child:
                        Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),),
                      Visibility(
                        visible: _showIndianStateSelection,
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter State'.tr),
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      SizedBox(height: 20),

                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Do You have Gst Number:',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            RadioListTile(
                              title: Text('Yes'),
                              value: 0,
                              groupValue: controller.selectedRadio.value,
                              onChanged: (int? value) {
                                controller.handleRadioValueChange(value);
                              },
                            ),
                            RadioListTile(
                              title: Text('No'),
                              value: 1,
                              groupValue: controller.selectedRadio.value,
                              onChanged: (int? value) {
                                controller.handleRadioValueChange(value);
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Obx(
                        () => Visibility(
                          visible: controller.selectedRadio.value == 0,
                          child: TextField(
                            controller: _textgstno,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'GST No'.tr,
                            ),
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _textaddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Billing Address'.tr),
                        maxLines: null, // Allow an unlimited number of lines
                        keyboardType: TextInputType.multiline, // Set the keyboard type to multiline
                        textInputAction: TextInputAction.newline,
                        validator: FormBuilderValidators.required(
                          errorText: 'Billing Address is required',
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _textmobile,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Mobile Number'.tr),
                        maxLines: null, // Allow an unlimited number of lines
                        keyboardType: TextInputType.number, // Set the keyboard type to multiline
                          validator: FormBuilderValidators.required(
                          errorText: 'Mobile number is required',
                        ),
                      ),
                      SizedBox(height: 20),
                      submitButton(
                          onTap: () async {

                            if (_selectedValue == "India") {
                              state = _selectedValueState!;
                              var languageSettingVersionRef =
                                  await FirebaseFirestore.instance
                                      .collection('State')
                                      .where('name', isEqualTo: state)
                                      .get();
                              for (var snapshot
                                  in languageSettingVersionRef.docs) {
                                if (snapshot.exists) {
                                  Map<String, dynamic> data = snapshot.data();
                                  statecode = data['code'];
                                } else {
                                  statecode = "CODE";
                                }
                              }
                            } else {
                              state = _textController.text;
                            }

                            gstno = _textgstno.text;
                            address = _textaddress.text;
                            mobile = _textmobile.text;

                            String mobileValidationResult = validatePhoneNumber(mobile);
                            if (mobileValidationResult == "Invalid number") {
                              Fluttertoast.showToast(msg: mobileValidationResult);
                              return;
                            }



                            if(_selectedValue == 'Select Country' || state == "" ){

                              Fluttertoast.showToast(msg: 'Country or State is empty'.tr);
                              return;
                            }else if(address.isEmpty){
                              Fluttertoast.showToast(msg: 'Billing address is empty'.tr);
                              return;
                            }

                            if(controller.selectedRadio == 1){
                              gstno ="";
                            }else{
                              if(gstno == ""){
                                Fluttertoast.showToast(msg: 'Gst number is empty'.tr);
                                return;
                              }

                            }

                            controller.addDataWithId(_selectedValue!, state,
                                statecode, gstno, address,mobile);

                            if (token == "1") {
                              controller.billing();
                            } else {
                              controller.profile();
                            }
                          },
                          text: 'Save'.tr),
                      SizedBox(height: height * .01),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: BackButton()),
          ],
        ),
      ),
    );
  }

  String validatePhoneNumber(String input) {
    input = input.replaceAll(RegExp(r'[\s\-]'), '');
    RegExp indianMobileRegex = RegExp(r'^(91|\+91)?[6789]\d{9}$');

    RegExp internationalRegex = RegExp(r'^\+\d{1,4}\d{6,14}$');
    if (indianMobileRegex.hasMatch(input))
    {    return "Valid Indian mobile number";  }
       else if (internationalRegex.hasMatch(input)) {
         return "Valid international number";  }
    else {
      return "Invalid number";  }}




}
