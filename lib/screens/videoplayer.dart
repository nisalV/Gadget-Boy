import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/services.dart';

class VideoPlay extends StatefulWidget {
  final String videoLink;
  final String videoName;
  const VideoPlay(this.videoLink,this.videoName,{Key? key}) : super(key: key);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {

  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
  const CustomVideoPlayerSettings(controlBarAvailable: true,showDurationPlayed: false,
      showDurationRemaining: false,systemUIModeAfterFullscreen: SystemUiMode.leanBack,
      systemUIModeInsideFullscreen: SystemUiMode.edgeToEdge,);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoLink)
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _customVideoPlayerController.dispose();

      SystemChrome.setPreferredOrientations([]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.videoLink);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.redAccent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(widget.videoName,overflow: TextOverflow.visible, style: const TextStyle(color: Colors.redAccent),
          maxLines: 1,),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              child:
                CustomVideoPlayer(
                  customVideoPlayerController: CustomVideoPlayerController(
                    context: context,
                    videoPlayerController: _videoPlayerController,
                    customVideoPlayerSettings: _customVideoPlayerSettings,
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
