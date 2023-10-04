import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:twofourseven/Core/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../../AllWidgets/progressDialog.dart';
import '../../../Controller/profile_controller.dart';
import '../../../Data/Models/profile_model.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String email = Get.arguments;
  String userType = "Customer";
  String zone = "Barasat";

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      emailController.text = email;
    });
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
        child: Column(
          children: [
            Container(height: MediaQuery.of(context).padding.top, color: Colors.transparent,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png", width: 200,),
                    SizedBox(height: 20,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width - 60)/2,
                          height: 50,
                          decoration: BoxDecoration(
                            color: userType == "Customer" ? Colors.red : Colors.transparent,
                            border: Border.all(color: Colors.red, width: 1.5),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                          ),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                userType = "Customer";
                              });
                            },
                            child: Center(child: Text("User", textAlign: TextAlign.center, style: TextStyle(color: userType == "Customer" ? Colors.white : Colors.red, fontWeight: FontWeight.bold, fontSize: 16),)),
                          ),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width - 60)/2,
                          height: 50,
                          decoration: BoxDecoration(
                            color: userType == "Team" ? Colors.red : Colors.transparent,
                            border: Border.all(color: Colors.red, width: 1.5),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                          ),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                userType = "Team";
                              });
                            },
                            child: Center(child: Text("Rescue Team", textAlign: TextAlign.center, style: TextStyle(color: userType == "Team" ? Colors.white : Colors.red, fontWeight: FontWeight.bold, fontSize: 16),)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
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
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Your Name",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
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
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Your Phone",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
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
                        controller: addressController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Your Address",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: zone,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 28,
                            elevation: 16,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                            onChanged: (String? newValue) {
                              setState(() {
                                zone = newValue!;
                              });
                            },
                            items: <String>['Barasat', 'Madhyamgram', 'Kolkata', 'Dumdum', 'Rajarhat', 'New Town', 'Salt Lake', 'Howrah', 'Hooghly', 'Barrackpore', 'Bongaon', 'Basirhat', 'Diamond Harbour', 'Bishnupur', 'Burdwan', 'Asansol', 'Durgapur', 'Bolpur', 'Siliguri', 'Darjeeling', 'Kalimpong', 'Cooch Behar', 'Alipurduar', 'Jalpaiguri', 'Malda', 'Raiganj', 'Balurghat', 'Bankura', 'Purulia', 'Jhargram', 'Medinipur', 'Kharagpur', 'Haldia', 'Tamluk', 'Krishnanagar', 'Berhampore', 'Murshidabad', 'Rampurhat', 'Suri', 'Jangipur', 'Baharampur', 'Kalyani', 'Serampore', 'Chandannagar', 'Bardhaman', 'Gangtok', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                value: value,
                                child: Center(child: Text(value, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
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
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter New Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
                    InkWell(
                      onTap: (){
                        if(nameController.text.isNotEmpty && phoneController.text.isNotEmpty && addressController.text.isNotEmpty && passwordController.text.length >= 6){
                          registerNewUser(context);
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Please Enter All Information", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)));
                        }},
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.red, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("Sign Up", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Creating Account, Please wait...");
        });

    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) //user created
          {

        var profile = ProfileModel(
          id: firebaseUser.uid,
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          address: addressController.text,
          zone: zone,
          type: userType,
        )..save();
        ProfileController.to.profile(profile);

        Get.offAllNamed(AppRoutes.HOMESCREEN);
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Request Failed", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      String errorMessage = "Request Failed!";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "Email already used!";
            break;
        // Handle other Firebase authentication error codes here as needed.
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
    }
  }
}
