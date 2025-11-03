// import 'dart:html' as html;
// import 'dart:ui_web' as ui;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class VideoCallPage extends StatefulWidget {
//   final String channelName;
//   const VideoCallPage({super.key, required this.channelName});

//   @override
//   State<VideoCallPage> createState() => _VideoCallPageState();
// }

// class _VideoCallPageState extends State<VideoCallPage> {
//   @override
//   void initState() {
//     super.initState();

//     // listen for message from iframe
//     html.window.onMessage.listen((event) {
//       if (event.data == "exitCall") {
//         Get.back(); // close video call page
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String htmlUrl = "video_call.html?channel=${widget.channelName}";

//     final html.IFrameElement iframe = html.IFrameElement()
//       ..src = htmlUrl
//       ..style.border = "none"
//       ..width = "100%"
//       ..height = "100%";

//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(
//       'video-call-frame-${widget.channelName}',
//       (int viewId) => iframe,
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Video Consultation"),
//         backgroundColor: Colors.blue,
//       ),
//       body: HtmlElementView(viewType: 'video-call-frame-${widget.channelName}'),
//     );
//   }
// }

// ////////////////////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:health_link_plus/controllers/video_call_controller.dart';

// class VideoCallPage extends StatelessWidget {
//   final String channelName;
//   final bool isDoctor;

//   VideoCallPage({Key? key, required this.channelName, required this.isDoctor})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<VideoCallController>(
//       init: VideoCallController(channelName: channelName, isDoctor: isDoctor),
//       builder: (controller) {
//         return Scaffold(
//           backgroundColor: Colors.black,
//           body: SafeArea(
//             child: Stack(
//               children: [
//                 // Video Views
//                 _buildVideoViews(controller),

//                 // Controls
//                 _buildControlButtons(controller),

//                 // Header
//                 _buildHeader(controller),

//                 // Debug info
//                 _buildDebugInfo(controller),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildVideoViews(VideoCallController controller) {
//     return Column(
//       children: [
//         Expanded(
//           child: Stack(
//             children: [
//               // Remote user video
//               _buildRemoteVideo(controller),

//               // Local user video (picture-in-picture)
//               if (controller.localUserJoined.value)
//                 _buildLocalVideo(controller),

//               // Waiting message
//               if (controller.remoteUsers.isEmpty &&
//                   controller.localUserJoined.value)
//                 _buildWaitingForParticipant(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRemoteVideo(VideoCallController controller) {
//     if (controller.remoteUsers.isNotEmpty) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: controller.agoraEngine,
//           canvas: VideoCanvas(uid: controller.remoteUsers.first),
//           connection: RtcConnection(channelId: controller.channelName),
//         ),
//       );
//     } else {
//       return Container(
//         color: Colors.grey[900],
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.person_off, color: Colors.white54, size: 80),
//               SizedBox(height: 20),
//               Text(
//                 'No remote participant',
//                 style: TextStyle(color: Colors.white54, fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   Widget _buildLocalVideo(VideoCallController controller) {
//     return Positioned(
//       bottom: 20,
//       right: 20,
//       child: Container(
//         width: 120,
//         height: 180,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.white, width: 2),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: AgoraVideoView(
//             controller: VideoViewController(
//               rtcEngine: controller.agoraEngine,
//               canvas: VideoCanvas(uid: controller.localUid.value),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWaitingForParticipant() {
//     return Positioned(
//       top: 100,
//       left: 0,
//       right: 0,
//       child: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             CircularProgressIndicator(color: Colors.white),
//             SizedBox(height: 20),
//             Text(
//               'Waiting for participant to join...',
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Room: $channelName',
//               style: TextStyle(color: Colors.grey, fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildControlButtons(VideoCallController controller) {
//     return Positioned(
//       bottom: 40,
//       left: 0,
//       right: 0,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // Mute/Unmute
//           _buildControlButton(
//             icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
//             color: controller.isMuted.value ? Colors.red : Colors.white,
//             onPressed: controller.toggleMute,
//           ),

//           // End Call
//           _buildControlButton(
//             icon: Icons.call_end,
//             color: Colors.red,
//             onPressed: controller.endCall,
//             isLarge: true,
//           ),

