import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/domain/data/partner_data.dart';
import 'package:get/get.dart';
import 'package:health_app/ui/screens/partners/partner_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../../../core/my_colors.dart';

class PartnerItem extends StatefulWidget{
  final PartnerData data;
  PartnerItem({required this.data});

  @override
  State<StatefulWidget> createState() => PartnerItemState();

}

class PartnerItemState extends State<PartnerItem>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: (){
        Navigator.push(context,
            PageTransition(type: PageTransitionType.bottomToTop,
                curve: Curves.easeOutQuart,
                child: PartnerScreen(data: widget.data,)));
      },
      child: Container(
          child: Stack(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: Get.width*0.1,
                  vertical: 20),
              width: Get.width,
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Container(
                width: Get.width/2,
                child:
              Text(widget.data.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                color: Colors.black, ),
                textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),),
              decoration: BoxDecoration(color: MyColors.green_DEECCB,
                  boxShadow: [BoxShadow(color: Colors.grey.shade400.withOpacity(0.7),
                  spreadRadius: 5, blurRadius: 5)],
                  borderRadius: BorderRadius.circular(0),
                  ),),
            Container(
              margin: EdgeInsets.only(left: Get.width*0.05),
              child: CircleAvatar(backgroundColor: Colors.grey,
                radius: 27,
                foregroundImage:NetworkImage(widget.data.photo),),)
          ],)),);
  }

}