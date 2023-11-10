import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/util/utils.dart';
import 'dart:io';

import 'package:whatsapp/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectImage()async{
    image = await pickImageFromGallery(context);
    setState(() {

    });
  }

  void storeUserData()async{
    String name = nameController.text.trim();
    if(name.isNotEmpty){
      ref.read(authControllerProvider).saveDataToFirebase(context, name, image);
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    image==null ? CircleAvatar(
                      backgroundImage: NetworkImage('http://www.goodmorningimagesdownload.com/wp-content/uploads/2021/12/Best-Quality-Profile-Images-Pic-Download-2023.jpg'),
                    radius: 74,
                    ):CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 74,
                    ),
                    Positioned(
                        bottom: -10,left: 90,
                        child: IconButton(onPressed: selectImage, icon:Icon(Icons.add_a_photo),iconSize: 40,)),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: size.width*0.85,
                      padding: const EdgeInsets.all(30),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Name",
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: storeUserData,
                        icon: Icon(Icons.done),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}
