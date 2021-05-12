import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppBannerAd extends StatelessWidget {
  final String type;
  final AdSize adSize;
  AppBannerAd({
    this.type = 'google',
    this.adSize = AdSize.banner,
  });
  @override
  Widget build(BuildContext context) {
    return GoogleBannerAds(
      adSize: this.adSize,
    );
  }
}

class GoogleBannerAds extends StatefulWidget {
  final AdSize adSize;
  GoogleBannerAds({@required this.adSize});
  @override
  _GoogleBannerAdsState createState() => _GoogleBannerAdsState();
}

class _GoogleBannerAdsState extends State<GoogleBannerAds> {
  BannerAd bannerAd;
  @override
  void initState() {
    super.initState();
    this._initBanner();
  }

  _initBanner() {
    setState(() {
      bannerAd = BannerAd(
        size: this.widget.adSize,
        adUnitId: 'ca-app-pub-1216829600340360/9835018375',
        listener: AdListener(),
        request: AdRequest(),
      );
    });
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.widget.adSize.height.toDouble(),
      width: this.widget.adSize.width.toDouble(),
      child: AdWidget(
        ad: bannerAd,
      ),
    );
  }
}
