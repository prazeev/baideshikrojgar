import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeNews extends StatelessWidget {
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    List<Widget> allnews = [];
    allnews = this.mainController.homeNews.map((news) {
      return HomeNewsTile(
        news: news,
      );
    }).toList();
    return Container(
      child: Column(
        children: allnews,
      ),
    );
  }
}

class HomeNewsTile extends StatelessWidget {
  final dynamic news;
  HomeNewsTile({
    this.news,
  });
  @override
  Widget build(BuildContext context) {
    if (news['isBigTile']) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
                      news['picture'],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormatted(
                            text: news['title'],
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextNormal(
                            text: news['date'],
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
                imageUrl: news['picture'],
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
                text: news['abstract'],
                maxline: 5,
              ),
            ),
          ],
        ),
      );
    } else {
      return JobTile(
        title: news['title'],
        picture: news['picture'],
        abstract: news['abstract'],
        isBigImage: true,
        height: 100,
      );
    }
  }
}
