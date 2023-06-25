import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/controllers/ad_controller.dart';
import 'package:health_app/controllers/analytic_controller.dart';
import 'package:health_app/controllers/become_visible_controller.dart';
import 'package:health_app/controllers/health_controller.dart';
import 'package:health_app/controllers/partners_controller.dart';
import 'package:health_app/ui/screens/loader_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_app/ui/screens/splash_screen.dart';

import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  injectDependency();
  runApp(const MyApp());
}
injectDependency(){
  final AuthController _authController = Get.put(AuthController());
  final UserController _userController =  Get.put(UserController());
  final BecomeVisibleController _becomeController =  Get.put(BecomeVisibleController());
  final PartnersController _partnersController = Get.put(PartnersController());
  final AdController _adController = Get.put(AdController());
  final HealthController _healthController = Get.put(HealthController());
  final AnalyticController _analyticController = Get.put(AnalyticController());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Путь к здоровью',
      theme: ThemeData(
        fontFamily: 'Comfortaa',
        primarySwatch: Colors.blue,
      ),
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen>{
  Widget screen  = SplashScreen();

  @override
  void initState() {
    setScreen();
    super.initState();
  }

  setScreen()async{
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      screen = LoaderScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return screen;
  }


  static Route createRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}


