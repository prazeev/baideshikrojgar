import 'dart:convert';

import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/BannerAds.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CategoryDataSajhasabal extends StatefulWidget {
  @override
  _CategoryDataSajhasabalState createState() => _CategoryDataSajhasabalState();
}

class _CategoryDataSajhasabalState extends State<CategoryDataSajhasabal> {
  MainController mainController = Get.find();
  GlobalKey _scaffoldKey;
  ScrollController scrollController = ScrollController();
  bool isGridView = false;
  List<dynamic> datas = [];
  Map info = Get.arguments;
  int page = 0;
  @override
  void initState() {
    this.fetchData(first: true, category: info['path']);
    super.initState();

    scrollController
      ..addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          this.fetchData(category: info['path']);
        }
      });
  }

  refreshHandler() async {
    setState(() {
      page = 0;
    });
    await this.fetchData(first: true, category: info['path']);
  }

  fetchData(
      {bool first = false,
      String category = 'foreign-jobs-information'}) async {
    if (category == 'updates_list') {
      dynamic res = await this.mainController.apiController.getDataFuture(
            SAJHASABAL_URL + 'api/' + category + '?per_page=' + page.toString(),
            externalurl: true,
            ignoreOffline: this.mainController.isInternetConnected,
          );
      if (first) {
        setState(() {
          datas = [];
        });
      }
      var data = json.decode(res.body);
      setState(() {
        datas = [...datas, ...data];
        page = page + 1;
      });
    } else {
      String url = page == 1
          ? SAJHASABAL_URL + 'api/fetchPostsByCategories/' + category
          : SAJHASABAL_URL +
              'api/fetchPostsByCategories/' +
              category +
              '?per_page=' +
              page.toString();
      dynamic res = await this.mainController.apiController.getDataFuture(
            url,
            externalurl: true,
            ignoreOffline: this.mainController.isInternetConnected,
          );
      if (first) {
        setState(() {
          datas = [];
        });
      }
      var data = json.decode(res.body);
      setState(() {
        datas = [...datas, ...data];
        page = page + 1;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormatted(
          text: info['title'],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshHandler(),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int i) {
            // news types
            if (datas[i]['categories_id'] == '1' ||
                datas[i]['categories_id'] == '6') {
              return Column(
                children: [
                  i == 0
                      ? AppBannerAd(adSize: AdSize.fullBanner)
                      : SizedBox(
                          height: 1,
                        ),
                  FlatButton(
                    onPressed: () {
                      Get.toNamed(VIEW_HTML, arguments: {
                        "title": datas[i]['title'],
                        "html": datas[i]['details'],
                        "showAds": false,
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            height: JOB_TILE_HEIGHT,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: JOB_TILE_HEIGHT / 2.5,
                                  backgroundImage: NetworkImage(
                                    'http://sajhasabal.com/uploads/contents/thumbs/small/' +
                                        datas[i]['featured_img'],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormatted(
                                          text: datas[i]['title'],
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextNormal(
                                          text: datas[i]['date'],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: JOB_TILE_HEIGHT * 3,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'http://sajhasabal.com/uploads/contents/thumbs/' +
                                      datas[i]['featured_img'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                              left: 5,
                              right: 5,
                              top: 10,
                              bottom: 10,
                            ),
                            child: TextFormatted(
                              text: datas[i]['meta_desc'],
                              maxline: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  i == 0
                      ? AppBannerAd(adSize: AdSize.fullBanner)
                      : SizedBox(
                          height: 1,
                        ),
                  JobTile(
                    height: 100,
                    type: 'html',
                    html: datas[i]['details'],
                    title: datas[i]['title'],
                    abstract: datas[i]['meta_desc'],
                    picture:
                        "http://sajhasabal.com/uploads/contents/thumbs/small/" +
                            datas[i]['featured_img'],
                    // dateField: datas[i]['date'],
                  ),
                ],
              );
            }
          },
          controller: scrollController,
          itemCount: datas.length,
        ),
      ),
    );
  }
}
