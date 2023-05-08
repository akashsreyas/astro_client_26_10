import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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


  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _selectedValue,_selectedValueState;
  bool _showIndianStateSelection = false;
  late String state,statecode="Code",gstno,address;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);
    return Scaffold(
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
                        SizedBox(height: height * .2),
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
                                              _selectedValue = doc['name'];
                                              if(_selectedValue != 'India'){
                                                _showIndianStateSelection = true;
                                              }else{
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
                                  child: Text(_selectedValue ?? 'Select Country')),
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
                                    stream: _db.collection('State').snapshots(),
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
                                    child: Text(_selectedValueState ?? 'Select State')),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),),
                        SizedBox(height: 20),
                        Visibility(
                          visible: _showIndianStateSelection,
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
                        TextField(
                          controller: _textgstno,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'GST No'.tr),
                          maxLines: 1,
                          textInputAction: TextInputAction.done,



                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _textaddress,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Billing Address'.tr),
                          maxLines: 5,
                          textInputAction: TextInputAction.done,



                        ),

                        SizedBox(height: 20),
                        submitButton(
                            onTap: ()  async {

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
                              gstno=_textgstno.text;
                              address=_textaddress.text;
                              controller.addDataWithId(_selectedValue!,state!,statecode!,gstno,address);

                              if(token=="1"){
                                controller.billing();
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
        ),);
  }
}
