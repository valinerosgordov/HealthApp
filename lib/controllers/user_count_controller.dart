import 'package:get/get.dart';

import '../domain/repositories/user_count_repository.dart';


class UserCountController extends GetxController{
  final UserCountRepository _countRepository = UserCountRepository();
  RxnInt userCount = RxnInt();
  initCountStream(){
    _countRepository.userCountStreamById().listen((event) {
      userCount.value = event;
    });
  }

  getCount()async{
    userCount.value = await _countRepository.getCount();
  }
}