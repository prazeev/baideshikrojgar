import 'dart:convert';
import 'dart:ui';

import 'package:baideshikrojgar/controller/LoginController.dart';
import 'package:baideshikrojgar/utlis/global/custom_shape.dart';
import 'package:baideshikrojgar/utlis/global/responsive_ui.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/utlis/global/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  bool _loggingIn = false, loggedIn = false;
  LoginController loginController = Get.find();
  GlobalKey<FormState> _key = GlobalKey();
  bool _rememberMe = true;
  bool hasSeenIntro = false;

  @override
  void initState() {
    super.initState();
  }

  setLogginIn(bool isLoggingIn) {
    this._loggingIn = isLoggingIn;
  }

  setLoggedIn(bool isLoggedIn) {
    this.loggedIn = isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.orange[200],
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 30,
              sigmaY: 30,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  clipShape(),
                  welcomeTextRow(),
                  signInTextRow(),
                  form(),
                  // forgetPassTextRow(),
                  SizedBox(
                    height: _height / 50,
                  ),
                  button(),
                  signUpTextRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
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
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
          child: Image.asset(
            'assets/images/logo.png',
            height: _height / 3.5,
            width: _width / 3.5,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          TextFormatted(
            text: "Welcome",
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          TextFormatted(
            text: "Sign in to your account",
            textStyle: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: loginController.emailController,
      icon: Icons.verified_user,
      hint: "Email",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: loginController.passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: "Password",
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormatted(
                text: "Forgot your password?",
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: _large ? 14 : (_medium ? 12 : 10)),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {},
                child: TextFormatted(
                  text: "Recover",
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormatted(
                text: "Already have token?",
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: _large ? 14 : (_medium ? 12 : 10)),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {},
                child: TextFormatted(
                  text: "Activate your account",
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: _loggingIn
          ? () {}
          : () {
              this.loginController.setMedium('normal');
              loginUser();
            },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: this.loggedIn
                ? <Color>[
                    Colors.green,
                    Colors.green,
                  ]
                : <Color>[
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor
                  ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: this.loggedIn
            ? Text("Logged In")
            : this._loggingIn
                ? Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : TextFormatted(
                    text: 'SIGN IN',
                    textStyle: TextStyle(
                      fontSize: _large ? 14 : (_medium ? 12 : 10),
                    ),
                  ),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Column(
        children: [
          TextFormatted(
            text: "OR SIGN IN USING",
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 14 : (_medium ? 12 : 10),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  this.loginController.setMedium('facebook');
                  this.loginUser();
                },
                child: Image(
                  image: AssetImage('assets/images/fblogo.png'),
                  height: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void loginUser() async {
    setState(() {
      _loggingIn = true;
    });
    bool status = await this.loginController.login();
    if (status == true) {
      Get.back();
    }
    setState(() {
      loggedIn = status;
      _loggingIn = false;
    });
  }
}
