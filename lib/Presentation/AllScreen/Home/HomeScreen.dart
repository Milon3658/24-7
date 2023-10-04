import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:twofourseven/Controller/profile_controller.dart';
import 'package:twofourseven/Core/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'package:twofourseven/Data/Models/RequestModel.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String latlng = "";

  @override
  void initState() {
    ProfileController.to.profile();
    gpsCheck();
    getLatLong();
    fcmSubscribe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseMessaging.instance.unsubscribeFromTopic(
                    "${ProfileController.to.profile.value!.zone.toString() + ProfileController.to.profile.value!.type.toString()}");
                FirebaseAuth.instance.signOut();
                Get.offAllNamed(AppRoutes.LOGINPAGE);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Center(
          child: Text(
            "24/7",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ProfileController.to.profile.value!.type == "Team"
          ?
          //Rescue Team UI
          SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Text(
                      "Emergency Resquests:",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<List<RequestModel>>(
                        builder: (context,
                            AsyncSnapshot<List<RequestModel>> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 18.0),
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                RequestModel requests = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 25),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Time: " +
                                                requests.time.split(".").first,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            "Spot Details:",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Zone: " + requests.zone,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Address: " + requests.address,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            "Requester Details:",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Name: " + requests.name,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Phone: " + requests.phone,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Emqil: " + requests.email,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    launchUrl(
                                                        Uri.parse(
                                                            "https://maps.google.com/?q=${requests.latlng}"),
                                                        mode: LaunchMode
                                                            .externalNonBrowserApplication);
                                                  },
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Colors.white,
                                                    size: 40,
                                                  )),
                                              InkWell(
                                                  onTap: () {
                                                    launchUrl(Uri.parse(
                                                        "tel: ${requests.phone}"));
                                                  },
                                                  child: Icon(
                                                    Icons.phone_in_talk,
                                                    color: Colors.white,
                                                    size: 40,
                                                  )),
                                              InkWell(
                                                  onTap: () {
                                                    //confirm dialog
                                                    Get.dialog(AlertDialog(
                                                      title: Text(
                                                          "Problem Solved?"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                        TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              requests.delete();
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                      ],
                                                    ));
                                                  },
                                                  child: Icon(
                                                    Icons.task_alt,
                                                    color: Colors.white,
                                                    size: 40,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data?.length ?? 0,
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                        stream: RequestModel.getRequests()),
                  ],
                ),
              ),
            )

          //User UI
          : Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(),
                  InkWell(
                      onLongPress: () {
                        RequestModel requestModel = RequestModel(
                          name: ProfileController.to.profile.value!.name,
                          email: ProfileController.to.profile.value!.email,
                          phone: ProfileController.to.profile.value!.phone,
                          address: ProfileController.to.profile.value!.address
                              .toString(),
                          latlng: latlng,
                          time: DateTime.now().toString(),
                          zone: ProfileController.to.profile.value!.zone
                              .toString(),
                        );
                        requestModel.save();

                        sendPushMessage(
                            "Emergency Request",
                            "${ProfileController.to.profile.value!.name} is requesting to help them.",
                            "${ProfileController.to.profile.value!.zone.toString()}Team");
                        Get.snackbar(
                          "Request Sent",
                          "Rescue team will be there soon",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          margin: EdgeInsets.all(10),
                          borderRadius: 10,
                          duration: Duration(seconds: 3),
                          isDismissible: true,
                          forwardAnimationCurve: Curves.easeOutBack,
                        );
                      },
                      child: Image.asset(
                        "assets/button.png",
                        width: 200,
                      )),
                  SizedBox(height: 30.0),
                  Text(
                    "In case of emergency,\nPress & Hold the button",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
    );
  }

  sendPushMessage(String title, String body, String topic) async {
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "key=AAAAfWdMv_c:APA91bFSuSKv-HepUAPrklQdGZGlDYmwlBlVka9HQDA8lrI8I-keprDtP7vmtceBX0fV_OVWSiZNN-31pO7_V0mRaNH1aAFUo-fTxqmtJGW7vEG9bijeW1ratW-QbBseGYtFIPOFIE26"
            },
            body: jsonEncode({
              "to": "/topics/$topic",
              "notification": {
                "title": title,
                "body": body,
                "mutable_content": true,
                // "image": product.image,
                "sound": "default",
                "priority": "high",
              },
              "data": {
                // "url": "<url of media image>",
                // "dl": "<deeplink action on tap of notification>"
              }
            }));
    print(response.body);
  }

  fcmSubscribe() async {
    await Future.delayed(Duration(milliseconds: 3000));
    FirebaseMessaging.instance.subscribeToTopic('all');
    FirebaseMessaging.instance.subscribeToTopic(
        "${ProfileController.to.profile.value!.zone.toString() + ProfileController.to.profile.value!.type.toString()}");
  }

  getLatLong() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;
      setState(() {
        latlng = "$latitude, $longitude";
      });

      print('Latitude: $latitude, Longitude: $longitude');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  gpsCheck() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      Get.dialog(AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.red,
              size: 25,
            ),
            Text(
              " Location is off",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Image.asset(
          "assets/gpsoff.png",
          height: 150,
          width: 150,
        ),
        actions: [
          // TextButton(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     child: Text("Cancel", style: TextStyle(color: buttonColor, fontSize: 16, fontWeight: FontWeight.bold),)),
          TextButton(
              onPressed: () {
                Get.back();
                Geolocator.openLocationSettings();
              },
              child: Text(
                "Enable  ",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ));
    } else {
      bool _serviceEnabled;
      loc.PermissionStatus _permissionGranted;
      loc.LocationData _locationData;

      _serviceEnabled = await loc.Location().serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await loc.Location().requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await loc.Location().hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await loc.Location().requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          return;
        }
      }
    }
  }
}
