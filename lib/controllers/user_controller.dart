import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:health_app/ui/screens/auth/code_screen.dart';
import '../domain/data/user_data.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/user_repository.dart';
import 'dart:io';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  final Rxn<UserData> user = Rxn<UserData>();
  late Stream<UserData?> userStream;
  RxBool loading = RxBool(false);
  RxString userPhotoPath = RxString('');

  setPartnerLike({required String partnerId}) async {
    if (user.value!.partnersLikes.contains(partnerId)) {
      List<String> newList = <String>[];
      for (String i in user.value!.partnersLikes) {
        if (i != partnerId) {
          newList.add(i);
        }
      }
      await setUserData(userData: user.value!.copyWith(partnersLikes: newList));
    } else {
      List<String> newList = user.value!.partnersLikes;
      newList.add(partnerId);
      await setUserData(userData: user.value!.copyWith(partnersLikes: newList));
    }
  }

  initUser() {
    userStream = _userRepository.getUserStream(
        user_id: FirebaseAuth.instance.currentUser!.uid);
    userStream.listen((event) {
      if (event != null) {
        if (user.value != null) {
          userPhotoPath.value = user.value!.photoUri;

          if (user.value!.phoneNumber != event.phoneNumber) {
            return;
          } else {
            user.value = event;
          }
          ;
        } else {
          user.value = event;
        }
      }
    });
  }

  setDataIfExist({required UserData userData}) async {
    try {
      UserData? user = await _userRepository.getUserByUuidIfExist(
          id: FirebaseAuth.instance.currentUser!.uid);
      if (user == null) {
        await setUserData(userData: userData);
      }
    } catch (e) {
      await setUserData(userData: userData);
    }
  }

  setUserData({required UserData userData}) async {
    loading.value = true;
    print("USER PHOTO PATH ${userPhotoPath.value}");
    if (userPhotoPath.isNotEmpty && !userPhotoPath.value.contains('http')) {
      String newUri =
          await _userRepository.savePhoto(file: File(userPhotoPath.value));
      await _userRepository.setUser(user: userData.copyWith(photoUri: newUri));
    } else {
      await _userRepository.setUser(user: userData);
    }
    loading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<UserData?> getUserById(String uid) async {
    try {
      UserData? _user = await _userRepository.getUserById(id: uid);
      return _user;
    } catch (e) {
      return Future.value();
    }
  }
}
