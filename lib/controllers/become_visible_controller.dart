import 'package:get/get.dart';
import 'package:health_app/domain/repositories/become_repository.dart';


class BecomeVisibleController extends GetxController{
  final BecomeRepository _countRepository = BecomeRepository();
  RxnInt userCount = RxnInt();
  initCountStream(){
    _countRepository.userCountStreamById().listen((event) {
      userCount.value = event;
    });
  }
}