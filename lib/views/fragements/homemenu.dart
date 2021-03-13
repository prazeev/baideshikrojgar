import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:flutter/material.dart';

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(
        left: 25,
        right: 25,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).primaryColor,
                  size: 40.0,
                ),
                TextNormal(
                  text: "Country",
                ),
              ],
            ),
          ),
          Container(
            width: 2,
            height: 50,
            color: Theme.of(context).primaryColor,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  color: Theme.of(context).primaryColor,
                  size: 40.0,
                ),
                TextNormal(
                  text: "Trendings",
                ),
              ],
            ),
          ),
          Container(
            width: 2,
            height: 50,
            color: Theme.of(context).primaryColor,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category,
                  color: Theme.of(context).primaryColor,
                  size: 40.0,
                ),
                TextNormal(
                  text: "Categories",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
