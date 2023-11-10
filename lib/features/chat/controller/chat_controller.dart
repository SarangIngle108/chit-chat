import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/providers/message_reply_provider.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/repositories/chat_repository.dart';
import 'dart:io';
import '../../../models/chat_contact.dart';
import '../../../models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController{
  final ChatRepository chatRepository;
  final ProviderRef ref;

 ChatController({
    required this.chatRepository,
   required this.ref,
});

 Stream<List<ChatContact>> chatContacts(){
   return chatRepository.getChatContacts();
 }
Stream<List<Message>> chatStream(String recieverUserId){
   return chatRepository.getChatStream(recieverUserId);
}


 void sendTextMessages(BuildContext context,String text,String recieverUserId){
   final messageReply = ref.read(messageReplyProvider);
   ref.read(userDataAuthProvider).whenData(
           (value) =>
               chatRepository.sendTextMessage(
                   context: context,
                   text: text,
                   recieverUserId: recieverUserId,
                   senderUser: value!,
                 messageReply:messageReply,
                 isGroupChat: false,
               ),
   );
   ref.read(messageReplyProvider.notifier).update((state) => null);
 }

  void sendFileMessages(BuildContext context,File file,String recieverUserId,MessageEnum messageenum){
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) =>
          chatRepository.sendFileMessage(
              context: context,
              file: file,
              recieverUserId: recieverUserId,
              senderUserData: value!,
              ref: ref,
              messageEnum: messageenum,
            isGroupChat: false,
            messageReply: messageReply,
          ),
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }



}
