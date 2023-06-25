import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controllers/user_count_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:get/get.dart';
import 'package:health_app/ui/screens/important/important_item.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../controllers/ad_controller.dart';
import '../../../domain/data/ad_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ImportantScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ImportantScreenState();
}

class ImportantScreenState extends State<ImportantScreen> {
  final AdController _adController = Get.find();
  final ScrollController _listController = ScrollController();
  final ScrollController _listSecondController = ScrollController();
  late PageController _pageController;
  final UserCountController _userCountController = UserCountController();
  var currentPageValue = 0.0;

  @override
  void initState() {
    _userCountController.getCount();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);

    _pageController.addListener(() {
      if (_pageController.page ==
          _adController.partnersList.value!.length - 1) {
        _adController.getNextPage();
      }
      if (_pageController.page != null) {
        if (_adController.partnersList.value != null &&
            _adController.partnersList.value!.length > 1) {
          setState(() {
            currentPageValue = _pageController.page!;
          });
        } else {
          setState(() {
            currentPageValue = _pageController.page!;
            //  currentPageValue = 1;
          });
        }
      }
    });

    _adController.updatePartnersList();
    _listController.addListener(() async {
      if (_listController.offset >= _listController.position.maxScrollExtent &&
          !_listController.position.outOfRange) {
        if (_adController.partnersList.value != null &&
            _adController.documentList.length % 5 == 0) {
          _adController.getNextPage();
        } else {
          // _commentController.showLoader.value = false;
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_E7EEE7,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 60),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: buildHeader(),
                ),
                SizedBox(height: 30),
                Container(
                  child: Obx(
                    () => buildList(
                      list: _adController.partnersList,
                      scrollController: _listController,
                      reversed: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList({
    required Rxn<List<AdData>> list,
    required ScrollController scrollController,
    required bool reversed,
  }) {
    if (list.value == null) return const SizedBox();
    if (reversed) list.value?.reversed;
    return Container(
      width: Get.width,
      child: Obx(
        () => _adController.partnersList.value != null
            ? ListView(
                padding: EdgeInsets.only(bottom: 50),
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: _adController.partnersList.value!.map(
                  (e) {
                    return GestureDetector(
                      onTap: () {
                        if (e.site.isEmpty) return;
                        Get.dialog(
                          ImportantItem(
                            photo: e.photo,
                            site: e.site,
                          ),
                        );
                      },
                      child: Container(
                        width: Get.width - 50,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width - 50,
                              height: Get.width - 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                                  // e.photo.contains('ad_video') &&
                                  //         e.preview != null &&
                                  //         e.preview!.isNotEmpty
                                  //     ? VideoItem(
                                  //         data: e.photo,
                                  //       )
                                  //     :
                                  Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: e.preview != null && e.preview!.isNotEmpty
                                        ? e.preview!
                                        : e.photo,
                                    fit: BoxFit.cover,
                                    width: Get.width - 50,
                                    height: Get.width - 50 - 20,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              )
            : const SizedBox(),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: EdgeInsets.only(left: 24),
              //width:300,
              // margin: EdgeInsets.only(left: 25),

              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Text(
                "Важное",
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
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  // width: 120,
                  margin: EdgeInsets.only(right: 30),
                  padding: EdgeInsets.symmetric(
                      vertical: Get.width * 0.02, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Нас уже",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      //"223к"
                      Obx(
                        () => _userCountController.userCount.value != null
                            ? Text(
                                NumberFormat.compact().format(
                                    _userCountController.userCount.value),
                                style: TextStyle(
                                    color: MyColors.green_36B448,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16))
                            : SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 1,
                            blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: MyColors.green_36B448, shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    'images/random_img.svg',
                    height: 30,
                    width: 30,
                  ),
                  padding: EdgeInsets.all(10),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
