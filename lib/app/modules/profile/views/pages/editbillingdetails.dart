// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:get/get.dart';
// import 'package:hallo_doctor_client/app/modules/profile/controllers/profile_controller.dart';
// import 'package:hallo_doctor_client/app/modules/widgets/submit_button.dart';
//
//
//
// class Editbilling_Details extends GetView<ProfileController> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   // String token = Get.arguments;
//   String country = Get.arguments[0]['country'];
//   String usstate = Get.arguments[0]['state'];
//   String usaddress = Get.arguments[0]['address'];
//   String gst = Get.arguments[0]['gst'];
//
//
//   Editbilling_Details({Key? key}) : super(key: key);
//   TextEditingController _textController = TextEditingController();
//   TextEditingController _textgstno = TextEditingController();
//   final TextEditingController _textaddress = TextEditingController();
//
//
//
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   String? _selectedValue,_selectedValueState;
//   bool _showIndianStateSelection = false;
//   late String state,statecode="Code",gstno,address;
//
//   bool _showStateDropdown = false;
//   bool _showTextField = false;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     _textaddress.text=usaddress;
//     _textgstno.text=gst;
//
//
//
//
//     final height = MediaQuery.of(context).size.height;
//     final node = FocusScope.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Billing Details'),
//         // Add any other app bar customization properties you need
//       ),
//       body: Container(
//         height: height,
//         child: Stack(
//           children: <Widget>[
//             Positioned(
//               top: -MediaQuery.of(context).size.height * .15,
//               right: -MediaQuery.of(context).size.width * .4,
//               child: Container(),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: SingleChildScrollView(
//                 child: Form(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   key: controller.formkey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//
//                       SizedBox(
//                         height: 30,
//                       ),
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           primary: Colors.blue,
//                           padding: EdgeInsets.all(20),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15)),
//                           backgroundColor: Color(0xFFF5F6F9),
//                         ),
//                         onPressed: () {
//
//                           showModalBottomSheet(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return StreamBuilder<QuerySnapshot>(
//                                 stream: _db.collection('Country').snapshots(),
//                                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                   if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
//                                     return ListView.builder(
//                                       itemCount: snapshot.data!.docs.length,
//                                       itemBuilder: (BuildContext context, int index) {
//                                         var doc = snapshot.data!.docs[index];
//                                         return ListTile(
//                                           title: Text(doc['name']),
//                                           onTap: () {
//                                             //  Navigator.pop(context, doc['name']);
//                                             _selectedValue = doc['name'];
//
//
//                                             print(_selectedValue);
//                                             if (_selectedValue == 'India') {
//                                               _showStateDropdown = true;
//                                               _showTextField = false;
//                                             } else {
//                                               _showStateDropdown = false;
//                                               _showTextField = true;
//                                             }
//                                             Navigator.pop(context);
//                                           },
//                                         );
//
//                                       },
//                                     );
//                                   } else if (snapshot.hasError) {
//                                     return Text('Error: ${snapshot.error}');
//                                   } else {
//                                     return CircularProgressIndicator();
//                                   }
//                                 },
//                               );
//                             },
//                           ).then((_selectedValue) {
//
//
//                           });
//                         },
//                         child: Row(
//                           children: [
//                             SizedBox(width: 20),
//                             Expanded(
//                               child: Text(
//                                 _selectedValue != null
//                                     ? _selectedValue!
//                                     : (country != null ? country!: 'Select Country'),
//                               ),),
//                             Icon(Icons.arrow_forward_ios),
//                           ],
//                         ),
//
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Visibility(
//                         visible: _showStateDropdown || country == 'India',
//                         child:
//                         TextButton(
//                           style: TextButton.styleFrom(
//                             primary: Colors.blue,
//                             padding: EdgeInsets.all(20),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15)),
//                             backgroundColor: Color(0xFFF5F6F9),
//
//                           ),
//                           onPressed: () {
//                             showModalBottomSheet(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return StreamBuilder<QuerySnapshot>(
//                                   stream: _db.collection('State').orderBy('name').snapshots(), // Order the query by 'name' field
//                                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                     if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
//                                       // Get the sorted list of documents
//                                       List<DocumentSnapshot> sortedDocs = snapshot.data!.docs.toList();
//                                       sortedDocs.sort((a, b) => a['name'].compareTo(b['name'])); // Sort the documents alphabetically by 'name'
//
//                                       return ListView.builder(
//                                         itemCount: sortedDocs.length,
//                                         itemBuilder: (BuildContext context, int index) {
//                                           var doc = sortedDocs[index];
//                                           return ListTile(
//                                             title: Text(doc['name']),
//                                             onTap: () {
//                                               _selectedValueState = doc['name'];
//                                               Navigator.pop(context);
//                                             },
//                                           );
//                                         },
//                                       );
//                                     } else if (snapshot.hasError) {
//                                       return Text('Error: ${snapshot.error}');
//                                     } else {
//                                       return CircularProgressIndicator();
//                                     }
//                                   },
//                                 );
//                               },
//                             ).then((_selectedValueState) {
//                               _selectedValueState ??= usstate;
//                               print(_selectedValueState);
//                             });
//                           },
//
//                           child: Row(
//                             children: [
//                               SizedBox(width: 20),
//                               Expanded(
//                                   child: Text(_selectedValueState ?? usstate)),
//                               Icon(Icons.arrow_forward_ios),
//                             ],
//                           ),
//                         ),),
//                       SizedBox(height: 20),
//                       Visibility(
//                         visible: _showTextField || country != 'India',
//                         child:
//                         TextField(
//                           controller: _textController,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintText: 'Enter State'.tr),
//                           maxLines: 1,
//                           textInputAction: TextInputAction.done,
//
//                         ),),
//                       SizedBox(height: 20),
//
//                       Obx(
//                             () => Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Do You have Gst Number:',
//                               style: TextStyle(fontSize: 16.0),
//                             ),
//                             RadioListTile(
//                               title: Text('Yes'),
//                               value: 0,
//                               groupValue: controller.selectedRadio.value,
//                               onChanged: (int? value) {
//                                 controller.handleRadioValueChange(value);
//                               },
//                             ),
//                             RadioListTile(
//                               title: Text('No'),
//                               value: 1,
//                               groupValue: controller.selectedRadio.value,
//                               onChanged: (int? value) {
//                                 controller.handleRadioValueChange(value);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       SizedBox(height: 20),
//
//                       Obx(
//                             () => Visibility(
//                           visible: controller.selectedRadio.value == 0,
//                           child: TextField(
//                             controller: _textgstno,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintText: 'GST No'.tr,
//                             ),
//                             maxLines: 1,
//                             textInputAction: TextInputAction.done,
//                           ),
//                         ),
//                       ),
//
//
//                       // SizedBox(height: 20),
//                       // Visibility(
//                       //   visible: selectedRadio.value==0,
//                       //   child:
//                       //   TextField(
//                       //
//                       //     controller: _textgstno,
//                       //     decoration: InputDecoration(
//                       //         border: OutlineInputBorder(),
//                       //         hintText: 'GST No'.tr),
//                       //     maxLines: 1,
//                       //     textInputAction: TextInputAction.done,
//                       //   ),),
//
//
//
//
//                       SizedBox(height: 20),
//                       TextField(
//                         controller: _textaddress,
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             hintText: 'Billing Address'.tr),
//                         maxLines: 5,
//                         textInputAction: TextInputAction.done,
//
//
//
//                       ),
//
//
//                       SizedBox(height: 20),
//                       submitButton(
//                           onTap: ()  async {
//
//                         _selectedValue ??= country;
//                         _selectedValueState ??= usstate;
//
//
//                             if(_selectedValue=="India"){
//                               state=_selectedValueState!;
//                               var languageSettingVersionRef = await FirebaseFirestore.instance
//                                   .collection('State').where('name', isEqualTo: state)
//                                   .get();
//                               for (var snapshot in languageSettingVersionRef.docs) {
//                                 if(snapshot.exists){
//                                   Map<String, dynamic> data = snapshot.data();
//                                   statecode = data['code'];
//                                 }else{
//
//                                   statecode = "CODE";
//                                 }
//
//                               }
//                             }else{
//                               state=_textController.text;
//                             }
//                             gstno=_textgstno.text;
//                             address=_textaddress.text;
//
//
//                             if(country == ""|| usstate == ""){
//                               Fluttertoast.showToast(msg: 'empty'.tr);
//                               return;
//                             }
//
//                             else if(address.isEmpty || usaddress.isEmpty){
//                               Fluttertoast.showToast(msg: 'Billing address is empty'.tr);
//                               return;
//                             }
//
//                             controller.addDataWithId(_selectedValue!,state,statecode,gstno,address);
//                             controller.profile();
//
//
//                           },
//                           text: 'Save'.tr),
//
//
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//           ],
//         ),
//       ),);
//   }
//
//   void updateVisibility(String selectedCountry) {
//     if (selectedCountry == 'India') {
//       _showStateDropdown = true;
//       _showTextField = false;
//     } else {
//       _showStateDropdown = false;
//       _showTextField = true;
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/modules/profile/controllers/profile_controller.dart';
import 'package:hallo_doctor_client/app/modules/widgets/submit_button.dart';


