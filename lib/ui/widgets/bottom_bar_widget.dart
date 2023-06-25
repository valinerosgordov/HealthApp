import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/bar_controller.dart';
import 'package:health_app/controllers/user_controller.dart';
import 'package:health_app/ui/screens/health/health_screen.dart';
import 'package:health_app/ui/screens/home/home_screen.dart';
import 'package:health_app/ui/screens/important/important_screen.dart';
import 'package:health_app/ui/screens/onboarding_screen.dart';
import 'package:health_app/ui/screens/partners/partners_category.dart';
import 'package:health_app/ui/screens/partners/partners_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/my_colors.dart';

class BottomBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomBarWidgetState();
}

class BottomBarWidgetState extends State<BottomBarWidget> {
  BarController _barController = BarController();
  final UserController _userController = Get.find();
  List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[];

  List<Widget> screens = <Widget>[
    HomeScreen(),
    ImportantScreen(),
    HealthScreen(),
    Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PartnersScreen(),
        PartnersCategory(),
      ],
    )
  ];

  @override
  void initState() {
    _userController.initUser();
    items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          activeIcon: Icon(
            Icons.home,
            color: Colors.blue,
          ),
          label: "Engage"),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        activeIcon: Icon(
          Icons.home,
          color: Colors.blue,
        ),
        label: "Profile",
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          activeIcon: Icon(
            Icons.home,
            color: Colors.blue,
          ),
          label: "Chat")
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Obx(() => _userController.user.value == null
            ? buildLoader()
            : (_userController.user.value!.name.isNotEmpty &&
                    _userController.user.value!.soname.isNotEmpty &&
                    _userController.user.value!.city.isNotEmpty)
                ? _userController.user.value!.active
                    ? Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: getBody(),
                        bottomNavigationBar: buildMyNavBar(context)
                        /*
        BottomNavigationBar(
          enableFeedback: false,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MyColors.green_4CAD79,
          unselectedItemColor: Colors.grey,
          items: items,
          currentIndex: _barController.index.value,
          onTap: (index) {

            _barController.index.value = index;
          },
        )
        */

                        )
                    : Scaffold(
                        body: Container(
                          width: Get.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 30,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Ошибка доступа',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      )
                : OnBoardingScreen()));
  }

  Widget buildLoader() {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: Get.width,
            height: 50,
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget getBody() {
    return screens[_barController.index.value];
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
        color: MyColors.green_016938,
        child: SafeArea(
          child: ClipPath(
              clipper: CustomClip(),
              child: Container(
                width: Get.width,
                height: Get.width * 0.14,
                decoration: BoxDecoration(
                  color: MyColors.green_016938,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16)),
                ),
                child:
                    //bar_icon.svg
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => IconButton(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.zero,
                        enableFeedback: false,
                        onPressed: () {
                          _barController.index.value = 0;
                        },
                        icon: _barController.index.value == 0
                            ? Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topCenter,
                                    width: Get.width * 0.15,
                                    height: Get.height * 0.14,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned.fill(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'images/bottom_back_icon.svg',
                                                width: Get.width * 0.12,
                                                fit: BoxFit.fitWidth,
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: Get.width * 0.01,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(0),
                                                  child: SvgPicture.asset(
                                                    'images/profile_icon.svg',
                                                    width: Get.width * 0.09,
                                                    height: Get.width * 0.09,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Get.width * 0.005,
                                                ),
                                                Text(
                                                  'Профиль',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  )),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: Get.width * 0.01,
                                  ),
                                  Expanded(
                                      child: SvgPicture.asset(
                                    'images/profile_icon.svg',
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
                                  )),
                                  SizedBox(
                                    height: Get.width * 0.005,
                                  ),
                                  Text(
                                    'Профиль',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ))),
                    Obx(() => IconButton(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.zero,
                        enableFeedback: false,
                        onPressed: () {
                          _barController.index.value = 1;
                        },
                        icon: _barController.index.value == 1
                            ? Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topCenter,
                                    width: Get.width * 0.15,
                                    height: Get.height * 0.14,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned.fill(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'images/bottom_back_icon.svg',
                                                width: Get.width * 0.12,
                                                fit: BoxFit.fitWidth,
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: Get.width * 0.01,
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 0),
                                                  child: SvgPicture.asset(
                                                    'images/important_icon.svg',
                                                    width: Get.width * 0.09,
                                                    height: Get.width * 0.09,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Get.width * 0.005,
                                                ),
                                                Text(
                                                  'Важное',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  )),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: Get.width * 0.01,
                                  ),
                                  Expanded(
                                      child: SvgPicture.asset(
                                    'images/important_icon.svg',
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
                                  )),
                                  SizedBox(
                                    height: Get.width * 0.005,
                                  ),
                                  Text(
                                    'Важное',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ))),
                    //health_icon.svg
                    Obx(() => IconButton(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.zero,
                        enableFeedback: false,
                        onPressed: () {
                          _barController.index.value = 2;
                        },
                        icon: _barController.index.value == 2
                            ? Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topCenter,
                                    width: Get.width * 0.15,
                                    height: Get.height * 0.14,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned.fill(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'images/bottom_back_icon.svg',
                                                width: Get.width * 0.12,
                                                fit: BoxFit.fitWidth,
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: Get.width * 0.01,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(0),
                                                  child: SvgPicture.asset(
                                                    'images/health_icon.svg',
                                                    width: Get.width * 0.09,
                                                    height: Get.width * 0.09,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Get.width * 0.005,
                                                ),
                                                Text(
                                                  'Полезное',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  )),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: Get.width * 0.01,
                                  ),
                                  Expanded(
                                      child: SvgPicture.asset(
                                    'images/health_icon.svg',
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
                                  )),
                                  SizedBox(
                                    height: Get.width * 0.005,
                                  ),
                                  Text(
                                    'Полезное',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ))),

                    Obx(() => IconButton(
                        //constraints: BoxConstraints(maxWidth: Get.width/10, minWidth: Get.width/10),
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.zero,
                        enableFeedback: false,
                        onPressed: () {
                          _barController.index.value = 3;
                        },
                        icon: _barController.index.value == 3
                            ? Column(
                                children: [
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topCenter,
                                    width: Get.width * 0.17,
                                    height: Get.height * 0.14,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned.fill(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'images/bottom_back_icon.svg',
                                                width: Get.width * 0.12,
                                                fit: BoxFit.fitWidth,
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: Get.width * 0.01,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(0.00),
                                                  child: SvgPicture.asset(
                                                    'images/partners_icon.svg',
                                                    width: Get.width * 0.09,
                                                    height: Get.width * 0.09,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Get.width * 0.005,
                                                ),
                                                Text(
                                                  'Партнёры',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  )),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: Get.width * 0.01,
                                  ),
                                  Expanded(
                                      child: SvgPicture.asset(
                                    'images/partners_icon.svg',
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
                                  )),
                                  SizedBox(
                                    height: Get.width * 0.005,
                                  ),
                                  Text(
                                    'Партнёры',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ))),
                  ],
                ),
              )),
        ));
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 100;

    Path path = Path();
    path
      ..moveTo(size.width / 2, 0)
      ..arcToPoint(Offset(size.width, size.height),
          radius: Radius.circular(radius))
      ..lineTo(0, size.height)
      ..arcToPoint(
        Offset(size.width / 2, 0),
        radius: Radius.circular(radius),
      )
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
