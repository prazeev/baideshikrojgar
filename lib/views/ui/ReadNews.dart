import 'package:baideshikrojgar/views/fragements/BannerAds.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ReadNews extends StatefulWidget {
  @override
  _ReadNewsState createState() => _ReadNewsState();
}

class _ReadNewsState extends State<ReadNews> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AppBannerAd(
            adSize: AdSize.fullBanner,
          ),
          Center(
            child: Text("Read News"),
          ),
        ],
      ),
    );
  }
}
