import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/screens/widgets/bottom_chat_field.dart';
import 'package:whatsapp/info.dart';
import 'package:whatsapp/features/chat/screens/widgets/chat_list.dart';

import '../../../models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-sccreen';
  final String name;
  final String uid;
  const MobileChatScreen({super.key,required this.uid,required this.name});


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.watch(authControllerProvider).userDataById(uid),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Loader();
            }
            return Column(
              children: [
                Text(name),
                Text(snapshot.data!.isOnline ? 'online':'offline',
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),
                ),
              ],
            );
          }
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
           Expanded(
            child: ChatList(recieverUserId: uid,),
          ),
          BottomChatField(
            recieverUserId: uid,
          ),
        ],
      ),
    );
  }
}


