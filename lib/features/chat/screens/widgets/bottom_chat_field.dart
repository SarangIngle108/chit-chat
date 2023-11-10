import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/providers/message_reply_provider.dart';
import 'package:whatsapp/common/util/utils.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/features/chat/screens/widgets/message_reply_preview.dart';
import 'dart:io';
import '../../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const BottomChatField({super.key,required this.recieverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }
  void openAudio()async{
      final status = await Permission.microphone.request();
      if(status != PermissionStatus.granted){
        throw(RecordingPermissionException('Permission Not Allowed'),);
      }
      await _soundRecorder!.openRecorder();
      isRecorderInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void sendTextMessage()async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider)
          .sendTextMessages(
          context, _messageController.text.trim(), widget.recieverUserId);

    setState(() {
      _messageController.text = '';
    });
  }else{
      var tempDir  = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if(!isRecorderInit){
        return;
      }
      if(isRecording){
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      }else{
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(File file,MessageEnum messageenum){
  ref.read(chatControllerProvider).sendFileMessages(context, file, widget.recieverUserId, messageenum);
  }

  void selectImage()async{
    File? image = await pickImageFromGallery(context);
    if(image!=null){
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo()async{
    File? video = await pickVideoFromGallery(context);
    if(video!=null){
      sendFileMessage(video, MessageEnum.image);
    }
  }

  void hideEmojiContainer(){
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer(){
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyBoard()=>focusNode.requestFocus();
  void hideKeyBoard()=>focusNode.unfocus();


void toggleEmojiKeyboardContainer(){
    if(isShowEmojiContainer){
      showKeyBoard();
      hideEmojiContainer();
    }else{
      hideKeyBoard();
      showEmojiContainer();
    }
}


  @override
  Widget build(BuildContext context) {
  final messageReply = ref.watch(messageReplyProvider);
  final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview(): const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val){
                  if(val.isNotEmpty){
                    setState(() {
                      isShowSendButton = true;
                    });
                  }else{
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },

                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            icon:const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:  [
                        IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                          onPressed: selectImage,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                          onPressed: selectVideo,
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
             Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 2, left: 2),
              child: CircleAvatar(
                backgroundColor: Color(0xFF128C7E),
                radius: 22,
                child: GestureDetector(
                  child: Icon(
                    isShowSendButton ?
                    Icons.send : isRecording? Icons.close: Icons.mic,
                    color: Colors.white,
                  ),
                  onTap: sendTextMessage,
                ),
              ),
            ),

          ],
        ),
        isShowEmojiContainer ? SizedBox(height: 250,
          child: EmojiPicker(
            onEmojiSelected: ((category,emoji){
              setState(() {
                _messageController.text = _messageController.text+emoji.emoji;
              });
              if(!isShowSendButton){
                setState(() {
                  isShowSendButton = true;
                });
              }
            }),
          ),
        ):const SizedBox(),
      ],
    );
  }
}
