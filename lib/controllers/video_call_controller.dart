// import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import '../utils/app_constants.dart';

// class VideoCallController extends GetxController {
//   final String channelName;
//   VideoCallController({required this.channelName});

//   late RtcEngine engine;
//   var remoteUid = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     initAgora();
//   }

//   Future<void> initAgora() async {
//     engine = createAgoraRtcEngine();
//     await engine.initialize(
//       RtcEngineContext(
//         appId: '6c9a478092dc44668b300b1fd9140983',
//         channelProfile: ChannelProfileType.channelProfileCommunication,
//       ),
//     );

//     engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onUserJoined: (connection, uid, elapsed) {
//           remoteUid.value = uid;
//         },
//         onUserOffline: (connection, uid, reason) {
//           remoteUid.value = 0;
//         },
//       ),
//     );

//     await engine.enableWebSdkInteroperability(true);
//     await engine.enableVideo();
//     await engine.startPreview();

//     await engine.joinChannel(
//       token: "", // For quick dev, token can be null
//       channelId: channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }

//   void leaveChannel() async {
//     await engine.leaveChannel();
//     await engine.release();
//     Get.back();
//   }
// }

///////////////////////////////////////
// import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';

// class VideoCallController extends GetxController {
//   late RtcEngine agoraEngine;
//   final String channelName;
//   final bool isDoctor;

//   // Observables
//   var localUserJoined = false.obs;
//   var remoteUsers = <int>[].obs;
//   var isMuted = false.obs;
//   var isVideoEnabled = true.obs;
//   var callEnded = false.obs;
//   var localUid = 0.obs;
//   var isInitialized = false.obs;

//   VideoCallController({required this.channelName, required this.isDoctor});

//   @override
//   void onInit() {
//     super.onInit();
//     initializeAgora();
//   }

//   @override
//   void onClose() {
//     _dispose();
//     super.onClose();
//   }

//   Future<void> initializeAgora() async {
//     try {
//       // Create RtcEngine instance
//       agoraEngine = createAgoraRtcEngine();

//       await agoraEngine.initialize(
//         RtcEngineContext(appId: "6c9a478092dc44668b300b1fd9140983"),
//       );

//       // Enable video
//       await agoraEngine.enableVideo();

//       // Set channel profile to COMMUNICATION (not Live Broadcasting)
//       await agoraEngine.setChannelProfile(
//         ChannelProfileType.channelProfileCommunication,
//       );

//       // Set event handlers
//       _setAgoraEventHandlers();

//       // Join channel - Use empty string for token if not using token authentication
//       await agoraEngine.joinChannel(
//         token:
//             "007eJxTYDh5WuKEetPNzcf0DAWKqibNy07euXe6rTnbh5/XHDWeRMcoMJglWyaamFsYWBqlJJuYmJlZJBkbGCQZpqVYGpoYWFoY/6pjz2wIZGQIsT/FxMgAgSC+GINHamJOSYaCT2ZetkJATmmxQkh+dmoeAwMAxTAlSQ==", // Use empty string instead of null
//         channelId: channelName,
//         uid: 0, // Let Agora assign uid
//         options: const ChannelMediaOptions(),
//       );

//       isInitialized.value = true;
//     } catch (e) {
//       print("Agora initialization error: $e");
//       Get.snackbar('Error', 'Failed to initialize video call: $e');
//     }
//   }

//   void _setAgoraEventHandlers() {
//     agoraEngine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           localUid.value = connection.localUid!;
//           localUserJoined.value = true;
//           print(
//             "✅ Local user joined: ${connection.localUid}, channel: $channelName",
//           );
//           update();
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           remoteUsers.add(remoteUid);
//           print("✅ Remote user joined: $remoteUid");
//           update();
//         },
//         onUserOffline:
//             (
//               RtcConnection connection,
//               int remoteUid,
//               UserOfflineReasonType reason,
//             ) {
//               remoteUsers.remove(remoteUid);
//               print("❌ Remote user left: $remoteUid");
//               update();
//             },
//         onError: (ErrorCodeType errorCode, String msg) {
//           print("❌ Agora Error: $errorCode - $msg");
//         },
//         onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//           print("📞 Left channel");
//           localUserJoined.value = false;
//           remoteUsers.clear();
//           update();
//         },
//         onConnectionStateChanged:
//             (
//               RtcConnection connection,
//               ConnectionStateType state,
//               ConnectionChangedReasonType reason,
//             ) {
//               print("🔗 Connection state: $state, reason: $reason");
//             },
//       ),
//     );
//   }

//   // Toggle microphone
//   void toggleMute() {
//     isMuted.value = !isMuted.value;
//     agoraEngine.muteLocalAudioStream(isMuted.value);
//     update();
//   }

//   // Toggle video
//   void toggleVideo() {
//     isVideoEnabled.value = !isVideoEnabled.value;
//     agoraEngine.muteLocalVideoStream(!isVideoEnabled.value);
//     update();
//   }

//   // Switch camera
//   void switchCamera() {
//     agoraEngine.switchCamera();
//   }

