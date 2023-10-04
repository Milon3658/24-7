import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Controller/profile_controller.dart';
import 'Core/AppRoutes.dart';
import 'Data/Models/profile_model.dart';
import 'notificationService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  Get.lazyPut(() => ProfileController());
  storeUserData();
  runApp(MyApp());
}

void storeUserData() async {
  if (FirebaseAuth.instance.currentUser != null) {
    var profile = await ProfileModel.getProfileByUserId(
        uId: FirebaseAuth.instance.currentUser!.uid);
    ProfileController.to.profile(profile);
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {

    super.initState();
    NotificationService.init();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("FirebaseMessaging.getInitialMessage");
      if (message != null) {
        // message.notification!.title.toString().contains("Order") ? Get.toNamed(AppRoutes.ORDERHISTORY) : Get.toNamed(AppRoutes.NOTIFICATIONPAGE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '24/7',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)),
      initialRoute: FirebaseAuth.instance.currentUser == null ? AppRoutes.LOGINPAGE : AppRoutes.HOMESCREEN,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
