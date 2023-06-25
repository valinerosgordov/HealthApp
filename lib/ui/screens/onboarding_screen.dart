import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controllers/analytic_controller.dart';
import 'package:health_app/controllers/city_controller.dart';
import 'package:health_app/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../core/my_colors.dart';
import '../../domain/data/city_data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sonameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final CityController _locationController = CityController();
  final UserController _userController = Get.find();
  final AnalyticController _analyticController = AnalyticController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
              child: Stack(
            // alignment: Alignment.center,
            children: [
              //
              Positioned(
                  // top: Get.width*0.02,
                  child: Column(
                children: [
                  SvgPicture.asset(
                    'images/onboarding_fon.svg',
                    width: Get.width,
                    height: Get.height * 0.98,
                    fit: BoxFit.fitWidth,
                  ),
                  //SizedBox(height: Get.width*0.15,)
                ],
              )),

              Positioned(
                  left: 0,
                  bottom: 20,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'images/onboarding_line.svg',
                        width: Get.width * 0.8,
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  )),
              Positioned(
                  bottom: Get.height / 5.9,
                  left: Get.width * 0.47,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_nameController.text.isNotEmpty &&
                              _sonameController.text.isNotEmpty &&
                              _cityController.text.isNotEmpty) {
                            if ((_cityController.text !=
                                    _locationController.selectCity?.value) ||
                                _cityController.text.isEmpty) {
                              Get.snackbar('Ошибка', 'Выберете город из списка',
                                  backgroundColor: Colors.white,
                                  colorText: MyColors.green_016938);
                              return;
                            }
                            try {
                              await _userController.setUserData(
                                  userData: _userController.user.value!
                                      .copyWith(
                                          name: _nameController.text,
                                          soname: _sonameController.text,
                                          city: _cityController.text));
                              _analyticController.setUser(
                                  userId: _userController.user.value!.uuId);

                              // _userController.initUser();

                            } catch (e) {
                              Get.snackbar('Ошибка', 'Попробуйте снова',
                                  backgroundColor: Colors.white,
                                  colorText: MyColors.green_016938);
                            }
                          } else {
                            Get.snackbar('Ошибка', 'Заполните все поля',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: Get.width / 2,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Введите данные',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: Get.width * 0.08,
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
                          controller: _nameController,
                          maxLength: 20,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Введите имя',
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
                  Container(
                      margin: EdgeInsets.only(
                          //  top: Get.width * 0.05,
                          left: Get.width * 0.05,
                          right: Get.width * 0.05),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            //color: Colors.grey.shade400.withOpacity(0.7),
                            spreadRadius: 1,
                            blurRadius: 20,
                            offset: Offset(0, -5))
                      ], borderRadius: BorderRadius.circular(20)),
                      //color: Colors.grey.shade300,
                      //  margin: EdgeInsets.all(10),
                      child: TextFormField(
                          controller: _sonameController,
                          maxLength: 20,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Введите фамилию',
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
                  Container(
                    margin: EdgeInsets.only(
                        // top: Get.width * 0.05,
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
                    child: TypeAheadFormField(
                      direction: AxisDirection.up,
                      keepSuggestionsOnSuggestionSelected: false,
                      hideKeyboard: false,
                      noItemsFoundBuilder: (value) {
                        return Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Не найдено"));
                      },
                      hideSuggestionsOnKeyboardHide: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        onTap: () {
                          //closeAllDialogScreen();
                        },
                        onChanged: (txt) {
                          //closeAllDialogScreen();
                        },
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: 'Введите город',
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

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select a city';
                        }
                      },
                      // textFieldConfiguration: _typeAheadController,
                      onSuggestionSelected: (suggestion) async {
                        _locationController.selectCity =
                            suggestion as CityData?;
                        _cityController.text =
                            (suggestion as CityData).value.toString();
                      },
                      itemBuilder: (BuildContext context, CityData itemData) {
                        print(itemData.value);
                        print(itemData.lat);
                        return ListTile(
                          dense: true,
                          title: Text("${itemData.value}"),
                        );
                      },
                      suggestionsCallback: (String pattern) async {
                        return await _locationController.getCities(
                            query: '$pattern');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ],
          )),
        ));
  }

  Text buildFieldText({required String txt}) {
    return Text(txt);
  }
}
