import 'package:twofourseven/Presentation/AllScreen/Auth/LoginPage.dart';
import 'package:twofourseven/Presentation/AllScreen/Auth/SignUp.dart';
import 'package:twofourseven/Presentation/AllScreen/Home/HomeScreen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../Presentation/AllScreen/MainScreen.dart';
class AppRoutes {
  static const String INITAL = "/";
  static const String MAINSCREEN = "/mainscreen";
  static const String HOMESCREEN = "/homescreen";
  static const String LOGINPAGE = "/lginpage";
  static const String SIGNUP = "/signup";

  static List<GetPage> routes = [
    GetPage(
        name: MAINSCREEN,
        page: () => MainScreen(),
        transitionDuration: Duration(milliseconds: 100),
        transition: Transition.cupertino),
    GetPage(
        name: HOMESCREEN,
        page: () => HomeScreen(),
        transitionDuration: Duration(milliseconds: 100),
        transition: Transition.cupertino),
    GetPage(
        name: SIGNUP,
        page: () => SignUp(),
        transitionDuration: Duration(milliseconds: 100),
        transition: Transition.cupertino),
    GetPage(
        name: LOGINPAGE,
        page: () => LoginPage(),
        transitionDuration: Duration(milliseconds: 100),
        transition: Transition.cupertino),

  ];
}
