import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';
import 'Home/HomeScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    _checkVersion();
    super.initState();
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "net.carboncodes.bornobangla",
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status!,
      dialogTitle: "Update Available",
      dismissButtonText: "Skip",
      dialogText: "You're missing out something!",
      dismissAction: () {
        Get.back();
      },
      updateButtonText: "Update Now",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: context.width > 550
            ? BoxDecoration(
                border:
                    Border.all(width: 2, color: Colors.grey.withOpacity(0.35)))
            : null,
        width: context.width > 550 ? 550 : double.infinity,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.green,
            onTap: (index) {
              pageController.jumpToPage(index);
              setState(() {
                currentIndex = index;
              });
              // pageController.animateToPage(index, duration: Duration(seconds: 0), curve: Curves.ease);
            },
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
            ],
          ),
          body: PageView(
            controller: pageController,
            children: [
              HomeScreen(),
              HomeScreen(),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
