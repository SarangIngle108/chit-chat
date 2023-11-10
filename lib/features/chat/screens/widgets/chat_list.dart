import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/providers/message_reply_provider.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/info.dart';
import 'package:whatsapp/features/chat/screens/widgets/my_message_card.dart';
import 'package:whatsapp/features/chat/screens/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList({super.key,required this.recieverUserId});

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {

  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
      String message,
      bool isMe,
      MessageEnum messageEnum,
      ){
    ref.read(messageReplyProvider.notifier).update((state) => MessageReply(messageEnum, message, isMe),);
  }


  @override
  Widget build(BuildContext context,) {
    return StreamBuilder(
      stream: ref.watch(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Loader();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timesent = DateFormat.Hm().format(messageData.timeSent);
            if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timesent,
                type: messageData.type,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onLeftSwipe: ()=>onMessageSwipe(messageData.text, true, messageData.type),
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date:timesent,
              type: messageData.type,
              onRightSwipe: ()=>onMessageSwipe(messageData.text,false,messageData.type),
              repliedMessageType: messageData.repliedMessageType,
              username: messageData.repliedTo,
              repliedText: messageData.repliedMessage,
            );

          },
        );
      }
    );
  }
}