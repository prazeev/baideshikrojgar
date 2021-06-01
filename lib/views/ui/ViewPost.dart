import 'dart:convert';

import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/shimmer.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/BannerAds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPost extends StatefulWidget {
  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  int postid = Get.arguments;
  MainController mainController = Get.find();
  String title = "View Post";
  Map data = {"title_np": "", "description_np": ""};
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchPost(postid);
  }

  fetchPost(int id) async {
    setState(() {
      isLoading = true;
    });
    dynamic res = await this.mainController.apiController.getDataFuture(
          'view_post/' + id.toString(),
          ignoreOffline: this.mainController.isInternetConnected,
        );
    var d = json.decode(res.body);
    setState(() {
      data = d;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Fetching..."),
        ),
        body: SimmerLoading(
          loadingCount: 30,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: TextFormatted(
          text: this.title,
        ),
      ),
      body: ListView(
        children: [
          AppBannerAd(),
          Container(
            color: Colors.grey,
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 5,
              runSpacing: 5,
              children: [
                TextFormatted(
                  text: data['title_np'],
                  maxline: 10,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                TextFormatted(
                  text: getTimeFormatted(data['created_at']),
                  maxline: 10,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
          InteractiveViewer(
            panEnabled: false, // Set it to false to prevent panning.
            boundaryMargin: EdgeInsets.all(80),
            minScale: 0.5,
            maxScale: 4,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(5),
              child: Html(
                  data: data['description_np'],
                  onLinkTap: (String url) async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
