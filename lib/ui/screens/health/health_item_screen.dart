import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_app/controllers/health_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:health_app/domain/data/health_data.dart';
import 'package:health_app/other/enum.dart';
import 'package:health_app/ui/widgets/videoItem.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:appinio_video_player/appinio_video_player.dart';

class HealthItemScreen extends StatefulWidget {
  final HealthData? data;

  HealthItemScreen({this.data});

  @override
  State<StatefulWidget> createState() => HealthItemScreenState();
}

class HealthItemScreenState extends State<HealthItemScreen> {
  String partnerId = '';
  String selectPhoto = '';
  String selectPreviewPhoto = '';
  bool selectVideo = false;
  final HealthController _healthController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();

  ValueNotifier<Categories?> selectedCat = ValueNotifier(null);

  bool isVideo = false;

  void setUserPhoto() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = !isVideo
        ? await _picker.pickImage(source: ImageSource.gallery)
        : await _picker.pickVideo(source: ImageSource.gallery);
    if (image != null) {
      if (isVideo) {
        VideoPlayerController controller =
            await VideoPlayerController.file(File(image.path));
        await controller.initialize();
        if (controller.value.duration.inSeconds > 30) {
          print('DURATION>1');
          Get.snackbar('Ошибка',
              "Максимальная продолжительность видео должна быть 30 секунд");
          return;
        } else {
          print(
              'DURATION else ${controller.value.duration.inSeconds} , ${controller.value.duration}');
        }
      }
      setState(() {
        selectPhoto = '';
        selectVideo = isVideo;
        selectPhoto = image.path;
      });
      print('images added ${selectPhoto}');
      // _userController.userPhotoPath.value = selectPhoto;
    }
  }

  @override
  void initState() {
    if (widget.data != null) {
      _healthController.initSelectPartner(widget.data!.id);
      if (widget.data!.photo.contains('health_video')) {
        isVideo = true;
      }

      partnerId = widget.data!.id;
      _nameController.text = widget.data!.name;

      _siteController.text = widget.data!.site;
    } else {}
    super.initState();
  }

  @override
  void dispose() {
    _healthController.selectPartner.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: widget.data != null
                ? Obx(() => _healthController.selectPartner.value != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildToolbar(),
                          buildBody(),
                        ],
                      )
                    : CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildToolbar(),
                      buildBody(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildUserPhoto(),
        buildPreview(),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Название',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              height: 48,
              width: 200,
              child: TextFormField(
                controller: _nameController,
                maxLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    hintText: 'Введите название',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: MyColors.green_016938),
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Ссылка на сайт',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              height: 48,
              width: 200,
              child: TextFormField(
                controller: _siteController,
                maxLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    hintText: 'Введите ссылку',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: MyColors.green_016938),
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Дата: ',
                  style: TextStyle(color: MyColors.grey_C6C6C6),
                ),
                Text(_healthController.selectPartner.value == null
                    ? '${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}'
                    : '${DateFormat('yyyy-MM-dd – kk:mm').format(_healthController.selectPartner.value!.createAt.toDate())}')
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Категория',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: Categories.values.map((cat) => _buildChip(cat)).toList(),
            ),
            const SizedBox(height: 20),
          ],
        )
      ],
    );
  }

  Widget _buildChip(Categories cat) {
    return ValueListenableBuilder(
      valueListenable: selectedCat,
      builder: (_, Categories? selected, __) => InputChip(
        deleteIcon: const SizedBox(),
        padding: EdgeInsets.all(2.0),
        avatar: CircleAvatar(
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: cat.getIcon(),
          ),
        ),
        label: Text(
          cat.getText(),
          style: TextStyle(color: cat == selected ? Colors.white : Colors.black),
        ),
        selected: cat == selected,
        selectedColor: Colors.blue.shade600,
        onSelected: (bool selected) {
          selectedCat.value = cat;
        },
        onDeleted: () {},
      ),
    );
  }

  Widget buildUserPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVideo = false;
                  });
                },
                child: Text(
                  "Фото",
                  style: TextStyle(color: isVideo ? Colors.black : Colors.blue),
                ),
              ),
              SizedBox(
                width: Get.width * 0.01,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVideo = true;
                  });
                },
                child: Text(
                  "Видео",
                  style:
                      TextStyle(color: !isVideo ? Colors.black : Colors.blue),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
            onTap: () {
              setUserPhoto();
            },
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Container(
                        width: 200,
                        height: 200,
                        //padding: EdgeInsets.all(2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20)),
                        child: isVideo
                            ? selectPhoto.isEmpty
                                ? Container(
                                    child: (widget.data == null ||
                                            (widget.data != null &&
                                                widget.data!.photo.isEmpty))
                                        ? Icon(
                                            Icons.add,
                                            color: MyColors.green_4CAD79,
                                          )
                                        : Obx(() => Container(
                                            child: _healthController
                                                    .selectPartner.value!.photo
                                                    .contains('health_video')
                                                ? VideoItem(
                                                    data: widget.data!.photo)
                                                : Icon(
                                                    Icons.add,
                                                    color:
                                                        MyColors.green_4CAD79,
                                                  ))))
                                : Container(
                                    child: selectVideo
                                        ? VideoItem(data: selectPhoto)
                                        : Icon(
                                            Icons.add,
                                            color: MyColors.green_4CAD79,
                                          ))
                            : Container(
                                child: selectPhoto.isEmpty
                                    ? Container(
                                        child: (widget.data == null ||
                                                (widget.data != null &&
                                                    widget.data!.photo.isEmpty))
                                            ? Icon(
                                                Icons.add,
                                                color: MyColors.green_4CAD79,
                                              )
                                            : Obx(() => Container(
                                                child: _healthController
                                                        .selectPartner
                                                        .value!
                                                        .photo
                                                        .contains(
                                                            'health_photo')
                                                    ? Image.file(
                                                        File(widget.data!.photo),
                                                        fit: BoxFit.fill)
                                                    : Icon(
                                                        Icons.add,
                                                        color: MyColors
                                                            .green_4CAD79,
                                                      ))))
                                    : Container(
                                        child: !selectVideo
                                            ? Image.file(File(selectPhoto), fit: BoxFit.fill)
                                            : Icon(
                                                Icons.add,
                                                color: MyColors.green_4CAD79,
                                              )))),
                  ],
                ))),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildToolbar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: MyColors.green_016938,
          ),
        ),
        Container(
            child: Obx(() => _healthController.showLoader.value
                ? CircularProgressIndicator(
                    color: MyColors.green_016938,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_nameController.text.isEmpty) {
                            Get.snackbar('Ошибка', 'Введите данные');
                            return;
                          }
                          if (_siteController.text.isEmpty) {
                            Get.snackbar('Ошибка', 'Введите данные');
                            return;
                          }
                          if (_nameController.text.isEmpty) {
                            Get.snackbar('Ошибка', 'Введите данные');
                            return;
                          }
                          if (selectedCat.value == null) {
                            Get.snackbar('Ошибка', 'Выберите категорию');
                            return;
                          }
                          if (widget.data == null) {
                            HealthData data = HealthData(
                              id: Uuid().v4(),
                              name: _nameController.text,
                              photo: selectPhoto,
                              site: _siteController.text,
                              appUri: "",
                              createAt: Timestamp.now(),
                              preview: selectPreviewPhoto,
                              category: selectedCat.value!,
                            );
                            try {
                              await _healthController.setDataWithPhoto(
                                data: data,
                                file: selectPhoto.isNotEmpty
                                    ? await XFile(selectPhoto).readAsBytes()
                                    : null,
                                isVideo: isVideo,
                                preview: selectPreviewPhoto.isNotEmpty
                                    ? await XFile(selectPreviewPhoto)
                                        .readAsBytes()
                                    : null,
                              );
                            } catch (e) {
                              print("error is ${e} select is ${selectPhoto}");
                            }
                            _healthController.selectPartner.value = data;
                            await _healthController.updatePartnersList();
                            Get.back();
                            Get.snackbar(
                                'Поздравляем!', 'Информация сохранена');
                          } else {
                            HealthData data =
                                _healthController.selectPartner.value!.copyWith(
                              name: _nameController.text,
                              site: _siteController.text,
                              appUri: "",
                            );
                            await _healthController.setDataWithPhoto(
                              data: data,
                              file: selectPhoto.isNotEmpty
                                  ? await XFile(selectPhoto).readAsBytes()
                                  : null,
                              isVideo: isVideo,
                              preview: selectPreviewPhoto.isNotEmpty
                                  ? await XFile(selectPreviewPhoto)
                                      .readAsBytes()
                                  : null,
                            );
                            await _healthController.updatePartnersList();
                            Get.back();
                            Get.snackbar('Поздравляем!',
                                'Информация отправлена на проверку');
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: MyColors.green_016938,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      spreadRadius: 1,
                                      blurRadius: 5)
                                ]),
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.02,
                                vertical: Get.width * 0.01),
                            child: Text(
                              'Сохранить',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
                      )
                    ],
                  )))
      ],
    );
  }

  Widget buildPreview() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Превью фото',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: setPreviewPhoto,
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.1),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border:
                    Border.all(color: Colors.black.withOpacity(.2), width: 2),
              ),
              child: widget.data == null ? _newADS() : _updateADS(),
            ),
          ),
          SizedBox(height: 10),
        ],
      );

  void setPreviewPhoto() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectPreviewPhoto = '';
        selectPreviewPhoto = image.path;
      });
      print('images added ${selectPreviewPhoto}');
    }
  }

  Widget _newADS() => selectPreviewPhoto.isNotEmpty
      ? Image.file(
          File(selectPreviewPhoto),
          fit: BoxFit.cover,
        )
      : Icon(
          Icons.add,
          color: MyColors.green_4CAD79,
        );

  Widget _updateADS() =>
      widget.data?.preview != null && selectPreviewPhoto.isEmpty
          ? Image.file(
              File(widget.data!.preview!),
              fit: BoxFit.cover,
            )
          : _newADS();
}
