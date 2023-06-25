import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/ui/screens/auth/auth_screen.dart';
import 'package:health_app/ui/widgets/bottom_bar_widget.dart';

import '../../controllers/auth_controller.dart';
import 'splash_screen.dart';

class LoaderScreen extends StatelessWidget{


  final AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    _authController.logOut();
    return Obx((){
      if(_authController.userIsAuth.value != null){
        if(_authController.userIsAuth.value!){
          return BottomBarWidget();
        }else{
          return AuthScreen();
        }
      }
      return SplashScreen();
    });
  }


  Widget buildLoader(){
    return Container(child: SizedBox(
      height: Get.width*0.1,
      width: Get.width*0.1,
      child: CircularProgressIndicator(),
    ),);
  }

}