class Editbilling_Details extends StatefulWidget {

  @override
  _Editbilling_DetailsState createState() => _Editbilling_DetailsState();
}

class _Editbilling_DetailsState extends State<Editbilling_Details> {
  final ProfileController controller = Get.put(ProfileController());
  final _formKey = GlobalKey<FormBuilderState>();
  // String token = Get.arguments;
  String country = Get.arguments[0]['country'];
  String usstate = Get.arguments[0]['state'];
  String usaddress = Get.arguments[0]['address'];
  String gst = Get.arguments[0]['gst'];
  String phone = Get.arguments[0]['phone'];



  TextEditingController _textController = TextEditingController();
  TextEditingController _textgstno = TextEditingController();
  final TextEditingController _textaddress = TextEditingController();
  TextEditingController _textmobile = TextEditingController();


  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _selectedValue,_selectedValueState;
  bool _showIndianStateSelection = false;
  late String state,statecode="Code",gstno,address,mobile="";

  bool _showStateDropdown = false;
  bool _showTextField = false;

  int selectedRadio = 0;

  @override
  void initState() {
    super.initState();

    // Initialize visibility flags based on the country value
    if (country == 'India') {
      _showStateDropdown = true;
      _showTextField = false;

    } else {
      _showStateDropdown = false;
      _showTextField = true;
      _textController.text=usstate;
    }

    if (gst.isNotEmpty) {
      controller.selectedRadio = 0.obs;
      _textgstno.text=gst;// "Yes" radio button selected
    } else {
      controller.selectedRadio = 1.obs; // "No" radio button selected
      _textgstno.text="";
    }

  }


