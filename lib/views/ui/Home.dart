import 'dart:async';
import 'dart:convert';

import 'package:baideshikrojgar/controller/ApiController.dart';
import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/models/User.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/Radio.dart';
import 'package:baideshikrojgar/views/fragements/BannerAds.dart';
import 'package:baideshikrojgar/views/fragements/drawer.dart';
import 'package:baideshikrojgar/views/fragements/homebanner.dart';
import 'package:baideshikrojgar/views/fragements/homelatestjobs.dart';
import 'package:baideshikrojgar/views/fragements/homemenu.dart';
import 'package:baideshikrojgar/views/fragements/homenewstile.dart';
import 'package:baideshikrojgar/views/fragements/homeotherblock.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Get.arguments;
    return Scaffold(
      body: Center(
        child: GetBuilder<MainController>(
          init: MainController(
            user: user,
            apiController: ApiController(
              token: user.token,
            ),
          ),
          builder: (_) => HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  MainController mainController = Get.find();
  dynamic datas = {
    "latest_jobs": [],
    "manpowers": [],
    "embassies": [],
    "companies": [],
  };
  List newsdatas = [];
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  refreshHandler() async {
    await this.syncHome();
    await this.fetchHomeNews(
      first: true,
    );
  }

  syncHome() async {
    dynamic data = await mainController.fetchAllDatasNonPaginated(path: "sync");
    print(data);
    setState(() {
      datas = {
        "latest_jobs": data['latest_jobs']['data']
            .map((item) => processLesteJobs(item))
            .toList(),
        "manpowers": data['manpowers']['data']
            .map((item) => processManpower(item))
            .toList(),
        "embassies": data['locations']['data']
            .map((item) => processEmbassy(item))
            .toList(),
        "companies": data['companies']['data']
            .map((item) => processCompany(item))
            .toList(),
      };
    });
  }

  fetchHomeNews({bool first = false, String category = 'employment'}) async {
    dynamic res = await this.mainController.apiController.getDataFuture(
          SAJHASABAL_URL + 'api/fetchPostsByCategories/' + category + '/5',
          externalurl: true,
          ignoreOffline: this.mainController.isInternetConnected,
          silent: true,
        );
    if (first && mounted) {
      setState(() {
        newsdatas = [];
      });
    }
    var data = json.decode(res.body);
    print(data);
    if (mounted) {
      setState(() {
        newsdatas = [...newsdatas, ...data];
      });
    }
  }

  processLesteJobs(dynamic item) {
    return {
      "picture": getFirstImage(item['images']),
      "title": item['title_en'],
      "salarymax": item['salary_max'],
      "salarymin": item['salary_min'],
      "location": item['manpower']['location'],
      "daysLeft": getTimeFormatted(item['expires_on']),
      "id": item['id'],
    };
  }

  processManpower(dynamic item) {
    return {
      "picture": getFirstImage(item['logo']),
      "title": item['name'],
      "abstract": item['abstract'],
      "contact": item['contact'],
      "newjob": item['active_jobs_count'],
      "id": item['id'],
      "average": item['average'],
    };
  }

  processEmbassy(dynamic item) {
    return {
      "picture": getFirstImage(item['images']),
      "title": item['title_en'],
      "description_en": item['description_np'],
      "location": item['address'],
      "contact": item['contact'],
    };
  }

  processCompany(dynamic item) {
    return {
      "picture": item['main_image'],
      "id": item['id'],
      "title": item['title'],
      "abstract": item['abstract'],
      "description": item['description'],
      "average": item['average'],
    };
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Baideshik Rojgar"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notification_important,
            ),
            onPressed: () {
              Get.toNamed(NOTIFICATION);
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.people),
          //   onPressed: () {
          //     Get.toNamed(PROFILE);
          //   },
          // ),
        ],
      ),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshHandler(),
        child: ListView(
          children: [
            AppBannerAd(adSize: AdSize.largeBanner),
            Stack(
              children: [
                Banners(),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: HomeMenu(),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: HomeLatestJobs(
                jobs: datas['latest_jobs'],
              ),
            ),
            HomeOtherMenu(),
            HomeManpowerEmbassy(
              manpowers: datas['manpowers'],
              embassies: datas['embassies'],
              companies: datas['companies'],
            ),
            AppBannerAd(adSize: AdSize.largeBanner),
            HomeLTWorkPermit(),
            HomeNews(
              datas: newsdatas,
            ),
          ],
        ),
      ),
      floatingActionButton: GlobalRadio(),
    );
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error" + e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        this.mainController.setIsInternetConnected(true);
        this.refreshHandler();
        break;
      case ConnectivityResult.none:
        this.mainController.setIsInternetConnected(false);
        this.refreshHandler();
        break;
      default:
        this.mainController.setIsInternetConnected(false);
        this.refreshHandler();
        break;
    }
  }
}
