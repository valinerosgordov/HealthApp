import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/domain/data/ad_data.dart';
import 'package:health_app/ui/widgets/videoItem.dart';

import '../../core/my_colors.dart';

class AdItem extends StatefulWidget{
  final AdData data;
  AdItem({required this.data});
  @override
  State<StatefulWidget> createState() => AdItemState();

}

class AdItemState extends State<AdItem>{
  bool Function() get _isVideo =>(){
   return widget.data.photo.contains('ad_video');
  };
 bool isVideo = false;

  @override
  void initState() {
    isVideo = _isVideo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      buildItem()
    ],);
  }


  Widget buildItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(onTap: (){
                setState(() {
                  isVideo = false;
                });
              },
                child: Text("Фото",
                  style: TextStyle(color: isVideo? Colors.black:Colors.blue),),),

              SizedBox(width: Get.width*0.01,),

              GestureDetector(onTap: (){
                setState(() {
                  isVideo = true;
                });
              },
                child:  Text("Видео", style: TextStyle(color: !isVideo? Colors.black:Colors.blue),),)],),),
        GestureDetector(
            onTap: () {
              //setUserPhoto();
            },
            child: Container(
                padding: EdgeInsets.all(Get.width * 0.005),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  //border: Border.all(color: MyColors.green_4CAD79, width: 2)
                ),
                child: Stack(children: [ Container(
                    width: Get.width * 0.14,
                    height: Get.width * 0.07,
                    //padding: EdgeInsets.all(2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: isVideo?VideoItem(data: widget.data.photo):Image.network(widget.data.photo)),

                  Container(
                    margin: EdgeInsets.only( left: Get.width * 0.12,
                      bottom: Get.width * 0.12,),

                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: MyColors.green_016938,
                      shape: BoxShape.circle,
                    ),
                    child: Row(children: [
                      Text(widget.data.sale, style: TextStyle(color: Colors.white),),
                      Text('%', style: TextStyle(color: Colors.white),),

                    ],),)],))),

        SizedBox(
          height: Get.width * 0.03,
        ),
      ],
    );
  }

}