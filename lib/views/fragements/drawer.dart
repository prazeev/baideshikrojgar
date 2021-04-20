import 'dart:io';

import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/Accodain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({this.skey});
  final GlobalKey skey;
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String versionName = '';
  String versionCode = '';
  MainController mainController = Get.find();
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
                  accountName: Text(mainController.user.name),
                  accountEmail: Text(mainController.user.email),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/side.png'),
                      fit: BoxFit.cover,
                    ),
                    // color: Color(0xFF56ccf2),
                  ),
                ),
                // ListTile(
                //   title: Text('Home'),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
                ExpansionTile(
                  title: Text("महत्वपूर्ण जानकारीहरु"),
                  children: <Widget>[
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('आधारभुत जानकारीहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(CATEGORY_NEWS_SAJHASABAL, arguments: {
                          "title": "आधारभुत जानकारीहरु",
                          "path": "foreign-jobs-information"
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('अभिमुखीकरण'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(CATEGORY_NEWS_SAJHASABAL, arguments: {
                          "title": "अभिमुखीकरण",
                          "path": "orentation"
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.public,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('मान्यता प्राप्त देशहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(VALID_COUNTRIES);
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.block,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('रोक्का कम्पनीहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(VIEW_POST, arguments: 36);
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('निवेदन नमुनाहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(CATEGORY_NEWS_SAJHASABAL, arguments: {
                          "title": "निवेदन नमुनाहरु",
                          "path": "application-samples"
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cast_for_education,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('तालिम पाठ्यक्रमहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(CATEGORY_NEWS_SAJHASABAL, arguments: {
                          "title": "तालिम पाठ्यक्रमहरु",
                          "path": "training-courses"
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.rule,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('ऐन कानुन/नियमहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(CATEGORY_NEWS_SAJHASABAL, arguments: {
                          "title": "ऐन कानुन/नियमहरु",
                          "path": "acts-rules"
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.contact_mail,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('सम्पर्क नम्वरहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(VIEW_POST, arguments: 319);
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Text('म्यानपावरहरु'),
                  onTap: () {
                    Get.toNamed(ALL_MANPOWER);
                  },
                ),
                ListTile(
                  title: Text('देशगत जानकारी'),
                  onTap: () {
                    Get.toNamed(COUNTRY_WISE_INFO);
                  },
                ),
                ListTile(
                  title: Text('विज्ञापन पूर्व स्वीकृति'),
                  onTap: () {
                    Get.toNamed(LT_WORKPERMIT_SEARCH, arguments: {
                      "type": LT_SEARCH,
                      "data": "",
                    });
                  },
                ),
                ListTile(
                  title: Text('श्रम स्वीकृति'),
                  onTap: () {
                    Get.toNamed(LT_WORKPERMIT_SEARCH,
                        arguments: {"type": PASSPORT_NO_SEARCH, "data": ""});
                  },
                ),
                ExpansionTile(
                  title: Text("सम्बन्धित निकायहरु"),
                  children: <Widget>[
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_balance,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('दुतावासहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(DIRECTORY_LISTING, arguments: {
                          "title": "दुतावासहरु",
                          "id": 5,
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.model_training,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('अभिमुखिकरण संस्थाहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(DIRECTORY_LISTING, arguments: {
                          "title": "अभिमुखिकरण संस्थाहरु",
                          "id": 2,
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_library,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('तालिम प्रदायक संस्थाहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(DIRECTORY_LISTING, arguments: {
                          "title": "तालिम प्रदायक संस्थाहरु",
                          "id": 4,
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_moderator,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('विमा प्रदायक संस्थाहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(DIRECTORY_LISTING, arguments: {
                          "title": "विमा प्रदायक संस्थाहरु",
                          "id": 6,
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('मेडिकल संस्थाहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(DIRECTORY_LISTING, arguments: {
                          "title": "मेडिकल संस्थाहरु",
                          "id": 3,
                        });
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_balance_sharp,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('बैंकहरु'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(DIRECTORY_LISTING, arguments: {
                          "title": "बैंकहरु",
                          "id": 1,
                        });
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Text('भाषा-ज्ञान'),
                  onTap: () {
                    Get.dialog(BlurryDialog("Please wait", "Comming soon"));
                  },
                ),
                ListTile(
                  title: Text('CV बनाउनुहोस्'),
                  onTap: () {
                    Get.dialog(BlurryDialog("Please wait", "Comming soon"));
                  },
                ),
                ListTile(
                  title: Text('समाचारहरु'),
                  onTap: () {
                    Get.toNamed(CATEGORY_NEWS_SAJHASABAL, arguments: {
                      "title": "समाचारहरु",
                      "path": "updates_list"
                    });
                  },
                ),
                ListTile(
                  title: Text('भिडियोहरु'),
                  onTap: () async {
                    String url = 'https://www.youtube.com/c/SajhaSabal/videos';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                ),
                ListTile(
                  title: Text('विनिमय दर'),
                  onTap: () {
                    Get.toNamed(FOREX);
                  },
                ),
                ListTile(
                  title: Text('समस्या तथा गुनाशो'),
                  onTap: () {
                    final Uri params = Uri(
                      scheme: 'mailto',
                      path: 'sajhajobs@gmail.com',
                      query: 'subject=समस्या तथा गुनाशो बारे&body=',
                    );
                    final url = params.toString();
                    launch(url);
                  },
                ),
                ListTile(
                  title: Text('हाम्रो बारे'),
                  onTap: () {
                    Get.toNamed(VIEW_POST, arguments: 282);
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    await sharedPreferences.remove('isLoggedIn');
                    Get.offAllNamed(LOGIN_PAGE);
                  },
                ),
                // ListTile(
                //   title: Text('Rate us*****'),
                //   onTap: () {},
                // ),
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
