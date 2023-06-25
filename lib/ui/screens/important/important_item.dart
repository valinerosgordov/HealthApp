import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/other/other.dart';
import 'package:health_app/ui/screens/partners/web_screen.dart';
import '../../../core/my_colors.dart';
import 'dart:ui';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImportantItem extends StatefulWidget {
  final String photo;
  final String site;

  ImportantItem({required this.photo, required this.site});

  @override
  State<StatefulWidget> createState() => ImportantItemState();
}

class ImportantItemState extends State<ImportantItem> {
  VideoPlayerController? _playerController;

  @override
  void initState() {
    if (widget.photo.contains('video') || widget.photo.contains('.mp4')) {
      _playerController = VideoPlayerController.network(widget.photo);
      _playerController?.initialize().whenComplete(() {
        _playerController?.play();
        if (mounted) {
          setState(() {});
        }
      }).catchError((e) {
        print(e);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: Get.width - 32,
                    width: Get.width,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: buildContent(),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: Visibility(
                      visible: widget.site.isNotEmpty,
                      child: buildLink(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(height: 16),
              Positioned(
                left: 10,
                top: 0,
                child: Container(
                  alignment: Alignment.center,
                  //  bottom: Get.width*0.6,
                  child: Column(
                    children: [
                      buildHeader(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_outlined,
                        color: MyColors.green_016938,
                        size: 15,
                      ),
                      Text(
                        'Назад',
                        style: TextStyle(
                            fontSize: 12, color: MyColors.green_016938),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /*
  Widget buildDescription() {
    return Column(children: [
      Container(
        width: Get.width,
        margin: EdgeInsets.symmetric(horizontal: 24),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(color: MyColors.green_016938),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.grey.shade300,
                spreadRadius: 1, blurRadius: 5)
            ]
        ),
        child: Column(children: [
          Container(
            width: Get.width,
            child: Text(widget.adData.name,
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),)

        ],),
      )
    ],);
  }
   */

  Widget buildLink() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        _playerController?.pause();
        await launchInVC(Uri.parse(widget.site));
        // await Get.to(WebScreen(url: widget.site));
        _playerController?.play();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: MyColors.green_36B448,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(4),
              child: SvgPicture.asset(
                'images/site_icon.svg',
                width: 20,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Перейти',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            _playerController?.pause();
            await launchInVC(Uri.parse(widget.site));
            //await Get.to(WebScreen(url: widget.site));
            _playerController?.play();
          },
          child: Container(
            height: Get.width - 32 - 20,
            width: Get.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 1,
                      blurRadius: 5)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: (widget.photo.contains('ad_photo') ||
                      widget.photo.contains('health_photo') ||
                      widget.photo.contains('.jpg') ||
                      widget.photo.contains('.png'))
                  ? CachedNetworkImage(
                      imageUrl: widget.photo,
                      height: Get.width - 32 - 20,
                      width: Get.width,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    )
                  : buildVideoItem(),
            ),
          ),
        )
      ],
    );
  }

  Widget buildVideoItem() {
    return Container(
      color: Colors.green,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              _playerController!.value.aspectRatio > 1
                  ? Positioned(
                      width: constraints.maxWidth *
                          _playerController!.value.aspectRatio,
                      child: AspectRatio(
                        aspectRatio: _playerController!.value.aspectRatio,
                        child: VideoPlayer(_playerController!),
                      ),
                    )
                  : Positioned(
                      height: constraints.maxHeight /
                          _playerController!.value.aspectRatio,
                      child: AspectRatio(
                        aspectRatio: _playerController!.value.aspectRatio,
                        child: VideoPlayer(_playerController!),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
