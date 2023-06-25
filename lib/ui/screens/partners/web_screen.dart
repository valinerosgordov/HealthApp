// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:get/get.dart';
//
// import '../../../core/my_colors.dart';
//
// class WebScreen extends StatefulWidget{
//   final String url;
//   WebScreen({required this.url});
//   @override
//   State<StatefulWidget> createState() => WebScreenState();
//
// }
//
// class WebScreenState extends State<WebScreen> {
//   final WebViewController controller = WebViewController();
//
//   @override
//   void initState() {
//     try{
//       controller
//         ..setJavaScriptMode(JavaScriptMode.unrestricted)
//         ..loadRequest(Uri.parse(widget.url));
//     }catch (e){
//      Future.delayed(Duration(seconds: 2)).then((value) {
//        Get.snackbar("Ошибка", "Ссылка недоступна");
//      });
//     }
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         SizedBox(height: Get.height,
//           child: WebViewWidget(
//             controller: controller,),),
//         GestureDetector(onTap: () {
//           Get.back();
//         },
//             child: Container(
//               alignment: Alignment.center,
//               width: Get.width,
//               height: Get.width * 0.15,
//               color: MyColors.green_016938,
//               child: Text('Назад',
//                 style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white
//                 ),),))
//
//       ],
//     ),);
//   }
// }