import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/health_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:animation_list/animation_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/domain/data/health_data.dart';
import 'package:health_app/other/enum.dart';
import 'package:health_app/ui/screens/camera/test.dart';
import 'package:health_app/ui/screens/health/health_item_screen.dart';
import 'package:health_app/ui/screens/important/important_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html_unescape/html_unescape.dart';

class HealthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HealthScreenState();
}

class HealthScreenState extends State<HealthScreen>
    with TickerProviderStateMixin {
  final HealthController _healthController = Get.find();
  late TabController _controller;
  ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  var unescape = HtmlUnescape();

  @override
  void initState() {
    _healthController.updatePartnersList();
    super.initState();
    _controller = TabController(length: Categories.values.length, vsync: this);
    _controller.addListener(() {
      selectedIndexNotifier.value = _controller.index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SvgPicture.asset(
          'images/health_fon.svg',
          fit: BoxFit.fill,
        ),
        Container(
          width: Get.width,
          height: Get.height - 56,
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              buildHeader(),
              //SizedBox(height: 60,),
              // Expanded(
              //   child: ,
              // ),
              Expanded(
                child: DefaultTabController(
                  length: 5,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      TabBar(
                        indicatorColor: MyColors.green_4CAD79,
                        isScrollable: true,
                        controller: _controller,
                        tabs: Categories.values
                            .map((e) => _singleTab(e))
                            .toList(),
                        labelPadding: EdgeInsets.symmetric(horizontal: 8),
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _controller,
                          children: Categories.values
                              .map((e) => buildList(e))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Text(
                  "Полезное",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: BoxDecoration(
                    color: MyColors.green_016938,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.to(HealthItemScreen());
                },
                child: Container(
                  width: 42,
                  height: 42,
                  child: Center(
                    child: Text(
                      "+",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.green_016938,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildList(Categories cat) {
    return Container(
        width: Get.width,
        child: Obx(
          () => _healthController.partnersList.value == null
              ? const SizedBox()
              : AnimationList(
                  duration: 1000,
                  reBounceDepth: 20.0,
                  padding: EdgeInsets.only(top: Get.width * 0.15),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: _healthController.partnersList.value!
                      .where((e) => e.status == null && e.category == cat)
                      .toList()
                      .map((e) {
                    return e.isBig
                        ? _bigCard(e)
                        : GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.dialog(
                                  ImportantItem(photo: e.photo, site: e.site));
                            },
                            child: Container(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.1,
                                      vertical: Get.width * 0.05,
                                    ),
                                    width: Get.width,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      e.name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border:
                                            Border.all(color: Colors.black)),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: Get.width * 0.05),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      foregroundImage: e.preview != null
                                          ? CachedNetworkImageProvider(
                                              e.preview!)
                                          : CachedNetworkImageProvider(e.photo),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                  }).toList(),
                ),
        ));
  }

  Widget _singleTab(Categories cat) => ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (_, int selected, __) => AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: () {
              _controller.animateTo(cat.getIndex());
            },
            child: Container(
              height: 48,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: selected == cat.getIndex()
                  ? Center(
                      child: Text(
                        cat.getText(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : cat.getIcon(),
            ),
            behavior: HitTestBehavior.translucent,
          ),
        ),
      );

  Widget _bigCard(HealthData e) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Get.to(DetailHeath(e));
        },
        child: Container(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.1,
                  vertical: Get.width * 0.05,
                ),
                width: Get.width,
                child: Row(
                  children: [
                    SizedBox(
                      child: CachedNetworkImage(
                        imageUrl: e.preview ?? e.photo,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.qr_code),
                      ),
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        unescape.convert(e.name),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Get.width * 0.05),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundImage: CachedNetworkImageProvider(
                      "https://firebasestorage.googleapis.com/v0/b/way-to-health-b4b8f.appspot.com/o/our%20(1).jpg?alt=media&token=25f8b6eb-4e4f-4372-86ca-3c6a45f16b4b&_gl=1*1chw2o1*_ga*NTYwMjU4MDMuMTY3MDQzMjc2Mw..*_ga_CW55HF8NVT*MTY4NTYyNDUwNS4zNC4xLjE2ODU2MjUxOTguMC4wLjA."),
                ),
              )
            ],
          ),
        ),
      );
}
