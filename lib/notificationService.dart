import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'Core/AppRoutes.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      prefs.setBool('notification', true);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
      prefs.setBool('notification', true);
    } else {
      log('User declined or has not accepted permission');
      prefs.setBool('notification', false);
    }
    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    setupFirebaseMessagingListeners();
  }

  static setupFirebaseMessagingListeners() {
    FirebaseMessaging.onMessageOpenedApp.listen(onOpenedApp);
    FirebaseMessaging.onBackgroundMessage(onOpenedApp);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification!.title);
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');
      if (message.notification != null && Platform.isAndroid) {
        log('Message also contained a notification: ${message.notification}');
        showDialog(
          barrierDismissible: true,
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                height: 250,
                child: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          message.notification!.title!.contains("Order") ? Icons.local_mall : Icons.notifications,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        message.notification!.title!.contains("Order Placed") ? "All Done !!" : message.notification!.title!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        message.notification!.body ?? '',
                        style: TextStyle(
                          color: Color(0xff454545),
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if(message.notification!.title.toString().contains("Order")){
                              Get.back();
                              // Get.to(() => Order);
                            }
                            else{
                              Get.back();
                              // Get.toNamed(AppRoutes.NOTIFICATIONPAGE);
                            }
                            // message.notification!.title == "A new SALE is here!" ? Get.toNamed(AppRoutes.NOTIFICATION) :  Get.toNamed(AppRoutes.CHATALL);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }

  static Future<void> onOpenedApp(RemoteMessage message) async {
    log('A new onMessageOpenedApp event was published!');
    log('Message data: ${message.data}');

    print(message.notification!.title);
    NotificationService._handleChatNotification(message);
  }

  static _handleChatNotification(message) async {
    print("shahedshahed");
    // onOpenedApp(message);
    // await Future.delayed(Duration(seconds: 1));

    print(message.notification!.title);
    // message.notification!.title == "Hey, a new product added!" ? Get.toNamed(AppRoutes.NOTIFICATION) :  Get.toNamed(AppRoutes.CHATALL);
  }
}