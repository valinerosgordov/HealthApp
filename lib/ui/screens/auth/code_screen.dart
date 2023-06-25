import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/user_controller.dart';
import 'package:health_app/domain/data/user_data.dart';
import 'package:health_app/other/delayed_action.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/my_colors.dart';

class CodeScreen extends StatefulWidget {
  final String phone;

  CodeScreen({required this.phone});

  @override
  State<StatefulWidget> createState() => CodeScreenState();
}

class CodeScreenState extends State<CodeScreen> {
  final AuthController _authController = Get.find();
  final TextEditingController _codeController = TextEditingController();
  final UserController _userController = Get.find();
  String cache = "";
  RxBool isBlocked = RxBool(false);

  @override
  void initState() {
    super.initState();
    _codeController.addListener(
      () async {
        if (_codeController.text.length == 6 && cache != _codeController.text) {
          if (_codeController.text.length == 6 &&
              GetUtils.isNumericOnly(_codeController.text)) {
            isBlocked.value = true;
            CodeState state =
                await _authController.sendCode(smsCode: _codeController.text);
            if (state is CodeOkState) {
              await _userController.setDataIfExist(
                  userData: UserData(
                      uuId: _authController.getAuthInstance()!.uid,
                      phoneNumber:
                          _authController.getAuthInstance()!.phoneNumber!,
                      name: '',
                      soname: '',
                      photoUri: '',
                      city: '',
                      id: Uuid().v4(),
                      partnersLikes: [],
                      active: true));
              await Future.delayed(const Duration(milliseconds: 100));
              Get.back();
            } else {
              isBlocked.value = false;
              Get.snackbar(
                'Ошибка',
                'Попробуйте снова',
                backgroundColor: Colors.white,
                colorText: MyColors.green_016938,
              );
            }
          }
        }
        cache = _codeController.text;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: MyColors.green_016938,
      ),
      // resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              child: SvgPicture.asset(
                'images/code_fon.svg',
                width: Get.width,
                fit: BoxFit.fitWidth,
              ),
            ),
            // Positioned(
            //   bottom: 50,
            //   left: Get.width * 0.24,
            //   child: Row(
            //     children: [
            //     ],
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.width * 0.35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ВВЕДИТЕ КОД ИЗ СМС',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: Get.width * 0.05,
                        left: Get.width * 0.05,
                        right: Get.width * 0.05),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: Offset(0, -5))
                    ], borderRadius: BorderRadius.circular(20)),
                    //color: Colors.grey.shade300,
                    //  margin: EdgeInsets.all(10),
                    child: TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: _codeController,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Введите код',
                          filled: true,
                          fillColor: Colors.white,
                          counter: Text(''),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                        ))),
                SizedBox(
                  height: Get.width * 0.02,
                ),
                buildTxt(),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerLeft,
                    children: [
                      Positioned(
                        left: -50,
                        child: Center(
                          child: SvgPicture.asset(
                            'images/code_line_v2.svg',
                            width: Get.width * 0.5,
                          ),
                        ),
                      ),
                      Obx(
                        () => Container(
                          padding: EdgeInsets.only(left: 110),
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: isBlocked.value
                                ? () {}
                                : () {
                                    isBlocked.value = true;
                                    DelayedAction.run(
                                      () async {
                                        if (_codeController.text.length == 6 &&
                                            GetUtils.isNumericOnly(
                                                _codeController.text)) {
                                          CodeState state =
                                              await _authController.sendCode(
                                                  smsCode:
                                                      _codeController.text);
                                          if (state is CodeOkState) {
                                            await _userController
                                                .setDataIfExist(
                                              userData: UserData(
                                                uuId: _authController
                                                    .getAuthInstance()!
                                                    .uid,
                                                phoneNumber: _authController
                                                    .getAuthInstance()!
                                                    .phoneNumber!,
                                                name: '',
                                                soname: '',
                                                photoUri: '',
                                                city: '',
                                                id: Uuid().v4(),
                                                partnersLikes: [],
                                                active: true,
                                              ),
                                            );
                                            await Future.delayed(
                                              const Duration(milliseconds: 100),
                                            );
                                            Get.back();
                                          } else {
                                            isBlocked.value = false;
                                            Get.snackbar(
                                              'Ошибка',
                                              'Попробуйте снова',
                                              backgroundColor: Colors.white,
                                              colorText: MyColors.green_016938,
                                            );
                                          }
                                        } else {
                                          isBlocked.value = false;
                                          Get.snackbar(
                                            'Ошибка',
                                            'Введите код',
                                            backgroundColor: Colors.white,
                                            colorText: MyColors.green_016938,
                                          );
                                        }
                                      },
                                    );
                                  },
                            child: SvgPicture.asset(
                              'images/auth_btn.svg',
                              width: Get.width * 0.25,
                              height: Get.width * 0.25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTxt() {
    return Container(
      width: Get.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => GestureDetector(
                onTap: () async {
                  if (_authController.time.value == 30) {
                    try {
                      await _authController.phoneAuth(widget.phone);
                    } catch (e) {
                      Get.snackbar('Ошибка', 'Попробуйте еще раз',
                          backgroundColor: Colors.white,
                          colorText: MyColors.green_016938);
                    }
                  }
                },
                child: Text(
                  'отправить код повторно',
                  style: TextStyle(
                      fontSize: 15,
                      color: _authController.time.value == 30
                          ? MyColors.green_016938
                          : Colors.grey,
                      fontWeight: FontWeight.w700),
                ),
              )),
          Obx(() => Visibility(
                child: Text(
                  ' ${_authController.time.value}',
                  style: TextStyle(
                      fontSize: 15,
                      color: MyColors.green_016938,
                      fontWeight: FontWeight.w700),
                ),
                visible: _authController.time.value != 30 &&
                    _authController.time.value != 0,
              ))
        ],
      ),
    );
  }
}
