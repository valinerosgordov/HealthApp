import 'dart:async';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/health_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:health_app/domain/data/health_data.dart';
import 'package:health_app/other/delayed_action.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fast_barcode_scanner/fast_barcode_scanner.dart';
import 'package:health_app/ui/screens/camera/test.dart';

class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key}); //, required this.camera

  // final CameraDescription camera;

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp>
    with SingleTickerProviderStateMixin {
  //late CameraController controller;
  ValueNotifier<bool> visible = ValueNotifier(false);
  late VideoPlayerController _playerController;
  final HealthController _healthController = Get.find();
  int selectedIndex = 0;
  final PageController _pageController = PageController();
  bool isLeft = false;
 late double _width;
 late double _height;

  static List<Image> ruOnBoardingImgList = <Image>[
    Image.asset('images/s1.png'),
    Image.asset('images/s2.png'),
    Image.asset('images/s3.png'),
  ];

  static List<String> ruOnBoardingTxtList = <String>[
    'Приложение использует технологию дополненой реальности (AR)',
    'Держи смартфон ровно над продуктом чтобы мы могли подробно рассказать о нём',
    'Смотри что мы из чего он состоит и получи информацию о его пользе для твоего организма',
  ];

  @override
  void initState() {
    _playerController = VideoPlayerController.asset("images/video.MOV");
    _playerController.initialize().whenComplete(() {
      //_playerController.play();
      // if (mounted) {
      //   setState(() {});
      // }
    }).catchError((e) {
      print(e);
    });
    super.initState();

    // controller = CameraController(widget.camera, ResolutionPreset.max);
    // controller.initialize().then((_) {
    //   if (!mounted) {
    //     return;
    //   }
    //   setState(() {});
    // }).catchError((Object e) {
    //   if (e is CameraException) {
    //     switch (e.code) {
    //       case 'CameraAccessDenied':
    //         // Handle access errors here.
    //         break;
    //       default:
    //         // Handle other errors here.
    //         break;
    //     }
    //   }
    // });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        isLeft = !isLeft;
      });
    });
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  Future<void> scanBarcodeNormal() async {
    // String barcodeScanRes;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    //   print(barcodeScanRes);
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }
  }


  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          BarcodeCamera(
            types: const [
              BarcodeType.aztec,
              BarcodeType.code128,
              BarcodeType.code39,
              BarcodeType.code39mod43,
              BarcodeType.code93,
              BarcodeType.codabar,
              BarcodeType.dataMatrix,
              BarcodeType.ean13,
              BarcodeType.ean8,
              BarcodeType.itf,
              BarcodeType.pdf417,
              BarcodeType.qr,
              BarcodeType.upcA,
              BarcodeType.upcE,
              BarcodeType.interleaved,
            ],
            resolution: Resolution.hd720,
            framerate: Framerate.fps30,
            mode: DetectionMode.pauseVideo,
            onScan: (code) async {
              if (code.value == "4606779771200") {
                visible.value = true;
                _playerController.play();
              } else {
                final HealthData? item =
                    await _healthController.getItemByBarCode(code.value);
                if (item != null) {
                  await Get.to(DetailHeath(item));
                  CameraController.instance.resumeDetector();
                } else {
                  Get.dialog(
                    CupertinoAlertDialog(
                      content: Text("Ничего не найдено"),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () {
                            CameraController.instance.resumeDetector();
                            Get.back();
                          },
                          child: const Text('Попробовать еще раз'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            children: [
              ValueListenableBuilder(
                valueListenable: visible,
                builder: (_, bool status, __) => status
                    ? Container(
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: AspectRatio(
                          aspectRatio: _playerController.value.aspectRatio,
                          child: VideoPlayer(_playerController),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox(),
              ),
            ],
          ),

          //CameraPreview(controller),
          ValueListenableBuilder(
            valueListenable: visible,
            builder: (_, bool status, __) => !status
                ? Center(
                    child: Icon(
                      Icons.phone_android,
                      color: Colors.white.withOpacity(.2),
                      size: 200,
                    ),
                  )
                : const SizedBox(),
          ),
          ValueListenableBuilder(
            valueListenable: visible,
            builder: (_, bool status, __) => !status
                ? AnimatedPositioned(
                    top: Get.height / 2 - 75,
                    left: isLeft ? Get.width / 5 : Get.width / 5 * 4 - 200,
                    duration: Duration(milliseconds: 550),
                    child: Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.08),
                        border: Border.all(color: Colors.white.withOpacity(.1)),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "images/box.svg",
                          color: Colors.white.withOpacity(.1),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              child: SizedBox(
                height: 60,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          DelayedAction.run(() {
                            _playerController.pause();
                            Get.back();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          height: 40,
                          width: 40,
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_outlined,
                              color: MyColors.green_016938,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          DelayedAction.run(
                            () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (_) => buildPageView(),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          height: 40,
                          width: 40,
                          child: Icon(
                            Icons.info,
                            color: MyColors.green_016938,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageView() {
    return PageView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _pageController,
      onPageChanged: (int page) {
        setState(() {
          selectedIndex = page;
        });
      },
      itemCount: ruOnBoardingImgList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Get.width * 0.1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.00),
                    child: ruOnBoardingImgList[index],
                  ),
                  SizedBox(
                    height: Get.width * 0.08,
                  ),
                  SizedBox(
                    height: Get.width * 0.08,
                  ),
                  Text(
                    ruOnBoardingTxtList[index],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    // letterSpacing: 1, height: 1.5
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  IgnorePointer(
                    ignoring: index != 2,
                    child: Opacity(
                      opacity: index != 2 ? 0 : 1,
                      child: GestureDetector(
                        onTap: () {
                          DelayedAction.run(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Container(
                          height: Get.width * 0.14,
                          alignment: Alignment.center,
                          width: Get.width,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: MyColors.green_016938,
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            'Продолжить',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? MyColors.green_016938
                            : MyColors.grey_9B9B9B,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: index == 1
                            ? MyColors.green_016938
                            : MyColors.grey_9B9B9B,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: index == 2
                            ? MyColors.green_016938
                            : MyColors.grey_9B9B9B,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
