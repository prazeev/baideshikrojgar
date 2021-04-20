import 'dart:convert';

import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiController {
  ApiController({
    @required this.token,
  });

  String token;
  postData(data, apiUrl, {api: true}) async {
    var fullUrl =
        api ? (BASE_URL + '/' + apiUrl) : (BASE_URL_FULL + '/' + apiUrl);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  postDataFuture(data, apiUrl, {String message = "Please wait..."}) async {
    var fullUrl = BASE_URL + apiUrl;
    print(fullUrl);
    EasyLoading.show(status: message);
    var res = await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
    EasyLoading.dismiss();
    return res;
  }

  getDataFuture(
    apiUrl, {
    String message = "Please wait...",
    api: true,
    silent: false,
    externalurl: false,
    ignoreOffline = false,
  }) async {
    var fullUrl = externalurl
        ? apiUrl
        : api
            ? (BASE_URL + '/' + apiUrl)
            : (BASE_URL_FULL + '/' + apiUrl);
    print(fullUrl);
    if (!silent) {
      EasyLoading.show(status: message);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data;
    var cacheddata;
    if (ignoreOffline) {
      cacheddata = null;
    } else {
      cacheddata = prefs.getString(fullUrl);
    }
    if (cacheddata == null) {
      data = await http.get(fullUrl, headers: _setHeaders());
      await prefs.setString(fullUrl, data.body.toString());
    } else {
      CachedDataHandler cachedDataHandler = new CachedDataHandler();
      cachedDataHandler.setBody(cacheddata);
      data = cachedDataHandler;
    }

    if (!silent) {
      EasyLoading.dismiss();
    }
    return data;
  }

  getData(apiUrl, {String message = "Please wait..."}) async {
    EasyLoading.show(status: message);
    var fullUrl = BASE_URL + apiUrl;
    var data = await http.get(fullUrl, headers: _setHeaders());
    EasyLoading.dismiss();
    return data;
  }

  _setHeaders() => {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token ?? "TEST"
      };
}

class CachedDataHandler {
  String body;
  setBody(String body) {
    this.body = body;
  }
}
