import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:baideshikrojgar/controller/LoginController.dart';
import 'package:baideshikrojgar/models/User.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/custom_shape.dart';
import 'package:baideshikrojgar/utlis/global/responsive_ui.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/utlis/global/textformfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Get.put(
      LoginController(
        emailController: TextEditingController(),
        passwordController: TextEditingController(),
      ),
    );
    return SignInScreen();
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  int _current = 0;
  bool _loggingInFacebook = false, _loggingInGoogle = false, loggedIn = false;
  LoginController loginController = Get.find();
  GlobalKey<FormState> _key = GlobalKey();
  bool hasSeenIntro = false;
  List loginSliderItems = [
    {
      "image": {
        "data": "assets/images/log 1.png",
        "type": "assets",
      },
      "text":
          "वैधानिक बाटोबाट वैदेशिक रोजगारमा जानुहोस्, देशको विकासमा योगदान गर्नुहोस् "
    },
    {
      "image": {
        "data": "assets/images/log 2.png",
        "type": "assets",
      },
      "text":
          "वैदेशिक रोजगारमा पठाउने म्यानपावर एजेन्सीहरुसँग सहजै जोडिनुहोस्, रोजगारको प्रक्रिया सुरु गर्नुहोस्"
    },
    {
      "image": {
        "data": "assets/images/log 3.png",
        "type": "assets",
      },
      "text":
          "स्वदेशमा रहँदा देखि वैदेशिक रोजगारबाट फर्कँदाका सबै तथ्यपूर्ण सूचनाहरु एकै एपमा पाईराख्नुहोस्"
    },
    {
      "image": {
        "data": "assets/images/log 4.png",
        "type": "assets",
      },
      "text":
          "वैदेशिक रोजगार सम्बन्धि सम्पूर्ण जानकारीहरु पाउनुहोस्, रोजगारदाता खोज्नुहोस, कामदार खोज्नुहोस् "
    },
    {
      "image": {
        "data": "assets/images/log 5.png",
        "type": "assets",
      },
      "text":
          "मोबाइल एपबाट वैदेशिक रोजगारको सम्पूर्ण जानकारी लिनुहोस्, गुनाशो गर्नुहोस्, समाचारहरु पढ्नुहोस् "
    },
  ];
  bool skipLogin = true;
  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ClipRect(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  clipShape(),
                  CarouselSlider.builder(
                    itemCount: loginSliderItems.length,
                    itemBuilder: (BuildContext context, int itemIndex, int i) {
                      dynamic item = loginSliderItems[itemIndex];
                      return Container(
                        child: Column(
                          children: [
                            item['image']['type'] == 'assets'
                                ? Image(
                                    image: AssetImage(item['image']['data']),
                                    height: 120,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: item['image']['data'],
                                    height: 120,
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormatted(
                              text: item['text'],
                              maxline: 100,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                        height: 400,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: loginSliderItems.map((item) {
                      int index = loginSliderItems.indexOf(item);
                      return Container(
                        width: _current == index ? 12.0 : 8.0,
                        height: _current == index ? 12.0 : 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).secondaryHeaderColor,
                        ),
                      );
                    }).toList(),
                  ),
                  _loggingInFacebook
                      ? SignInButton(
                          Buttons.Facebook,
                          text: "Signing in process...",
                          onPressed: () async {},
                        )
                      : SignInButton(
                          Buttons.Facebook,
                          text: "Sign in with facebook",
                          onPressed: () async {
                            setState(() {
                              _loggingInFacebook = true;
                            });
                            loginController.setMedium('facebook');
                            await this.login();
                            setState(() {
                              _loggingInFacebook = false;
                            });
                          },
                        ),
                  _loggingInGoogle
                      ? SignInButton(
                          Buttons.Google,
                          text: "Signing in process...",
                          onPressed: () async {},
                        )
                      : SignInButton(
                          Buttons.Google,
                          text: "Sign in with google",
                          onPressed: () async {
                            setState(() {
                              _loggingInGoogle = true;
                            });
                            loginController.setMedium('google');
                            await this.login();
                            setState(() {
                              _loggingInGoogle = false;
                            });
                          },
                        ),
                  FlatButton(
                    onPressed: () {
                      this.loginController.setMedium('skiplogin');
                      login(loginText: "Logging with demo account...");
                    },
                    child: TextFormatted(
                      text: "Skip & use demo",
                      textStyle: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).secondaryHeaderColor,
                  ],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).secondaryHeaderColor
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  login({String loginText = 'Signing in...'}) async {
    EasyLoading.show(status: loginText);
    bool status = await this.loginController.login();
    EasyLoading.dismiss();
    if (status == true) {
      Timer(Duration(seconds: 3), () {
        Get.offAllNamed(
          HOME_PAGE,
          arguments: this.loginController.user,
        );
      });
    }
  }
}
