class User {
  String email;
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
  }

  setMobileNumber(String number) {
    this.mobilenumber = number;
  }

  setName(String name) {
    this.name = name;
  }

  setPicture(String pic) {
    this.picture = pic;
  }
}
