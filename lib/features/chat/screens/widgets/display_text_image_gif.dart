import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp/features/chat/screens/widgets/video_player_item.dart';
import '../../../../common/enums/message_enum.dart';


class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGif({super.key,required this.type,required this.message});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text ?
        Text(message,style: TextStyle(fontSize: 16),
        ):type == MessageEnum.video ? VideoPlayerItem(videoUrl: message,)
          :type == MessageEnum.audio ? StatefulBuilder(

            builder: (context,setState) {
              return IconButton(
                onPressed: ()async{
                  if(isPlaying){
                    await audioPlayer.pause();
                    setState((){
                      isPlaying = true;
                    }) ;
                  }else{
                    await audioPlayer.play(UrlSource(message),);
                    setState((){
                      isPlaying = true;
                    });
                  }
                },
                icon: Icon(isPlaying?Icons.pause_circle:Icons.play_circle,),constraints:BoxConstraints(minWidth: 100) ,);
            }
          )
        : CachedNetworkImage(imageUrl: message,);
  }
}
