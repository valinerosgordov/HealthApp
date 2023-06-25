import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appinio_video_player/appinio_video_player.dart';


class VideoItem extends StatefulWidget {
  final String data;

  VideoItem({required this.data});

  @override
  State<StatefulWidget> createState() => VideoItemState();
}

class VideoItemState extends State<VideoItem> {
  late VideoPlayerController _playerController;

  @override
  void initState() {
    print(widget.data);
    _playerController = VideoPlayerController.network(widget.data);
    _playerController.initialize().whenComplete(() {
      _playerController.play();
      if (mounted) {
        setState(() {});
      }
    }).catchError((e) {
      print(e);
    });

    super.initState();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: Get.width,
            height: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: VideoPlayer(
                  _playerController,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
