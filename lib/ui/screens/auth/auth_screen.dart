import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/auth_controller.dart';
import 'package:health_app/ui/screens/auth/code_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/my_colors.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final AuthController _authController = Get.find();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    _phoneController.text = '+7';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Stack(
            children: [
              SvgPicture.asset(
                'images/auth_fon_2.svg',
                width: Get.width,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
              Positioned(
                  top: Get.width * 0.22,
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Начни свой путь к здоворью\nпрямо сейчас!',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )),
              Positioned(
                  bottom: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'images/auth_btn_line.svg',
                        width: Get.width * 0.8,
                      ),
                    ],
                  )),
              Positioned(
                  bottom: Get.height / 5.9,
                  left: Get.width * 0.12,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_authController.checkPhoneData(
                              phoneNumber: _phoneController.text)) {
                            try {
                              await _authController
                                  .phoneAuth(_phoneController.text);
                            } catch (e) {
                              Get.snackbar('Ошибка', 'Попробуйте еще раз',
                                  backgroundColor: Colors.white,
                                  colorText: MyColors.green_016938);
                            }
                            Get.to(CodeScreen(
                              phone: _phoneController.text,
                            ));
                          } else {
                            Get.snackbar('Ошибка', 'Введите номер',
                                backgroundColor: Colors.white,
                                colorText: MyColors.green_016938);
                          }
                        },
                        child: SvgPicture.asset(
                          'images/auth_btn.svg',
                          width: Get.width * 0.25,
                          height: Get.width * 0.25,
                        ),
                      )
                    ],
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: Get.width * 0.4,
                  ),
                  Container(
                    margin: EdgeInsets.all(Get.width * 0.05),
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
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      maxLines: 1,
                      maxLength: 12,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Введите номер',
                        prefixIcon: Container(
                          height: Get.width * 0.002,
                          width: Get.width * 0.004,
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(
                            'images/phone_icon.svg',
                            height: Get.width * 0.002,
                            width: Get.width * 0.002,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
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
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
