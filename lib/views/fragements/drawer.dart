import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({this.skey});
  final GlobalKey skey;
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String versionName = '';
  String versionCode = '';
  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        versionName = packageInfo.version;
        versionCode = packageInfo.buildNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text("Bashudev Paudel"),
                  accountEmail: Text("prazeev@gmail.com"),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/side.png'),
                      fit: BoxFit.cover,
                    ),
                    // color: Color(0xFF56ccf2),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text('Version ' + versionName),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
