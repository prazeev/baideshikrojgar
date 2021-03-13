import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Banners extends StatefulWidget {
  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: MainController.to.banners.length,
            itemBuilder: (BuildContext context, int itemIndex, int i) {
              return MainController.to.banners[itemIndex]['type'] == "assets"
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        MainController.to.banners[itemIndex]['path'],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CachedNetworkImage(
                        imageUrl: MainController.to.banners[itemIndex]['path'],
                      ),
                    );
            },
            options: CarouselOptions(
                height: 200,
                aspectRatio: 16 / 9,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: MainController.to.banners.map((url) {
              int index = MainController.to.banners.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
