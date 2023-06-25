import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/core/my_constants.dart';

import '../../../controllers/partners_controller.dart';
import '../../../core/my_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PartnersCategory extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PartnersCategoryState();

}

class PartnersCategoryState extends State<PartnersCategory>{
  final PartnersController _partnersController = Get.find();
  double _width = 70;
  double _height = 105;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: GestureDetector(


        onVerticalDragUpdate: (details){
          print('details ${details.delta}');

          int sensitivity = 1;
          if (!details.delta.dy.isNegative) {
            setState(() {
              if(_height>105) {
                _height = 105;
              }
            });
          } else if(details.delta.dy < -sensitivity){
            setState(() {
              if(_height<490) {
                _height = _height+100;
              }
            });
          }


        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              //curve: Curves.bounceOut,
                curve: Curves.easeOutCubic,

                width: Get.width,
                height: _height,

                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04,
                    vertical: Get.width * 0.0),


                decoration: BoxDecoration(
                    color: MyColors.grey_E7EEE7,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(16),
                        topLeft: Radius.circular(16)),
                    boxShadow: [BoxShadow(color: Colors.grey.shade300,
                        spreadRadius: 1, blurRadius: 5,  offset: Offset(0.0, -5))]
                ),
                duration: Duration(milliseconds: 500),
                child:  Column(children: [
                  SizedBox(height: Get.width * 0.05,),

                  Container(height: 5, width: Get.width/3,
                    decoration: BoxDecoration(color: MyColors.green_016938,
                        borderRadius: BorderRadius.circular(20)),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Get.width*0.04,
                            vertical: Get.width*0.02),
                        child: Text('Категории', style: TextStyle(fontSize: 16,
                            color: Colors.white),),
                        decoration: BoxDecoration(
                          color: MyColors.green_016938,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.only(bottom: Get.width*0.05, top: Get.width*0.05),
                      ),
                      SizedBox(height: Get.width * 0.05,),


                    ],),
                  Expanded(
                    flex: 1,
                    child:   buildCategories(),)


                ],))],)));
  }

  Widget buildCategories(){
    return Container(
      width: Get.width,
      height: Get.height/2.3,
      child: GridView(
      // controller: _listController,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: Get.width*0.025),
      shrinkWrap: true,
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      children: List.generate(14, (index)  {
        return GestureDetector(onTap: (){
          setState(() {
            _height = 105;
          });
         if(!_partnersController.selectCategories.contains(MyConstants.categoriesListTxt[index])){
           _partnersController.selectCategories.clear();
           _partnersController.selectCategories.add(MyConstants.categoriesListTxt[index]);
         }else{
           _partnersController.selectCategories.remove(MyConstants.categoriesListTxt[index]);
         }
         _partnersController.searchPartners(query: '');
        },
        child:  SizedBox(width: Get.width/3,child:
        Stack(
          alignment: Alignment.center,
          children: [
            //SizedBox(height: Get.width*0.7,),
            Container(
              alignment: Alignment.center,
          height: Get.width*0.3,
          decoration: BoxDecoration(shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.shade300,
                  spreadRadius: 1, blurRadius: 5)]),
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.025),
          margin: EdgeInsets.symmetric(horizontal: Get.width*0.025),
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(width: Get.width,
            alignment: Alignment.center,
            child: Text(MyConstants.categoriesListTxt[index], textAlign:TextAlign.center,
            style: TextStyle(fontSize: 13),),),
              SizedBox(height: Get.width*0.05,)
          ],),),
          Positioned(
              //top: 0,
              child: Container(
                decoration: BoxDecoration(
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 90),
            width: Get.width*0.25,
            height: Get.width*0.25,
            child: SvgPicture.asset('images/${MyConstants.categoriesListImg[index]}',
             ),)),
            //_partnersController
            //select_cat.svg
            Positioned(
              right: 5,
                child: Obx(()=>Visibility(
                  visible: _partnersController.selectCategories.contains(MyConstants.categoriesListTxt[index]),
                  child: Container(
                  margin: EdgeInsets.only(top: 105),
                  width: Get.width*0.08,
                  height: Get.width*0.08,
                  child:
                  SvgPicture.asset('images/select_cat.svg',
                  ),),)))
          ],),));
      }).toList(),),);
  }

}