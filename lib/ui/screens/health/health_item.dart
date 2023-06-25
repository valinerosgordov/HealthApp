import 'package:flutter/material.dart';
import 'package:health_app/domain/data/health_data.dart';
import 'package:get/get.dart';
import 'package:health_app/other/other.dart';
import '../../../core/my_colors.dart';
import 'dart:ui';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HealthItem extends StatefulWidget {
  final HealthData healthData;

  HealthItem({required this.healthData});

  @override
  State<StatefulWidget> createState() => HealthItemState();
}

class HealthItemState extends State<HealthItem> {
  late VideoPlayerController _playerController;

  @override
  void initState() {
    if (widget.healthData.photo.contains('video')) {
      _playerController =
          VideoPlayerController.network(widget.healthData.photo);
      _playerController.initialize().whenComplete(() {
        _playerController.play();
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
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 60),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: buildContent()),
                Container(
                  margin: EdgeInsets.only(bottom: Get.width - 32 - 32),
                  child: buildHeader(),
                ),
              ],
            )
          ],
        ));
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
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      shape: BoxShape.rectangle),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDescription() {
    return Column(
      children: [
        Container(
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border.all(color: MyColors.green_016938),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5)
              ]),
          child: Column(
            children: [
              Container(
                width: Get.width,
                child: Text(widget.healthData.name,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildLink() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5)
            ]),
        margin: EdgeInsets.symmetric(horizontal: 24),
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
            Container(
              child: Text(
                'Перейти',
                style: TextStyle(fontSize: 16),
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
              if (widget.healthData.site.isEmpty) return;
              await launchInVC(Uri.parse(widget.healthData.site));
              //Get.to(WebScreen(url: widget.healthData.site));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                child: widget.healthData.photo.contains('health_photo')
                    ? CachedNetworkImage(
                        imageUrl: widget.healthData.photo,
                        height: Get.width - 32,
                        width: Get.width,
                        fit: BoxFit.fill,
                      )
                    : buildVideoItem(),
              ),
            ))
      ],
    );
  }

  Widget buildVideoItem() {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: Get.width * 0.2,
                        height: Get.width * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Positioned(
                          width: _playerController.value.aspectRatio > 1
                              ? constraints.maxHeight *
                                  (_playerController.value.aspectRatio)
                              : constraints.maxHeight *
                                  (_playerController.value.aspectRatio + 1),
                          child: AspectRatio(
                            aspectRatio: _playerController.value.aspectRatio,
                            child: VideoPlayer(_playerController),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
