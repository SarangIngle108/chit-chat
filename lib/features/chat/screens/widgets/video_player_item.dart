import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
   final String videoUrl;
  const  VideoPlayerItem({super.key,required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool isplay = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16/9,
      child: Stack(
        children: [
          VideoPlayer(videoPlayerController),
          Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed:(){
                  if(isplay){
                    videoPlayerController.pause();
                  }else{
                    videoPlayerController.play();
                  }
                  setState(() {
                    isplay = !isplay;
                  });
                },
                  icon: Icon(
                      isplay? Icons.pause:
                      Icons.play_arrow),),),
          
        ],
      ),
    );
  }
}
