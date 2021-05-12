import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/BannerAds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewHtml extends StatefulWidget {
  @override
  _ViewHtmlState createState() => _ViewHtmlState();
}

class _ViewHtmlState extends State<ViewHtml> {
  MainController mainController = Get.find();
  String title = "View Article";
  Map data = {"title": "", "html": ""};
  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormatted(
          text: this.title,
        ),
      ),
      body: ListView(
        children: [
          AppBannerAd(
            adSize: AdSize.largeBanner,
          ),
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
                  text: data['title'],
                  maxline: 10,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                // TextFormatted(
                //   text: getTimeFormatted(data['created_at']),
                //   maxline: 10,
                //   textStyle: TextStyle(
                //     color: Colors.white,
                //     fontSize: 10,
                //   ),
                // )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(5),
            child: Html(
                data: data['html'],
                onLinkTap: (String url) async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                }),
          )
        ],
      ),
    );
  }
}
