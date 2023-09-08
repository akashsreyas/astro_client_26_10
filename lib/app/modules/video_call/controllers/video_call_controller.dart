import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/routes/app_pages.dart';
import 'package:hallo_doctor_client/app/service/videocall_service.dart';
import 'package:hallo_doctor_client/app/utils/environment.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:wakelock/wakelock.dart';


class VideoCallController extends GetxController {
  TimeSlot timeSlot = Get.arguments[0]['timeSlot'];
  String token = Get.arguments[0]['token'];
  String room = Get.arguments[0]['room'];
  bool videoCallEstablished = false;
  VideoCallService videoCallService = Get.find();
  bool localUserJoined = false;
  bool localAudioMute = true;
  bool cameraEnabled = false;
  int? remoteUid;
  // Instantiate the client
  late RtcEngine engine;
  RxBool isMinimized = false.obs;
  Object? get userInfo => null;
  late final MethodChannel _channel; // Replace with your channel name
  final floating = Floating();
  bool isPipMode = false;


  @override
  void onInit() {
    super.onInit();

    initAgora();

  }

  @override
  void onReady() async {
    super.onReady();
    update();
  }

  @override
  void onClose() async {
    await destroyAgora();
  }

  completedConsultation() async {


    if (videoCallEstablished) {



      // Get.offNamed(Routes.CONSULTATION_CONFIRM, arguments: timeSlot);
      Get.close(1);
      Get.toNamed(Routes.CONSULTATION_CONFIRM, arguments: [
        {
          'timeSlot': timeSlot,
          'room': room,
          'token': token

        }
      ]);



      // Get.offNamedUntil(
      //     '/consultation-confirm', ModalRoute.withName('/appointment-detail'),
      //     arguments: timeSlot);
    } else {
      printError(info: 'video call not establish yet');
      Get.back();
    }
  }

  Future<void> initAgora() async {
    Wakelock.enable();
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    engine = await RtcEngine.create(Environment.agoraAppId);

    await engine.enableVideo();
    engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) async {
          print("local user $uid joined");
          localUserJoined = true;
          videoCallEstablished = true;
          engine.muteLocalAudioStream(localAudioMute);
          update();

        },

        userJoined: (int uid, int elapsed) async {
          print("remote user $uid joined");

          remoteUid = uid;
          update();
        },
        userOffline: (int uid, UserOfflineReason reason) async {
          print("remote user $uid left channel");
          remoteUid = null;

          print(userInfo);
          completedConsultation();
          update();
        },
      ),
    );

    await engine.joinChannel(token, room, null, 0);
  }

  Future endMeeting() async {
    await destroyAgora();
    Get.back();
  }

  Future destroyAgora() async {
    await VideoCallService().removeRoom(room);
    await engine.leaveChannel();
    await engine.destroy();

  }

  Future switchCamera() async {
    try {
       await engine.switchCamera();

    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future toggleLotcalAudioMuted() async {
    try {
      localAudioMute = !localAudioMute;
      await engine.muteLocalAudioStream(localAudioMute);
      update();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.inactive) {
      floating.enable(aspectRatio: Rational.square());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this as WidgetsBindingObserver);
    floating.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.onInit();
    WidgetsBinding.instance!.addObserver(this as WidgetsBindingObserver);
  }
  Future<void> enablePip(BuildContext context) async {
    final rational = Rational.vertical();
    final screenSize = MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final status = await floating.enable(
      aspectRatio: rational,
      // sourceRectHint: Rectangle<int>(
      //   0,
      //   (screenSize.height ~/ 2) - (height ~/ 2),
      //   screenSize.width.toInt(),
      //   height,
      // ),
    );
    debugPrint('PiP enabled? $status');
  }

  Future<void> toggleCamera() async {
     try {
       cameraEnabled = !cameraEnabled;
      await engine.muteLocalVideoStream(cameraEnabled);
       update(); }
       catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    }
  }
}
