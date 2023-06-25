import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/auth_controller.dart';
import 'package:health_app/controllers/user_controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:health_app/ui/screens/loader_screen.dart';

import '../../../controllers/city_controller.dart';
import 'dart:io';
import '../../../core/my_colors.dart';
import '../../../domain/data/city_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/event_switch.dart';

import 'package:image_cropper/image_cropper.dart';

class ProfileSetting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileSettingState();
}

class ProfileSettingState extends State<ProfileSetting> {
  String selectPhoto = '';
  bool getNotification = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sonameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final CityController _locationController = CityController();
  final UserController _userController = Get.find();
  final AuthController _authController = Get.find();

  setUserPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Редактирование',
              toolbarColor: MyColors.green_016938,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      setState(() {
        selectPhoto = '';
        selectPhoto = croppedFile?.path ?? image.path;
      });
      print('images added ${selectPhoto}');
      _userController.userPhotoPath.value = selectPhoto;
    }
  }

  @override
  void dispose() {
    // _userController.userPhotoPath.value = '';
    super.dispose();
  }

  @override
  void initState() {
    _nameController.text =
        _userController.user.value!.name.capitalizeFirst.toString();
    _sonameController.text =
        _userController.user.value!.soname.capitalizeFirst.toString();
    _cityController.text = _userController.user.value!.city;
    _userController.userPhotoPath.value = _userController.user.value!.photoUri;
    _locationController.selectCity =
        CityData(lat: 0, lon: 0, value: _userController.user.value!.city);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: buildUserInfo(),
          )
        ],
      ),
    ));
  }

  Widget buildUserPhoto() {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              setUserPhoto();
            },
            child: Container(
                padding: EdgeInsets.all(Get.width * 0.01),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: MyColors.green_4CAD79, width: 2)),
                child: Container(
                    width: Get.width * 0.35,
                    height: Get.width * 0.35,
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: selectPhoto.isEmpty
                        ? Obx(() => ClipOval(
                            child: _userController.user.value!.photoUri.isEmpty
                                ? SvgPicture.asset(
                                    'images/profile_photo.svg',
                                    width: Get.width * 1.5,
                                    height: Get.width * 1.5,
                                  )
                                : Image.network(
                                    _userController.user.value!.photoUri,
                                    width: Get.width * 1,
                                    height: Get.width * 1,
                                    fit: BoxFit.fitWidth,
                                  )))
                        : ClipOval(
                            child: Image.file(
                            File(
                              selectPhoto,
                            ),
                            width: Get.width * 1.5,
                            height: Get.width * 1.5,
                            fit: BoxFit.fitWidth,
                          ))))),

        /*
      Image.file(File(selectPhoto,
                 ),
                  width: Get.width*1.5,
                  height: Get.width*1.5,
              fit: BoxFit.fitWidth,),
       */
        /*
       CircleAvatar(
              foregroundImage:provider,
              backgroundColor: Colors.grey,
              radius: 35,
            );
       */
        SizedBox(
          height: Get.width * 0.03,
        ),
      ],
    );
  }

  Widget buildExit() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            try {
              await _authController.logOut();
              Get.off(LoaderScreen());
            } catch (e) {
              Get.snackbar('Ошибка', 'Попробуйте еще раз').show();
            }
          },
          child: Text('Выйти'),
        )
      ],
    );
  }

  Widget buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: Get.width * 0.15,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_outlined,
                color: MyColors.green_016938,
              ),
            )
          ],
        ),
        SizedBox(
          height: Get.width * 0.1,
        ),
        buildUserPhoto(),
        SizedBox(
          height: Get.width * 0.08,
        ),
        Row(
          children: [
            Text(
              'Личные данные',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            )
          ],
        ),
        SizedBox(
          height: Get.width * 0.025,
        ),
        Row(
          children: [
            Obx(() => Text(
                  '${_userController.user.value!.phoneNumber}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ))
          ],
        ),
        SizedBox(
          height: Get.width * 0.05,
        ),
        Container(
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
            //  ,

            keyboardType: TextInputType.name,
            controller: _nameController,
            maxLines: 1,
            maxLength: 20,
            autofocus: true,
            style: TextStyle(
                fontSize: 16,
                color: MyColors.green_016938,
                fontWeight: FontWeight.w700),

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
            ),
          ),
        ),

        Container(
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
            //  ,

            keyboardType: TextInputType.name,
            controller: _sonameController,
            style: TextStyle(
                fontSize: 16,
                color: MyColors.green_016938,
                fontWeight: FontWeight.w700),
            maxLines: 1,
            maxLength: 20,
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
            ),
          ),
        ),
        // SizedBox(height: 20,),
        Container(
          margin: EdgeInsets.only(),
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
                  padding: EdgeInsets.all(10), child: Text("Не найдено"));
            },
            hideSuggestionsOnKeyboardHide: false,
            textFieldConfiguration: TextFieldConfiguration(
              style: TextStyle(
                  fontSize: 16,
                  color: MyColors.green_016938,
                  fontWeight: FontWeight.w700),
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
              _locationController.selectCity = (suggestion as CityData?);
              _cityController.text = (suggestion as CityData).value.toString();
            },
            itemBuilder: (BuildContext context, CityData itemData) {
              print(itemData.value);
              print(itemData.lat);
              return ListTile(
                title: Text("${itemData.value}"),
              );
            },
            suggestionsCallback: (String pattern) async {
              return await _locationController.getCities(query: '$pattern');
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Получать уведомления',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            CustomEventSwitch(
              value: getNotification,
              onChanged: (bool value) {
                setState(() {
                  getNotification = value;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: Get.width * 0.08,
        ),

        Container(
            child: Obx(() => _userController.loading.value
                ? CircularProgressIndicator(
                    color: MyColors.green_016938,
                  )
                : GestureDetector(
                    onTap: () async {
                      if ((_cityController.text !=
                              _locationController.selectCity?.value) ||
                          _cityController.text.isEmpty) {
                        Get.snackbar('Ошибка', 'Выберете город из списка');
                        return;
                      }
                      if (_nameController.text.isNotEmpty &&
                          _sonameController.text.isNotEmpty &&
                          _cityController.text.isNotEmpty) {
                        if (selectPhoto.isNotEmpty) {
                          _userController.userPhotoPath.value = selectPhoto;
                        }
                        try {
                          await _userController.setUserData(
                              userData: _userController.user.value!.copyWith(
                                  name: _nameController.text,
                                  soname: _sonameController.text,
                                  city: _cityController.text));
                          // _userController.initUser();
                          Get.back();
                          Get.snackbar('Поздравляем!', 'Информация сохранена');
                        } catch (e) {
                          Get.snackbar('Ошибка', 'Попробуйте еще раз');
                        }
                      } else {
                        Get.snackbar('Ошибка', 'Заполните все поля');
                      }
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
                        'Сохранить',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ))),
      ],
    );
  }

  String getPhone() {
    return '${_userController.user.value!.phoneNumber[0]}(${_userController.user.value!.phoneNumber[1]}${_userController.user.value!.phoneNumber[2]}${_userController.user.value!.phoneNumber[3]})${_userController.user.value!.phoneNumber[4]}${_userController.user.value!.phoneNumber[5]}${_userController.user.value!.phoneNumber[6]}-${_userController.user.value!.phoneNumber[7]}${_userController.user.value!.phoneNumber[8]}${_userController.user.value!.phoneNumber[9]}-${_userController.user.value!.phoneNumber[10]}${_userController.user.value!.phoneNumber[11]}';
  }

  Row buildFieldText({required String txt}) {
    return Row(
      children: [Text(txt)],
    );
  }
}
