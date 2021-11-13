import 'package:baideshikrojgar/models/SingleUser.dart';
import 'package:baideshikrojgar/models/User.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

const MONTHS = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec',
];
const DAYS = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday'
];

getFirstImage(images) {
  if (images == null) {
    return BASE_URL_FULL + "img/default.png";
  }
  if (images.length == 0) {
    return BASE_URL_FULL + "img/default.png";
  }
  for (dynamic image in images) {
    return BASE_URL_FULL + image['image'];
  }
  return images;
}

getImageFromString(String string) {
  RegExp regExp = new RegExp(r'<img[^>]+src="https:\/\/([^">]+)');
  Iterable<RegExpMatch> matches = regExp.allMatches(string);
  if (matches.length == 0) {
    return getFirstImage(null);
  }
  for (RegExpMatch match in matches) {
    return "https://" + match.group(1);
  }
}

getTimeFormatted(String time, {bool jsontype = false}) {
  Duration diff = DateTime.now().difference(DateTime.parse(time));
  Map json = {};
  json['isAfter'] = diff.isNegative;
  json['isCommingSoon'] = false;
  if (json['isAfter']) {
    Duration diff = DateTime.parse(time).difference(DateTime.now());
    if (diff.inDays >= 30) {
      json['string'] = 'after ${diff.inDays % 30} months(s)';
    } else if (diff.inDays >= 1) {
      json['string'] = 'after ${diff.inDays} day(s)';
    } else if (diff.inHours >= 1) {
      json['string'] = 'after ${diff.inHours} hour(s)';
    } else if (diff.inMinutes >= 1) {
      json['string'] = 'after ${diff.inMinutes} minute(s)';
    } else if (diff.inSeconds >= 1) {
      json['string'] = 'after ${diff.inSeconds} second(s)';
    } else {
      json['string'] = 'after few seconds';
    }

    if (diff.inDays <= 5) {
      json['isCommingSoon'] = true;
    }
  } else {
    if (diff.inDays >= 30) {
      json['string'] = ' ${diff.inDays % 30} month(s) ago';
    } else if (diff.inDays >= 1) {
      json['string'] = ' ${diff.inDays} day(s) ago';
    } else if (diff.inHours >= 1) {
      json['string'] = ' ${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes >= 1) {
      json['string'] = ' ${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1) {
      json['string'] = ' ${diff.inSeconds} second(s) ago';
    } else {
      json['string'] = 'few seconds ago';
    }
  }

  if (jsontype) {
    return json;
  }
  return json['string'];
}

launchMap({String lat = "47.6", String long = "-122.3"}) async {
  final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

getYesNoLabel(int i) {
  if (i == 0) {
    return 'No';
  } else {
    return 'Yes';
  }
}

getNiceDate(String date) {
  DateTime dateTime = DateTime.parse(date);

  return dateTime.day.toString() +
      ' ' +
      MONTHS[dateTime.month - 1].toString() +
      ', ' +
      dateTime.year.toString();
}

getTimeInSeconds(String date) {
  DateTime dateTime = DateTime.parse(date);
  return dateTime.millisecondsSinceEpoch + 1000 * 30;
}

getMinimumQualification(qualify) {
  switch (qualify) {
    case 0:
      return "Under SLC";
    case 1:
      return "SLC Passed";
    case 3:
      return "+2/ Higher Secondary";
    case 4:
      return "Bachelors";
    case 5:
      return "Masters";
    default:
      return "SLC Passed";
  }
}

SingleUser setSingleUserRawData(dynamic body) {
  SingleUser singleUser = SingleUser();
  singleUser.setUser(
    User(
      token: body['access_token'],
      email: body['user']['email'],
      displayemail: body['user']['display_email'],
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
      mobilenumber: body['user']['profile']['mobile_number'] ?? "Not Specified",
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
    ),
  );
  return singleUser;
}
