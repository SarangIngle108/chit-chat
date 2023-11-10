import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/repository/auth_repository.dart';
import 'dart:io';

import '../../../models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return   AuthController(authRepository: authRepository,ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController{
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
});

  Future<UserModel?> getUserData()async{
      UserModel? user = await authRepository.getCurrentUserData();
      return user;
  }

  void signInWithPhone(BuildContext context,String phoneNumber){
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context,String verificationId,String userOTP){
    authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);
  }
  void saveDataToFirebase(BuildContext context,String name,File? profilepic){
    authRepository.saveUserDataToFirebase(name: name, profilepic: profilepic, ref: ref, context: context);
  }

  Stream<UserModel> userDataById(String UserId){
    return authRepository.userData(UserId);
  }
  
  void setUserState(bool isonline){
    authRepository.setUserState(isonline);
  }





}