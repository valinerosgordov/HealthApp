import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controllers/city_controller.dart';
import 'package:health_app/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../core/my_colors.dart';
import '../../domain/data/city_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:im_animations/im_animations.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>{
  double h = 0;
  double w = 0;
  double ops =0;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        h = Get.height;
        w = Get.width;
        ops = 1;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: Get.width,
        alignment: Alignment.center,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
            Expanded(child: AnimatedContainer(
              curve: Curves.easeOutExpo,
              duration: Duration(seconds: 2),
            height: h,
            width: w,
              foregroundDecoration: BoxDecoration(shape: w<Get.width*0.99?BoxShape.circle:BoxShape.rectangle,
                color: MyColors.green_016938.withOpacity(ops),),
              decoration: BoxDecoration(color: MyColors.green_36B448,
                shape: BoxShape.circle,),)),

              AnimatedContainer(
                  curve: Curves.elasticOut,
                height: h/1.5,
                width: w/1.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                  shape: BoxShape.circle,
                  
                ),
                padding: EdgeInsets.all(60),
                
                //duration: Duration(seconds: 2),
                  duration: Duration(seconds: 1),
                  child:Fade(child:
            Hero(tag: 'logo', child: SvgPicture.asset('images/app_logo.svg',
            ))))
          ],),

        ],),)
    );
  }
}
