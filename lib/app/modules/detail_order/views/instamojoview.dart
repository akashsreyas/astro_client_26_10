
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/environment.dart';
import '../controllers/detail_order_controller.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:http/http.dart' as http;



class instamojoview extends StatefulWidget {


  final String instamojourl;
  final num amount;



  instamojoview({required this.instamojourl, required this.amount,});

  @override
  _instamojoviewState createState() => _instamojoviewState();
}

class _instamojoviewState extends State<instamojoview> {


  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  late WebViewController _webViewController;

  bool paymentSuccess = false;
  bool paymentFailed = false;
    final String successMessage = 'Payment Successful!';

  final String failMessage = 'Payment Failed!';
  bool isLoading = false;
  late String content ,paymentid="";
  late num  amt=0;

  late MethodChannel _methodChannel;
  String packageName = 'com.google.android.apps.nbu.paisa.user';

  @override
  void initState() {
    super.initState();
   // loadInstamojoUrl();
    _methodChannel = MethodChannel('com.example.app/upiNavigation');
  }

  // Future<void> loadInstamojoUrl() async {
  //   Environment environment = Environment();
  //   try {
  //     instamojourl = await environment.instamojoid();
  //   } catch (error) {
  //     print(error);
  //   }
  //   setState(() {});
  // }



  @override
  Widget build(BuildContext context) {

    if (widget.instamojourl.isEmpty) {
      // Display a loading indicator or handle the case where instamojourl is not yet available
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    Uri uri = Uri.parse(widget.instamojourl);


    //Uri uri = Uri.parse('https://test.instamojo.com/@bizbooztprime');


    // uri = uri.replace(
    //   queryParameters: {
    //     'purpose': widget.purpose,
    //     'amount': widget.amount.toString()
    //   },
    // );


    return WillPopScope(
      onWillPop: () => _handleBackNavigation(),
      child: Scaffold(

      body: Stack(
        children: [
          Opacity(
            opacity: isLoading ? 0.0 : 1.0,
            child:
            WebView(
              initialUrl: uri.toString(),
              javascriptMode: JavascriptMode.unrestricted,



              onWebViewCreated: (WebViewController controller) {
                EasyLoading.dismiss();
                _controller.complete(controller);
                _webViewController = controller;
                _modifyAmountSection();


              },
              navigationDelegate: (NavigationRequest request) {


                if (request.url.startsWith('intent://')) {
                  _launchIntentURL(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onPageFinished: (String url) {
                //
                // if (url != null && url.startsWith('intent://')) {
                //   _launchIntentURL(url);
                // }

                EasyLoading.dismiss();
                _modifyAmountSection();


                _webViewController.evaluateJavascript(
                    "document.documentElement.innerText").then((value) {
                  if (value.contains(successMessage)) {
                    setState(() {
                      paymentSuccess = true;
                    });

                    content=value;

                    String paymentIDStartMarker = r"Payment ID\t\n";
                    String paymentIDEndMarker = r"\n";
                    int startIndex = content.indexOf(paymentIDStartMarker);
                    if (startIndex != -1) {

                      int endIndex = content.indexOf(

                          paymentIDEndMarker, startIndex + paymentIDStartMarker.length);
                      if (endIndex != -1) {

                        paymentid = content.substring(
                            startIndex + paymentIDStartMarker.length, endIndex).trim();

                      }
                    }

                    String amountIDStartMarker = r"Amount\t\n";
                    String amountIDEndMarker = r"\n";
                    int startIndex1 = content.indexOf(amountIDStartMarker);
                    if (startIndex1 != -1) {

                      int endIndex = content.indexOf(

                          amountIDEndMarker, startIndex1 + amountIDStartMarker.length);
                      if (endIndex != -1) {

                        String  amount = content.substring(
                            startIndex1 + amountIDStartMarker.length, endIndex).trim();
                        amount = amount.replaceAll(RegExp(r'[^\d.]'), ''); // Removes non-numeric characters
                         amt = num.parse(amount);

                      }
                    }
                    if (widget.amount.isEqual(amt) ) {
                      _handlePaymentSuccess(value, paymentid);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Failed'),
                            content: Text('Payment failed, please contact admin.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Get.find<DetailOrderController>().goHome();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }


                  }else if (value.contains(failMessage)){
                    print('ji');
                    setState(() {
                      paymentFailed = true;
                    });
                    Get.find<DetailOrderController>().Instamojofail();

                  }
                  else {
                    setState(() {

                      paymentSuccess = false;

                    });

                  }
                });



              },

              onWebResourceError: (WebResourceError error) {


              },
            ),
          ),
          Opacity(
            opacity: isLoading ? 1.0 : 0.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          if (paymentSuccess)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: Text('Go to Home'),
                onPressed: () {
                  Get.find<DetailOrderController>().goHome();
                },
              ),
            ),

          if (paymentFailed)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: Text('Go to Home'),
                onPressed: () {
                  Get.find<DetailOrderController>().goHome();
                },
              ),
            ),
        ],
      ),
    ),
    );
  }


  // Add the launchUPIApp function
  void _launchIntentURL(String url) async {
    String modifiedUrl = url.replaceAll('intent://', 'upi://');
    if (await canLaunch(modifiedUrl)) {
      await launch(modifiedUrl);
    } else {
      throw 'Could not launch Google Pay link.';
    }
  }


  void _modifyAmountSection() async {
    final WebViewController controller = await _controller.future;
    final String jsCode = '''
    var elements = document.querySelectorAll("input[type='number'], textarea, select");
    for(var i = 0; i < elements.length; i++) {
      elements[i].setAttribute("readonly", "true");
      elements[i].style.pointerEvents = "none";
      elements[i].style.backgroundColor = "transparent";
      elements[i].style.border = "none";
      
      
    }
    
    var textNodes = document.evaluate("//text()", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
    for (var i = 0; i < textNodes.snapshotLength; i++) {
      var node = textNodes.snapshotItem(i);
      node.nodeValue = node.nodeValue.replace("Change", "");
    }
  ''';
 
 
 






    await controller.evaluateJavascript(jsCode);
  }


  Future<String?> _handlePaymentSuccess(String content,String paymentid) async {

    // Get.find<DetailOrderController>().Instamojosuccess(paymentid);
    // // Get.find<DetailOrderController>().goHome();
    print('WebView Content: $content');




    }

  Future<bool> _handleBackNavigation() async {
    if (await _webViewController.canGoBack()) {
      // If the WebView can go back, navigate back
      _webViewController.goBack();
      return false; // Return false to prevent the app from closing
    } else {
      // If the WebView cannot go back, show a confirmation dialog
      final confirmation = await _showExitConfirmationDialog();
      return confirmation ?? false; // Return false if confirmation is null (user cancels)
    }
  }
  Future<bool?> _showExitConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to exit the payment gateway?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog and allow the app to close
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog and prevent the app from closing
              },
            ),
          ],
        );
      },
    );
  }



}
