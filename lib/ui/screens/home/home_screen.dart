import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/become_visible_controller.dart';
import 'package:health_app/controllers/partners_controller.dart';
import 'package:health_app/controllers/user_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:health_app/domain/data/become_data.dart';
import 'package:health_app/other/delayed_action.dart';
import 'package:health_app/ui/awe.dart';
import 'package:health_app/ui/screens/camera/camera.dart';
import 'package:health_app/ui/screens/camera/test.dart';
import 'package:health_app/ui/screens/favorite_screen.dart';
import 'package:health_app/ui/screens/home/become_list.dart';
import 'package:health_app/ui/screens/home/exit_dialog.dart';
import 'package:health_app/ui/screens/home/profile_setting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final UserController _userController = Get.find();
  final PartnersController _partnersController = Get.find();
  final BecomeVisibleController _becomeController = Get.find();

  @override
  void initState() {
    super.initState();
    _becomeController.initCountStream();
    WidgetsBinding.instance.addObserver(this);
    _partnersController.getBecomePartner();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  void _showDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: const Text('Для использования функционала распознания продуктов, вам необходимо разрешить приложению доступ к камере в настройках телефона.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Отменить'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();

    if (statuses.containsKey(Permission.camera) &&
        statuses[Permission.camera]!.isPermanentlyDenied) {
      _showDialog(context);
    } else {
      if (statuses.containsKey(Permission.camera) &&
          statuses[Permission.camera]!.isDenied) {
        await permissionServices().then(
              (value) async {
            if (value != null) {
              if (value.containsKey(Permission.camera) &&
                  value[Permission.camera]!.isGranted) {
                final cameras = await availableCameras();
                final firstCamera = cameras.first;

                await Permission.camera.request();
                var status = await Permission.camera.status;
                if (status.isGranted || status.isLimited) {
                  Get.to(CameraApp());//camera: firstCamera
                } else {
                  print(123);
                }
              }
            }
          },
        );
      }
    }
    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: MyColors.grey_E7EEE7,
        floatingActionButton: Obx(
          () => Visibility(
            visible: _becomeController.userCount.value != null &&
                _becomeController.userCount.value! == 1,
            child: FloatingActionButton(
              onPressed: () {
                DelayedAction.run(() async {
                  await permissionServices().then(
                        (value) async {
                      if (value != null) {
                        if (value.containsKey(Permission.camera) &&
                            value[Permission.camera]!.isGranted) {
                          final cameras = await availableCameras();
                          final firstCamera = cameras.first;

                          await Permission.camera.request();
                          var status = await Permission.camera.status;
                          if (status.isGranted || status.isLimited) {
                            Get.to(CameraApp());//camera: firstCamera
                          } else {
                            _showDialog(context);
                          }
                        }
                      }
                    },
                  );
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset("images/camera.png"),
              ),
              backgroundColor: MyColors.green_016938,
            ),
          ),
        ),
        body: _userController.user.value != null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      top: 0,
                      child: SvgPicture.asset(
                        'images/home_fon.svg',
                        fit: BoxFit.fitWidth,
                        height: Get.height / 2,
                      )),
                  Positioned(
                      bottom: Get.width * 0.08,
                      child: SvgPicture.asset(
                        'images/home_line.svg',
                        width: Get.width,
                        fit: BoxFit.fitWidth,
                      )),
                  Positioned(
                      bottom: Get.width * 0.1,
                      right: Get.width * 0.08,
                      child: Container(
                        width: Get.width * 0.7,
                        height: Get.width * 0.7,
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: QrImage(
                          data: "1234567890",
                          version: QrVersions.auto,
                          padding: EdgeInsets.all(55),
                        ),
                      )),
                  Positioned(
                      left: Get.width * 0.05,
                      top: Get.height / 4.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width * 0.45,
                            height: Get.width * 0.45,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Obx(() =>
                                _userController.user.value!.photoUri.isEmpty
                                    ? ClipOval(
                                        child: SvgPicture.asset(
                                          'images/profile_photo.svg',
                                          width: Get.width * 1.5,
                                          height: Get.width * 1.5,
                                        ),
                                      )
                                    : ClipOval(
                                        child: Image.network(
                                          _userController.user.value!.photoUri,
                                          width: Get.width * 1.5,
                                          height: Get.width * 1.5,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      )),
                          ),
                          SizedBox(
                            height: Get.width * 0.03,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Obx(() => Row(
                                      children: [
                                        Text(
                                          _userController
                                              .user.value!.name.capitalizeFirst
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: MyColors.green_016938),
                                        )
                                      ],
                                    )),
                                Obx(() => Text(
                                      _userController
                                          .user.value!.soname.capitalizeFirst
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: MyColors.green_016938),
                                    )),
                                Obx(() => Text(
                                      _userController.user.value!.city,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: MyColors.green_016938),
                                    ))
                              ],
                            ),
                          )
                        ],
                      )),
                  Positioned(
                      right: Get.width * 0.05,
                      top: Get.height / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await FlutterShare.share(
                                  title: 'Заголовок',
                                  text: 'Описание',
                                  linkUrl: 'https://flutter.dev/',
                                  chooserTitle: 'Example Chooser Title');
                            },
                            child: Container(
                              width: Get.width * 0.4,
                              height: Get.width * 0.4,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'images/rait_line.svg',
                                    fit: BoxFit.fitWidth,
                                    width: Get.width * 0.4,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.05),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Поделиться',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: MyColors.green_016938),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: Get.width * 0.01,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: MyColors.green_016938,
                                                  shape: BoxShape.circle),
                                              child: Icon(
                                                Icons
                                                    .mobile_screen_share_outlined,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  SafeArea(
                    child: Container(
                      //margin: EdgeInsets.only(top: 100),
                      height: Get.height,
                      width: Get.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      _showAlertDialog(context);
                                    },
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // SizedBox(width: Get.width*0.1,),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Профиль',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                height: 32 / 25,
                                              ),
                                            ),
                                            SizedBox(
                                              height: Get.width * 0.01,
                                            ),
                                            Text(
                                              'ID 456789',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 16),
                                        FutureBuilder<List<BecomeData>>(
                                          future: _partnersController
                                              .getBecomePartner(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<BecomeData>>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12),
                                                child: GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () {
                                                    Get.to(BecomeList(
                                                        snapshot.data!));
                                                  },
                                                  child: Text(
                                                    'Мои заявки ' +
                                                        snapshot.data!.length
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          MyColors.grey_E2E8F0,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return const SizedBox();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // SizedBox(height: Get.width*0.05,),
                                    GestureDetector(
                                        onTap: () {
                                          Get.to(ProfileSetting());
                                        },
                                        child: SvgPicture.asset(
                                          'images/edit_profile.svg',
                                          width: Get.width * 0.05,
                                        )),
                                    SizedBox(
                                      height: Get.width * 0.05,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.dialog(ExitDialog());
                                          },
                                          child: SvgPicture.asset(
                                            'images/logout.svg',
                                            width: Get.width * 0.05,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: Get.width * 0.05),
                                        GestureDetector(
                                          onTap: () {
                                            Get.dialog(ExitDialog(
                                                text:
                                                    'Вы уверены, что хотите удалить профиль?'));
                                          },
                                          child: SvgPicture.asset(
                                            'images/delete-user.svg',
                                            width: Get.width * 0.07,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Get.width * 0.05,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          /*
                         Navigator.push(context,
                             PageTransition(type: PageTransitionType.bottomToTop,
                                 child: FavoriteScreen()));
                          */

                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .bottomToTop,
                                                  curve: Curves.easeOutQuart,
                                                  child: FavoriteScreen()));
                                          // Get.to(PageTransition(type:
                                          //PageTransitionType.bottomToTop,child:FavoriteScreen()));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Избранное',
                                                style: TextStyle(fontSize: 12),
                                              ),

                                              Icon(
                                                Icons.favorite,
                                                color: MyColors.green_36B448,
                                                size: 25,
                                              ),
                                              // SizedBox(height: Get.width*0.01,),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
      );
    });
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: const Text(
          """Приложение HEALTHY разработано в рамках проекта «Путь к здоровью». 
Приложение является агрегатором  собственной продукции и компаний, которые ориентированны на сохранение здоровья и улучшение качества жизни.

Для вас доступно:
-Приобретение товаров и услуг от нашей компании 
-Легко ориентироваться на интерактивной карте для поиска Healthy товаров и услуг
-Осуществлять поиск и заказ необходимых продуктов и доставки еды через интегрированные сайты компаний
-Получать скидки от всех участников проекта и узнавать об акциях
-Получать полезную информацию для 3ОЖа от лучших специалистов
-Оценивать качество оказанных услуг партнерами проекта и ставить оценку
-Общаться в чате с другими людьми и получать дополнительную информацию
-При помощи технологии Дополненная реальность (АR) по этикетке узнавать состав товара и получать оценку и рекомендацию от специалиста нутрициолога""",
          textAlign: TextAlign.start,
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}