//   // End call
//   Future<void> endCall() async {
//     if (!callEnded.value) {
//       callEnded.value = true;
//       try {
//         await agoraEngine.leaveChannel();
//         await agoraEngine.release();
//       } catch (e) {
//         print("Error ending call: $e");
//       }
//       Get.back();
//     }
//   }

//   // Dispose resources
//   void _dispose() {
//     if (!callEnded.value) {
//       endCall();
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:js' as js;
import 'dart:async';

class VideoCallController extends GetxController {
  var isJoining = false.obs;
  var hasJoined = false.obs;
  var meetingError = ''.obs;
  Timer? _joinTimeoutTimer;
  Timer? _successTimer;

  @override
  void onClose() {
    _joinTimeoutTimer?.cancel();
    _successTimer?.cancel();
    _leaveMeeting();
    super.onClose();
  }

  Future<void> joinMeeting({
    required String meetingId,
    required String role,
    required String userName,
    required String userEmail,
  }) async {
    try {
      isJoining.value = true;
      meetingError.value = '';
      hasJoined.value = false;
      _joinTimeoutTimer?.cancel();
      _successTimer?.cancel();

      print("🔄 Requesting signature for meeting: $meetingId");

      // 1️⃣ Request signature from backend
      final response = await http.post(
        Uri.parse(AppUrls.generateSignature),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'meetingNumber': meetingId, 'role': int.parse(role)}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get signature: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final signature = data['signature'];

      print("✅ Signature received, setting up callbacks...");

      // 2️⃣ Set up JavaScript callbacks
      _setupJavaScriptCallbacks();

      // 3️⃣ Add small delay to ensure callbacks are registered
      await Future.delayed(Duration(milliseconds: 300));

      // 4️⃣ Start Zoom meeting via JavaScript
      print("🎬 Calling startZoomMeeting JavaScript function...");

      js.context.callMethod('startZoomMeeting', [
        meetingId,
        userName,
        userEmail,
        '', // password
        signature,
        'F36DyDP7SP6feLHnF3RsCA', // your SDK key
      ]);

      // 5️⃣ Set optimistic success timer (meeting usually joins within 5-10 seconds)
      _setOptimisticSuccessTimer();

      // 6️⃣ Set timeout for failure
      _setJoinTimeout();
    } catch (e) {
      debugPrint("❌ Error joining meeting: $e");
      _handleMeetingError(e.toString());
    }
  }

  void _setupJavaScriptCallbacks() {
    // Callback when meeting is successfully joined
    js.context['onZoomMeetingJoined'] = () {
      print("✅ Flutter: Zoom meeting joined callback received");
      _joinTimeoutTimer?.cancel();
      _successTimer?.cancel();
      isJoining.value = false;
      hasJoined.value = true;

      Get.snackbar(
        "Success",
        "Meeting joined successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    };

    // Callback when meeting ends
    js.context['onZoomMeetingEnded'] = () {
      print("📞 Flutter: Zoom meeting ended callback received");
      _joinTimeoutTimer?.cancel();
      _successTimer?.cancel();
      hasJoined.value = false;
      isJoining.value = false;
    };

    // Callback for meeting errors
    js.context['onZoomMeetingError'] = (String error) {
      print("❌ Flutter: Zoom meeting error: $error");
      _joinTimeoutTimer?.cancel();
      _successTimer?.cancel();
      _handleMeetingError(error);
    };
  }

  void _setOptimisticSuccessTimer() {
    // Assume success after 8 seconds if no error (most meetings join by then)
    _successTimer = Timer(Duration(seconds: 8), () {
      if (isJoining.value == true && hasJoined.value == false) {
        print("🎯 Optimistic success - marking as joined");
        isJoining.value = false;
        hasJoined.value = true;

        Get.snackbar(
          "Connected",
          "Meeting joined successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    });
  }

  void _setJoinTimeout() {
    _joinTimeoutTimer = Timer(Duration(seconds: 30), () {
      if (isJoining.value == true && hasJoined.value == false) {
        print("⏰ Meeting join timeout");
        _handleMeetingError(
          "Meeting join timeout. Please check your connection and try again.",
        );
      }
    });
  }

  void _handleMeetingError(String error) {
    isJoining.value = false;
    hasJoined.value = false;
    meetingError.value = error;

    Get.snackbar(
      "Meeting Error",
      error,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
    );
  }

  void _leaveMeeting() {
    try {
      // Call JavaScript to leave meeting
      js.context.callMethod('leaveZoomMeeting', []);
      hasJoined.value = false;
      isJoining.value = false;
      _joinTimeoutTimer?.cancel();
      _successTimer?.cancel();
    } catch (e) {
      print("Error leaving meeting: $e");
    }
  }

  void leaveMeeting() {
    _leaveMeeting();
    Get.back();
  }

  // Manual trigger for joined state
  void triggerManualJoin() {
    try {
      js.context.callMethod('manualMeetingJoined', []);
    } catch (e) {
      print("Error calling manual join: $e");
    }
  }
}
