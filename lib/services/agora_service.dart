import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  static const String appId =
      "6c9a478092dc44668b300b1fd9140983"; // Get from agora.io

  static Future<RtcEngine> initializeAgora() async {
    // Create RtcEngine instance
    RtcEngine rtcEngine = createAgoraRtcEngine();

    await rtcEngine.initialize(RtcEngineContext(appId: appId));

    // Enable video
    await rtcEngine.enableVideo();

    // Set channel profile
    await rtcEngine.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );
    await rtcEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    return rtcEngine;
  }
}
