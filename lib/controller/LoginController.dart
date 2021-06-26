import 'dart:convert';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:baideshikrojgar/models/SingleUser.dart';
import 'package:baideshikrojgar/models/User.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';

class LoginController extends GetxController {
  TextEditingController emailController;
  TextEditingController passwordController;
  String medium = 'normal';
  GoogleSignInAccount googleUser;
  FacebookLogin facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  SingleUser user = SingleUser();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool loggingIn = false, loggedIn = false;
  var setLoggedIn, setLoggingIn;
  LoginController({
    this.emailController,
    this.passwordController,
    this.setLoggedIn,
    this.setLoggingIn,
  });
  setEmail(String email) {
    this.user.user.email = email;
  }

  setPassword(String password) {
    this.user.user.password = password;
  }

  setMedium(String medium) {
    this.medium = medium;
  }

  setId(String id) {
    this.user.user.id = id;
  }

  setName(String name) {
    this.user.user.name = name;
  }

  GoogleSignIn getGoogleSignIn() {
    return this._googleSignIn;
  }

  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(Get.context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  login() async {
    this.loggingIn = true;
    switch (this.medium) {
      case 'normal':
        String e = this.emailController.text.trim();
        String p = this.passwordController.text.trim();
        this.setEmail(e);
        this.setPassword(p);
        this.setId('1');
        break;
      case 'facebook':
        await this.fbLogin();
        break;
      case 'google':
        await this.googleLogin();
        break;
      case 'apple':
        await this.appleLogin(scopes: [
          Scope.email,
          Scope.fullName,
        ]);
        break;

      case 'skiplogin':
        String deviceid = await _getId();
        this.setEmail(deviceid + '-demo@sajhajobs.com');
        this.setPassword('facebook_sajhajobs');
        this.setId(deviceid);
        this.setName('Demo User');
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
      "email": this.user.user.email,
      "password": this.user.user.password,
      "password_confirmation": this.user.user.password,
      "name": this.user.user.name,
      "type": this.medium,
      "user_id": this.user.user.id,
      "picture": this.user.user.picture
    };
    var res = await http
        .post(BASE_URL + '/auth/signup', body: jsonEncode(new_user), headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
    });
    var body = json.decode(res.body);
    if (body.containsKey('errors')) {
      this.loggedIn = false;
      this.loggingIn = false;
    } else {
      var res = await http.post(BASE_URL + '/auth/login',
          body: jsonEncode({
            'email': this.user.user.email,
            "password": this.user.user.password,
            "remember_me": true
          }),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
          });
      var body = json.decode(res.body);
      if (body.containsKey('errors')) {
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
        this.user = setSingleUserRawData(body);
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
    await this.facebookLogin.logOut();
    final result = await this.facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=picture.type(large),email,name&access_token=${token}');
        final profile = json.decode(graphResponse.body);
        var email = profile['email'];
        if (email == null) {
          email = '${profile['id']}.facebook@sajhajobs.com';
        }
        this.user.user.setEmail(email);
        this.user.user.setPicture(profile['picture']['data']['url']);
        this.user.user.setPassword('facebook_sajhajobs');
        this.user.user.setId(profile['id']);
        this.user.user.setName(profile['name']);
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
          desc: result.errorMessage,
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
      this.user.user.setEmail(this.googleUser.email);
      this.user.user.setPicture(this.googleUser.photoUrl);
      this.user.user.setPassword('gmail_sajhajobs');
      this.user.user.setId(this.googleUser.id);
      this.user.user.setName(this.googleUser.displayName);
    } catch (error) {
      AwesomeDialog(
        context: Get.context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Sorry, cannot login.',
        desc: error.toString(),
      )..show();
    }
  }

  appleLogin({List<Scope> scopes = const []}) async {
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.email)) {
          this.user.user.setEmail(appleIdCredential.email);
          this.user.user.setPicture('https://picsum.photos/200');
          this.user.user.setPassword('apple_sajhajobs');
          this.user.user.setId(appleIdCredential.email);
          final displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(displayName: displayName);
          this.user.user.setName(displayName);
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }
}
