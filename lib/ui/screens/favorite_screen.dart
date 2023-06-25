import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/favorite_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:health_app/ui/screens/partners/partner_item.dart';
import 'package:health_app/ui/screens/partners/partner_screen.dart';

class FavoriteScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FavoriteScreenState();

}

class FavoriteScreenState extends State<FavoriteScreen> with SingleTickerProviderStateMixin{
  late AnimationController animation;
  final FavoriteController _favoriteController = FavoriteController();

  @override
  void initState() {
    _favoriteController.listenFavoriteStream();
    _favoriteController.getFavoriteList();
    animation = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: MyColors.grey_E7EEE7,
          body: SingleChildScrollView(child:
          Column(children: [
            SizedBox(height: 60,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(children: [
                  GestureDetector(onTap: (){
                    Get.back();
                  },
                    child: Icon(Icons.arrow_back_ios_outlined),),
                ],),
                Text('Избранное', style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,
                color: MyColors.green_016938),),
              ],),),

            buildFavoriteList()

          ],),),
        );
  }

  Widget buildHeader(){
    return Column(children: [

    ],);
  }

  Widget buildFavoriteList(){
    return Container(width: Get.width,
    child: Obx(()=>_favoriteController.favoriteList.value !=null?ListView(shrinkWrap: true,
    children: _favoriteController.favoriteList.value!.map((data) {
     return PartnerItem(data: data);
    }).toList(),):Column(children: [CircularProgressIndicator()],),));
  }

  /*
  Route _colorRotationRoute({Offset? offset}) {
    final nextColor = MyColors.green_016938;
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => FavoriteScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          CircularRevealAnimation(
            animation: animation,
            centerOffset: offset,
            child: child,
          ),
    );
  }
   */

}

class CircleClipper extends CustomClipper<Path>{
  late final double fraction;
  late final Offset? centerOffset;
  CircleClipper({required this.fraction, required this.centerOffset});

  static double maxRadius(Size size, Offset center) {
    final width = max(center.dx, size.width - center.dx);
    final height = max(center.dy, size.height - center.dy);
    return sqrt(pow(width, 2) + pow(height, 2));
  }

  @override
  Path getClip(Size size) {
    final center = centerOffset ?? Offset(size.width / 2, size.height / 2);

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: lerpDouble(0, maxRadius(size, center), fraction)!,
        ),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

  
}

