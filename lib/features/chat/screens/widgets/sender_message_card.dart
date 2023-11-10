import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/features/chat/screens/widgets/display_text_image_gif.dart';

import '../../../../common/enums/message_enum.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.repliedMessageType,
    required this.repliedText,
    required this.username,
    required this.onRightSwipe,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  @override
  Widget build(BuildContext context) {
    final isReplying  = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text ? const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ) :const EdgeInsets.only(left: 5,top: 5,right: 5,bottom: 25),
                  child: Column(
                    children: [
                      if(isReplying) ...[
                        Text(username,style: TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 3,),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.4),
                            borderRadius:const  BorderRadius.all(Radius.circular(5),),
                          ),
                          child: DisplayTextImageGif(type: repliedMessageType, message: repliedText ,),
                        ),
                        const SizedBox(height: 8,),
                      ],
                      DisplayTextImageGif(type: type, message: message,),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}