//           // Video Toggle
//           _buildControlButton(
//             icon: controller.isVideoEnabled.value
//                 ? Icons.videocam
//                 : Icons.videocam_off,
//             color: controller.isVideoEnabled.value ? Colors.white : Colors.red,
//             onPressed: controller.toggleVideo,
//           ),

//           // Switch Camera
//           _buildControlButton(
//             icon: Icons.cameraswitch,
//             color: Colors.white,
//             onPressed: controller.switchCamera,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//     bool isLarge = false,
//   }) {
//     return CircleAvatar(
//       backgroundColor: Colors.black54,
//       radius: isLarge ? 28 : 24,
//       child: IconButton(
//         icon: Icon(icon, color: color, size: isLarge ? 26 : 22),
//         onPressed: onPressed,
//         padding: EdgeInsets.zero,
//       ),
//     );
//   }

//   Widget _buildHeader(VideoCallController controller) {
//     return Positioned(
//       top: 20,
//       left: 20,
//       right: 20,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Channel Info
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.black54,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.videocam, color: Colors.green, size: 16),
//                 SizedBox(width: 8),
//                 Text(
//                   'Room: ${controller.channelName}',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),

//           // Participant Count
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.black54,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.people, color: Colors.blue, size: 16),
//                 SizedBox(width: 8),
//                 Obx(
//                   () => Text(
//                     '${controller.remoteUsers.length + (controller.localUserJoined.value ? 1 : 0)}',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDebugInfo(VideoCallController controller) {
//     return Positioned(
//       bottom: 120,
//       left: 20,
//       child: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.black54,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Obx(
//           () => Text(
//             'Local: ${controller.localUserJoined.value ? "Joined" : "Joining"}\n'
//             'Remote: ${controller.remoteUsers.length}',
//             style: TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/video_call_controller.dart';
import '../utils/app_colors.dart';

class VideoCallPage extends StatelessWidget {
  final String meetingId;
  final String role;
  final String userName;
  final String userEmail;

  const VideoCallPage({
    super.key,
    required this.meetingId,
    required this.role,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoCallController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Video Call', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            controller.leaveMeeting();
          },
        ),
        actions: [
          // Manual controls for debugging
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'mark_joined') {
                controller.triggerManualJoin();
              } else if (value == 'mark_failed') {
                controller.leaveMeeting();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'mark_joined',
                child: Text('Mark as Joined (Debug)'),
              ),
              PopupMenuItem(
                value: 'mark_failed',
                child: Text('Mark as Failed (Debug)'),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isJoining.value) {
          return _buildJoiningState(controller);
        }

        if (controller.hasJoined.value) {
          return _buildMeetingJoinedState(controller);
        }

        return _buildInitialState(controller);
      }),
    );
  }

  Widget _buildJoiningState(VideoCallController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
        ),
        SizedBox(height: 20),
        Text(
          "Joining Zoom Meeting...",
          style: TextStyle(fontSize: 16, color: AppColors.blue),
        ),
        SizedBox(height: 10),
        Text(
          "Meeting ID: $meetingId",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 5),
        Text(
          "Please allow microphone and camera permissions",
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            controller.leaveMeeting();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("Cancel Join"),
        ),
        SizedBox(height: 10),
        Text(
          "If stuck, check browser permissions or try the debug menu",
          style: TextStyle(fontSize: 10, color: Colors.orange),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMeetingJoinedState(VideoCallController controller) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    "Zoom Meeting is Active",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Meeting ID: $meetingId",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "You should see the Zoom meeting interface below",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              controller.leaveMeeting();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.call_end, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Leave Meeting",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialState(VideoCallController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_call, size: 80, color: AppColors.blue),
          SizedBox(height: 20),
          Text(
            "Ready to Join Video Call",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Meeting ID: $meetingId",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              await controller.joinMeeting(
                meetingId: meetingId,
                role: role,
                userName: userName,
                userEmail: userEmail,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              "Join Zoom Meeting",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 20),
          if (controller.meetingError.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 40),
                  SizedBox(height: 10),
                  Text(
                    controller.meetingError.value,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
