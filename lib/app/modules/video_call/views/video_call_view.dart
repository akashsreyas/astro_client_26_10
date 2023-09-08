// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:get/get.dart';
// import '../controllers/video_call_controller.dart';
//
//
// class VideoCallView extends GetView<VideoCallController> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     return
//     Scaffold(
//       body: SafeArea(
//         child: GetBuilder<VideoCallController>(
//           builder: (_) {
//             return Stack(
//               children: [
//                 Center(
//                   child: _remoteVideo(),
//                 ),
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: Container(
//                     width: 100,
//                     height: 150,
//                     child: Center(
//                       child: controller.localUserJoined
//                           ? RtcLocalView.SurfaceView()
//                           : CircularProgressIndicator(),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   child: Container(
//                     width: Get.width,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         FloatingActionButton(
//                           onPressed: controller.toggleLotcalAudioMuted,
//                           child: controller.localAudioMute == false
//                               ? Icon(Icons.mic)
//                               : Icon(Icons.mic_off),
//                           heroTag: 'micOff',
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         // FloatingActionButton(
//                         //   onPressed: controller.toggleLotcalAudioMuted,
//                         //   child: controller.localAudioMute == false
//                         //       ? Icon(Icons.video_call)
//                         //       : Icon(Icons.videocam_off),
//                         //   heroTag: 'videoOff',
//                         // ),
//                         // SizedBox(
//                         //   width: 20,
//                         // ),
//                         FloatingActionButton(
//                           onPressed: controller.switchCamera,
//                           child: Icon(Icons.switch_camera),
//                           heroTag: 'cameraSwitch',
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         FloatingActionButton(
//                           onPressed: () {
//                             controller.completedConsultation();
//                           },
//                           child: Icon(Icons.call_end),
//                           backgroundColor: Colors.red,
//                           heroTag: 'endMeeting',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//
//   Widget _remoteVideo() {
//     if (controller.remoteUid != null) {
//       return RtcRemoteView.SurfaceView(
//         uid: controller.remoteUid!,
//         channelId: controller.room,
//       );
//     } else {
//       return Text(
//         'Please wait for remote user to join'.tr,
//         textAlign: TextAlign.center,
//       );
//     }
//   }
//
//
// }
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:get/get.dart';

import '../controllers/video_call_controller.dart';


class VideoCallView extends GetView<VideoCallController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.enablePip(context); // Enable PiP when back button is pressed
        // Toggle button visibility
        return false; // Allow the back action to continue // Allow the back action to continue
      },
      child:Scaffold(
        body: SafeArea(
          child: GetBuilder<VideoCallController>(
            builder: (_) {
              return Stack(
                children: [
                  Center(
                    child: _remoteVideo(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 100,
                      height: 150,
                      child: Center(
                        child: controller.localUserJoined
                            ? RtcLocalView.SurfaceView()
                            : CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: controller.isPipMode ? 0 : 20,
                    child: Container(
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          FloatingActionButton(
                            onPressed: controller.toggleLotcalAudioMuted,
                            child: controller.localAudioMute == false
                                ? Icon(Icons.mic)
                                : Icon(Icons.mic_off),
                            heroTag: 'micOff',
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FloatingActionButton(
                            onPressed: controller.switchCamera,
                            child: Icon(Icons.switch_camera),
                            heroTag: 'cameraSwitch',
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              controller.toggleCamera();
                            },
                            child: controller.cameraEnabled!=true ?  Icon(Icons.videocam ) : Icon(Icons.videocam_off ),
                            heroTag: 'cameraBlock',

                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              controller.completedConsultation();
                            },
                            child: Icon(Icons.call_end),
                            backgroundColor: Colors.red,
                            heroTag: 'endMeeting',
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

        ),
        // floatingActionButton: FutureBuilder<bool>(
        //   future: controller.floating.isPipAvailable,
        //   initialData: false,
        //   builder: (context, snapshot) {
        //     final isPipAvailable = snapshot.data ?? false;
        //     return isPipAvailable
        //         ? FloatingActionButton(
        //       onPressed: () {
        //         controller.enablePip(context);
        //       },
        //       child: Icon(Icons.picture_in_picture),
        //       tooltip: 'Enable PiP',
        //     )
        //         : Container(); // PiP not available, don't show button
        //   },
        // ),

      ),
    );
  }

  Widget _remoteVideo() {
    if (controller.remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: controller.remoteUid!,
        channelId: controller.room,
      );
    } else {
      return Text(
        'Please wait for remote user to join'.tr,
        textAlign: TextAlign.center,
      );
    }
  }
}



