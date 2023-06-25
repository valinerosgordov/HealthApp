import 'package:flutter/material.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:health_app/ui/screens/camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

class PermissionHandlerScreen extends StatefulWidget {
  @override
  _PermissionHandlerScreenState createState() =>
      _PermissionHandlerScreenState();
}

class _PermissionHandlerScreenState extends State<PermissionHandlerScreen> {
  @override
  void initState() {
    super.initState();
    permissionServiceCall();
  }

  permissionServiceCall() async {
    await permissionServices().then(
      (value) async {
        if (value != null) {
          if (value.containsKey(Permission.camera) &&
              value[Permission.camera]!.isGranted) {
            final cameras = await availableCameras();
            final firstCamera = cameras.first;

            await Permission.camera.request();
            var status = await Permission.camera.status;
            if (status.isGranted || status.isLimited) {
              Get.to(CameraApp());//camera: firstCamera
            }
          }
        }
      },
    );
  }

  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();

    if (statuses.containsKey(Permission.camera) &&
        statuses[Permission.camera]!.isPermanentlyDenied) {
      openAppSettings();
    } else {
      if (statuses.containsKey(Permission.camera) &&
          statuses[Permission.camera]!.isDenied) {
        permissionServiceCall();
      }
    }
    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_outlined,
              color: MyColors.green_016938,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(18),
          child: Center(
            child: InkWell(
              onTap: () {
                permissionServiceCall();
              },
              child: Text(
                "Нажмите здесь, чтобы «Включить разрешения»",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
