import 'package:get/get.dart';

class BarController extends GetxController{
  RxInt index = RxInt(0);
  final RxnInt messageCount = RxnInt();
  //final MessageController _messageController = MessageController();

  messageStream(){
   /*
    _messageController.getNewMessageStream().listen((event) {
      print('BAR EVENT ${event.length}');
      messageCount.value = event.length;
    });
    */
  }

  @override
  void onReady() {
  //  messageStream();
    super.onReady();
  }
}