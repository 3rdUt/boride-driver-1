import 'dart:async';

import 'package:boride_driver/authentication/doc_upload.dart';
import 'package:boride_driver/authentication/login_screen.dart';
import 'package:boride_driver/global/global.dart';
import 'package:boride_driver/mainScreens/main_screen.dart';
import 'package:boride_driver/splashScreen/retry_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool hasInternet = false;
  bool hasCompletedRegistration = false;

  startTimer() async {
    Timer(const Duration(seconds: 3), () async {
      if (fAuth.currentUser != null) {
        await checkRegistrationStatus();
        if (hasCompletedRegistration) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => const MainScreen()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => const Upload()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      }
    });
  }

  checkInternetAccess() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    if (!hasInternet) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const RetryPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/boridedriver_logo.png",
                width: MediaQuery.of(context).size.width * 0.5,
              )
            ],
          ),
        ),
      ),
    );
  }

  checkRegistrationStatus() async {
    await FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("driver_photo")
        .once()
        .then((value) {
      if (value.snapshot.value != null) {
        setState(() {
          hasCompletedRegistration = true;
        });
      }
    });
  }
}
