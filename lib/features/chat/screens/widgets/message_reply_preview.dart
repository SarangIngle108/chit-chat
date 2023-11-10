import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/providers/message_reply_provider.dart';

import 'display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref){
    ref.read(messageReplyProvider.notifier).update((state) => null);

  }


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
        ),
      ),
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
          children: [
            Expanded(
                child: Text(messageReply!.isMe? 'Me' : 'Opposite',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ),
            GestureDetector(
              child: const Icon(
                Icons.close,
                size: 16,
              ),
              onTap: ()=>cancelReply(ref),
            ),
          ],
          ),
          const SizedBox(height: 8,),
          DisplayTextImageGif(
            message: messageReply.message, type: messageReply.messageEnum,
          ),
        ],

      ),
    );
  }
}
