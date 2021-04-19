import 'dart:convert';

import 'package:baideshikrojgar/controller/ApiController.dart';
import 'package:baideshikrojgar/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  // Logged in user
  User user = User(
    email: '',
    name: '',
  );
  MainController({
    this.user,
    this.apiController,
  });
  // Internet connections
  bool isInternetConnected = false;
  setIsInternetConnected(bool val) {
    this.isInternetConnected = val;
    update();
  }

  List notifications = [
    {
      "title": "Random Notification",
      "description": "Random description",
      "time": "1h",
      "type": "new_news",
    }
  ];

  // Banners
  List<Map<String, String>> banners = [
    {
      "path": "assets/images/one.png",
      "type": "assets",
    },
    {
      "path": "assets/images/two.jpg",
      "type": "assets",
    },
    {
      "path": "assets/images/three.jpg",
      "type": "assets",
    },
  ];
  // Home other menu
  List<Map<String, String>> homeOtherMenu = [
    {
      "path": "assets/images/Bank.png",
      "key": "1",
      "title": "Bank list",
    },
    {
      "path": "assets/images/Insourance.png",
      "key": "6",
      "title": "Insurance Companies",
    },
    {
      "path": "assets/images/Medical.png",
      "key": "3",
      "title": "Medical Centers",
    },
    {
      "path": "assets/images/Orientation.png",
      "key": "2",
      "title": "Orientation Centers",
    },
    {
      "path": "assets/images/Training.png",
      "key": "4",
      "title": "Training Centers",
    },
    {
      "path": "assets/images/Embassies.png",
      "key": "5",
      "title": "Embassies",
    },
  ];
  Map<String, dynamic> allApis = {
    "latest_jobs": {
      "total": 0,
      "per_page": 25,
      "current_page": 0,
      "last_page": 0,
      "first_page_url": null,
      "last_page_url": null,
      "next_page_url": null,
      "prev_page_url": null,
      "path": null,
    },
    "featured_jobs": {
      "total": 0,
      "per_page": 25,
      "current_page": 0,
      "last_page": 0,
      "first_page_url": null,
      "last_page_url": null,
      "next_page_url": null,
      "prev_page_url": null,
      "path": null,
    },
    "manpowers": {
      "total": 0,
      "per_page": 25,
      "current_page": 0,
      "last_page": 0,
      "first_page_url": null,
      "last_page_url": null,
      "next_page_url": null,
      "prev_page_url": null,
      "path": null,
    },
    "countries": {
      "total": 0,
      "per_page": 25,
      "current_page": 0,
      "last_page": 0,
      "first_page_url": null,
      "last_page_url": null,
      "next_page_url": null,
      "prev_page_url": null,
      "path": null,
    },
    "jobs_by_countries": {
      "total": 0,
      "per_page": 25,
      "current_page": 0,
      "last_page": 0,
      "first_page_url": null,
      "last_page_url": null,
      "next_page_url": null,
      "prev_page_url": null,
      "path": null,
    },
    "categories": {
      "total": 0,
      "per_page": 25,
      "current_page": 0,
      "last_page": 0,
      "first_page_url": null,
      "last_page_url": null,
      "next_page_url": null,
      "prev_page_url": null,
      "path": null,
    },
    "jobs_by_categories": {
      "total": 0,
      "per_page": 25,
      "current_page": 0,
      "last_page": 0,
      "first_page_url": null,
      "last_page_url": null,
      "next_page_url": null,
      "prev_page_url": null,
      "path": null,
    },
  };
  List<dynamic> homeManpowers = [
    {
      "picture": "https://picsum.photos/200",
      "title": "A",
      "location": "Kathmandu nepal jhapa",
      "contact": "9860428885",
      "newjob": 41
    }
  ];
  List<dynamic> homeEmbassies = [
    {
      "picture": "https://picsum.photos/200",
      "title": "A",
      "location": "Kathmandu nepal jhapa",
      "contact": "9860428885",
    }
  ];
  List<dynamic> homeNews = [
    {
      "picture": "https://picsum.photos/200",
      "title":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's s",
      "date": "28 Feb, 2021",
      "abstract":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      "full_news": "lorem",
      "isBigTile": false,
    },
    {
      "picture": "https://picsum.photos/200",
      "title":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's s",
      "date": "28 Feb, 2021",
      "abstract":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      "full_news": "lorem",
      "isBigTile": true,
    },
  ];
  static MainController get to => Get.find();

  ApiController apiController;

  Future refreshNotifications() async {
    EasyLoading.show(status: 'We are refreshing...');
    EasyLoading.dismiss();
  }

  bool isRadioPlaying = false;
  setIsRadioPlaying(bool value) {
    this.isRadioPlaying = value;
    update();
  }

  fetchAllDatas({
    @required String key,
    bool first = false,
    String path = '',
  }) async {
    if (this.allApis.containsKey(key)) {
      bool externalurl = !(path.length > 0);
      if (!first) {
        path = this.allApis[key]['next_page_url'];
      }
      if (path == null) {
        return [];
      }
      var res = await this
          .apiController
          .getDataFuture(path, externalurl: externalurl);

      var data = json.decode(res.body);
      this.allApis[key] = data;
      return data['data'];
    }
  }

  subscribeModel(String model, int modelid) async {
    var res = await this.apiController.getDataFuture('subscription_system/' +
        model +
        '/' +
        modelid.toString() +
        '/subscribe');
    dynamic data = json.decode(res.body);
    print(data);
    return data;
  }

  unsubscribeModel(String model, int modelid) async {
    var res = await this.apiController.getDataFuture('subscription_system/' +
        model +
        '/' +
        modelid.toString() +
        '/unsubscribe');
    dynamic data = json.decode(res.body);
    print(data);
    return data;
  }

  toggleSubscriptionModel(String model, int modelid) async {
    var res = await this.apiController.getDataFuture(
        'subscription_system/' + model + '/' + modelid.toString() + '/toggle');
    dynamic data = json.decode(res.body);
    return data;
  }

  fetchAllDatasNonPaginated({
    String path = '',
  }) async {
    bool externalurl = !(path.length > 0);
    var res =
        await this.apiController.getDataFuture(path, externalurl: externalurl);
    var data = json.decode(res.body);
    return data;
  }
}
