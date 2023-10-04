import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:twofourseven/Core/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;

import '../../../AllWidgets/progressDialog.dart';
import '../../../Controller/profile_controller.dart';
import '../../../Data/Models/profile_model.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String status = "";

  @override
  void initState() {
    gpsCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
          children: [Container(),
            Image.asset("assets/logo.png", width: 200,),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width - 60,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Your Email",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            status == "login" ? SizedBox(height: 15,) : SizedBox(),
            status == "login" ? Container(
              width: MediaQuery.of(context).size.width - 60,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Your Password",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ) : SizedBox(),
            SizedBox(height: 30,),
            status == "checking" ? Center(child: CircularProgressIndicator(color: Colors.red,)) : status == "login" ? InkWell(
              onTap: () async {
                if(passwordController.text.length > 5){
                  await loginAndAuthenticateUser(context);
              }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Please Enter Valid Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)));
                }},
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text("LOGIN", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)),
              ),
            ) : InkWell(
              onTap: (){
                if(emailController.text.contains("@")){
                  checkuser();
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Please Enter Valid Email", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)));
                }
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text("CONTINUE", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  checkuser() async {
    setState(() {
      status = "checking";
    });

    ProfileModel.getProfileByEmail(emailController.text).first.then((value) async {
      value.length == 0 ? setSignUp() : setLogin();
    });
  }

  setSignUp(){
    setState(() {
      status = "";
    });
    Get.toNamed(AppRoutes.SIGNUP, arguments: emailController.text);
  }

  setLogin(){
    setState(() {
      status = "login";
    });
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Authenticating, Please wait...");
        });

    final User? firebaseuser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text)
        .catchError((errMsg) {
      print(errMsg.toString());
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Login Failed!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
        ),
      );
    }))
        .user;

    if (firebaseuser != null) {
      print("User is not null");
      try {
        ProfileModel profileModel =
        await ProfileModel.getProfileByUserId(uId: firebaseuser.uid);
        ProfileController.to.profile(profileModel);
      } on Exception catch (e) {
        print(e.toString());
      }
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.green,
      //     content: Text(
      //       "Login Successful!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
      //   ),
      // );
      Get.offAllNamed(AppRoutes.HOMESCREEN);
    } else {
      print("User is null");
    }
  }

  gpsCheck() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      Get.dialog(AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_off, color: Colors.red, size: 25,),
            Text(" Location is off", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),),
          ],
        ),
        content: Image.asset("assets/gpsoff.png", height: 150, width: 150,),
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
              child: Text("Enable  ", style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),)),
        ],
      ));
    }
    else{
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
