import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
class AnalyticController extends GetxController{

  setUser({required String userId})async{
    await FirebaseAnalytics.instance.setUserId(id: userId);
  }
}