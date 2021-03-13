import 'dart:async';

import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/Radio.dart';
import 'package:baideshikrojgar/views/fragements/drawer.dart';
import 'package:baideshikrojgar/views/fragements/homebanner.dart';
import 'package:baideshikrojgar/views/fragements/homelatestjobs.dart';
import 'package:baideshikrojgar/views/fragements/homemenu.dart';
import 'package:baideshikrojgar/views/fragements/homenewstile.dart';
import 'package:baideshikrojgar/views/fragements/homeotherblock.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<MainController>(
          init: MainController(),
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
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {},
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: ListView(
        children: [
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
            child: HomeLatestJobs(),
          ),
          HomeOtherMenu(),
          HomeManpowerEmbassy(),
          HomeLTWorkPermit(),
          HomeNews(),
        ],
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
        break;
      case ConnectivityResult.none:
        this.mainController.setIsInternetConnected(false);
        break;
      default:
        this.mainController.setIsInternetConnected(false);
        break;
    }
  }
}
