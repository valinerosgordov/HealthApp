import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/auth_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:health_app/ui/screens/loader_screen.dart';

class ExitDialog extends StatelessWidget {
  ExitDialog({this.text = 'Вы уверены, что хотите выйти?'});

  final String text;

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Get.width * 0.05),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Get.width * 0.05,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () async {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.01,
                                vertical: Get.width * 0.02),
                            decoration: BoxDecoration(
                                color: MyColors.green_016938,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Нет',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: Get.width * 0.05,
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () async {
                            try {
                              await _authController.logOut();
                              Get.off(LoaderScreen());
                            } catch (e) {
                              Get.snackbar('Ошибка', 'Попробуйте еще раз')
                                  .show();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.01,
                                vertical: Get.width * 0.02),
                            decoration: BoxDecoration(
                                color: MyColors.red_FF3B30,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Да',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          )),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
