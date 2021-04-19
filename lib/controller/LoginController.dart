import 'dart:convert';

import 'package:baideshikrojgar/models/User.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailController;
  TextEditingController passwordController;
  String medium = 'normal';
  GoogleSignInAccount googleUser;
  FacebookLogin facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  User user = User();
  bool loggingIn = false, loggedIn = false;
  var setLoggedIn, setLoggingIn;
  LoginController({
    this.emailController,
    this.passwordController,
    this.setLoggedIn,
    this.setLoggingIn,
  });
  setEmail(String email) {
    this.user.email = email;
  }

  setPassword(String password) {
    this.user.password = password;
  }

  setMedium(String medium) {
    this.medium = medium;
  }

  GoogleSignIn getGoogleSignIn() {
    return this._googleSignIn;
  }

  login() async {
    this.loggingIn = true;
    switch (this.medium) {
      case 'normal':
        String e = this.emailController.text.trim();
        String p = this.passwordController.text.trim();
        this.setEmail(e);
        this.setPassword(p);
        break;
      case 'facebook':
        await this.fbLogin();
        break;
      case 'google':
        await this.googleLogin();
        break;
      default:
        AwesomeDialog(
          context: Get.context,
          borderSide: BorderSide(color: Colors.green, width: 2),
          width: 280,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
          headerAnimationLoop: false,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error',
          desc: 'Invalid type',
          showCloseIcon: true,
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        )..show();
    }
    var new_user = {
      "email": this.user.email,
      "password": this.user.password,
      "password_confirmation": this.user.password,
      "name": this.user.name,
      "type": this.medium,
      "user_id": this.user.id,
      "picture": this.user.picture
    };
    var res = await http
        .post(BASE_URL + '/auth/signup', body: jsonEncode(new_user), headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
    });
    var body = json.decode(res.body);
    if (body['errors'] ?? false) {
      this.loggedIn = false;
      this.loggingIn = false;
    } else {
      var res = await http.post(BASE_URL + '/auth/login',
          body: jsonEncode({
            'email': this.user.email,
            "password": this.user.password,
            "remember_me": true
          }),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
          });
      var body = json.decode(res.body);
      if (body['errors'] ?? false) {
        this.loggedIn = false;
        this.loggingIn = false;
        AwesomeDialog(
          context: Get.context,
          title: "Error",
          dialogType: DialogType.ERROR,
          desc: "Sorry, cannot login to system.",
        )..show();
      } else {
        this.loggedIn = true;
        this.loggingIn = false;
        this.user = User(
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
          fathersname:
              body['user']['profile']['father_name'] ?? "Not Specified",
          gender: body['user']['profile']['gender'] ?? "Not Specified",
          nationality:
              body['user']['profile']['nationality'] ?? "Not Specified",
          maritualstatus:
              body['user']['profile']['marital_status'] ?? "Not Specified",
          educations: body['user']['educations'],
          trainings: body['user']['trainings'],
          experiences: body['user']['experiences'],
          languages: body['user']['languages'],
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(body));
        await prefs.setBool('isLoggedIn', true);
        AwesomeDialog(
          context: Get.context,
          title: "Done",
          dialogType: DialogType.SUCCES,
          desc: "You are logged in.",
        )..show();
      }
    }
    return this.loggedIn;
  }

  fbLogin() async {
    final result = await this.facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=picture.type(large),email,name&access_token=${token}');
        final profile = json.decode(graphResponse.body);
        var email = profile['email'];
        if (email == '') {
          email = '${profile['id']}@sajhajobs.com';
        }
        this.user = User(
          email: email,
          picture: profile['picture']['data']['url'],
          password: 'facebook_sajhajobs',
          id: profile['id'],
          name: profile['name'],
        );
        break;
      case FacebookLoginStatus.cancelledByUser:
        this.loggedIn = false;
        this.loggingIn = false;
        AwesomeDialog(
          context: Get.context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Sorry, cannot login.',
          desc: 'You have cancelled the login.',
        )..show();
        break;
      case FacebookLoginStatus.error:
        this.loggedIn = false;
        this.loggingIn = false;
        AwesomeDialog(
          context: Get.context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Sorry, cannot login.',
          desc: 'Some internal error occured.',
        )..show();
        break;
      default:
        this.loggedIn = false;
        this.loggingIn = false;
    }
  }

  googleLogin() async {
    try {
      this.googleUser = await _googleSignIn.signIn();
      print(
        "Email: " + this.googleUser.toString(),
      );
      if (googleUser != null) {
        this.setEmail(googleUser.email);
        this.setPassword('gmail_sajhajobs');
      }
    } catch (error) {
      print("bashu" + error.toString());
    }
  }
}
