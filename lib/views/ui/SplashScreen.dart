import 'dart:async';
import 'dart:convert';

import 'package:baideshikrojgar/models/User.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      dynamic body = jsonDecode(prefs.getString('user'));
      User user = User(
        token: body['access_token'],
        email: body['user']['email'],
        name: body['user']['name'],
        picture: body['user']['main_image'],
        bio: body['user']['profile']['career_objective'],
        passportno: body['user']['profile']['passport_no'],
        passportexpiry: body['user']['profile']['passport_expiry'],
        birthdate: body['user']['profile']['dob'],
        permanentaddress:
            body['user']['profile']['permanent_address'] ?? "Not Specified",
        temporaryaddress:
            body['user']['profile']['temporary_address'] ?? "Not Specified",
        mobilenumber:
            body['user']['profile']['mobile_number'] ?? "Not Specified",
        height: body['user']['profile']['height'] ?? "Not Specified",
        weight: body['user']['profile']['weight'] ?? "Not Specified",
        religion: body['user']['profile']['religion'] ?? "Not Specified",
        fathersname: body['user']['profile']['father_name'] ?? "Not Specified",
        gender: body['user']['profile']['gender'] ?? "Not Specified",
        nationality: body['user']['profile']['nationality'] ?? "Not Specified",
        maritualstatus:
            body['user']['profile']['marital_status'] ?? "Not Specified",
        educations: body['user']['educations'],
        trainings: body['user']['trainings'],
        experiences: body['user']['experiences'],
        languages: body['user']['languages'],
      );
      Get.offAllNamed(
        HOME_PAGE,
        arguments: user,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(LOGIN_PAGE);
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