  @override
  Widget build(BuildContext context) {
    _textaddress.text=usaddress;
    _textmobile.text=phone;




    final height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Billing Details'),
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
                        height: 30,
                      ),
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
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        var doc = snapshot.data!.docs[index];
                                        return ListTile(
                                          title: Text(doc['name']),
                                          onTap: () {
                                            //  Navigator.pop(context, doc['name']);
                                           // _selectedValue = doc['name'];


                                            print(_selectedValue);
                                            setState(() {
                                              _selectedValue = doc['name'];
                                              updateVisibility(_selectedValue!);
                                            });
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


                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                _selectedValue != null
                                    ? _selectedValue!
                                    : (country != null ? country!: 'Select Country'),
                              ),),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),

                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: _showStateDropdown ,
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
                        visible: _showStateDropdown ,
                        child:

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
                                  stream: _db.collection('State').orderBy('name').snapshots(), // Order the query by 'name' field
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                                      // Get the sorted list of documents
                                      List<DocumentSnapshot> sortedDocs = snapshot.data!.docs.toList();
                                      sortedDocs.sort((a, b) => a['name'].compareTo(b['name'])); // Sort the documents alphabetically by 'name'

                                      return ListView.builder(
                                        itemCount: sortedDocs.length,
                                        itemBuilder: (BuildContext context, int index) {
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
                              _selectedValueState ??= usstate;
                              print(_selectedValueState);
                            });
                          },

                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              Expanded(
                                  child: Text(_selectedValueState ?? usstate)),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),),
                      SizedBox(height: 20),
                      Visibility(
                        visible: _showTextField ,
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
                        visible: _showTextField,
                        child:
                        TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter State'.tr),
                          maxLines: 1,
                          textInputAction: TextInputAction.done,

                        ),),
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
                      TextField(
                        controller: _textaddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Billing Address'.tr),
                          maxLines: null, // Allow an unlimited number of lines
                          keyboardType: TextInputType.multiline, // Set the keyboard type to multiline
                          textInputAction: TextInputAction.newline,



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
                          onTap: ()  async {

                            _selectedValue ??= country;
                            _selectedValueState ??= usstate;


                            if(_selectedValue=="India"){
                              state=_selectedValueState!;
                              var languageSettingVersionRef = await FirebaseFirestore.instance
                                  .collection('State').where('name', isEqualTo: state)
                                  .get();
                              for (var snapshot in languageSettingVersionRef.docs) {
                                if(snapshot.exists){
                                  Map<String, dynamic> data = snapshot.data();
                                  statecode = data['code'];
                                }else{

                                  statecode = "CODE";
                                }

                              }
                            }else{
                              state=_textController.text;
                            }

                            address=_textaddress.text;
                            mobile=_textmobile.text;
                            gstno=_textgstno.text;


                            String mobileValidationResult = validatePhoneNumber(mobile);
                            if (mobileValidationResult == "Invalid number") {
                              Fluttertoast.showToast(msg: mobileValidationResult);
                              return;
                            }

                            if(country == ""|| state == ""){
                              Fluttertoast.showToast(msg: 'empty'.tr);
                              return;
                            }

                            else if(address.isEmpty || usaddress.isEmpty){
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


                            controller.addDataWithId(_selectedValue!,state,statecode,gstno,address,mobile);
                            controller.profile();


                          },
                          text: 'Save'.tr),



                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),);
  }
  void updateVisibility(String selectedCountry) {
    if (selectedCountry == 'India') {
      setState(() {
        _showStateDropdown = true;
        _showTextField = false;
        usstate='Select State';
      });
    } else {
      setState(() {
        _showStateDropdown = false;
        _showTextField = true;
        usstate='';
      });
    }
  }
  String validatePhoneNumber(String input) {
    input = input.replaceAll(RegExp(r'[\s\-]'), '');
    if (country == 'India') {
      RegExp indianMobileRegex = RegExp(r'^(91|\+91)?[6789]\d{9}$');

      if (indianMobileRegex.hasMatch(input)) {
        return "Valid Indian mobile number";
      }

      else {
        return "Invalid number";
      }
    } else {
      RegExp internationalRegex = RegExp(r'^\+\d{1,3}\d{5,15}$');
      if (internationalRegex.hasMatch(input)) {
        return "Valid international number";
      }
      else {
        return "Invalid number";
      }
    }
  }






}



