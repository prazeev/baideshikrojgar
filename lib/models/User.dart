import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String email;
  String displayemail;
  String name;
  String token;
  String password;
  String id;
  int fbid = 0;
  String medium = 'normal';
  String picture = '';
  String bio = '-';
  String passportno = '';
  String passportexpiry = '';
  String temporaryaddress = '';
  String permanentaddress = '';
  String birthdate = '';
  String mobilenumber = '';
  String height = '';
  String weight = '';
  String fathersname = '';
  String nationality = '';
  String maritualstatus = '';
  int gender = 1;
  String religion = '';
  List countriesworkedbefore = [];
  List<dynamic> interestedcountrytowork = [];
  List<dynamic> interestedpositiontowork = [];
  List experiences = [];
  List trainings = [];
  List educations = [];
  List languages = [];
  bool activelylookingforjob = false;
  User({
    this.email,
    this.displayemail,
    this.name,
    this.token,
    this.id,
    this.fbid,
    this.medium,
    this.password,
    this.picture,
    this.bio,
    this.passportexpiry,
    this.passportno,
    this.temporaryaddress,
    this.permanentaddress,
    this.birthdate,
    this.mobilenumber,
    this.height,
    this.weight,
    this.fathersname,
    this.nationality,
    this.maritualstatus,
    this.gender,
    this.countriesworkedbefore,
    this.interestedcountrytowork,
    this.activelylookingforjob,
    this.interestedpositiontowork,
    this.religion,
    this.educations,
    this.experiences,
    this.languages,
    this.trainings,
  });
  setToken(String token) {
    this.token = token;
  }

  setEmail(String email) {
    this.email = email;
  }

  setTemporaryAddress(String address) {
    this.temporaryaddress = address;
    this.updateUserProfileAttributeDatabase('temporary_address', address);
  }

  setPassword(String pass) {
    this.password = pass;
  }

  setId(String id) {
    this.id = id;
  }

  setDisplayEmail(String displayemail) {
    this.displayemail = displayemail;
    this.updateUserAttributeDatabase('display_email', displayemail);
  }

  setMobileNumber(String number) {
    this.mobilenumber = number;
    this.updateUserProfileAttributeDatabase('mobile_number', number);
  }

  setName(String name) {
    this.name = name;
    this.updateUserAttributeDatabase('name', name);
  }

  setPicture(String pic) {
    this.picture = pic;
    this.updateUserAttributeDatabase('main_image', pic);
  }

  updateUserAttributeDatabase(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      dynamic body = jsonDecode(prefs.getString('user'));
      body['user'][key] = value;
      await prefs.setString(key, body.toString());
    }
  }

  updateUserProfileAttributeDatabase(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      dynamic body = jsonDecode(prefs.getString('user'));
      body['user']['profile'][key] = value;
      await prefs.setString(key, body.toString());
    }
  }
}
