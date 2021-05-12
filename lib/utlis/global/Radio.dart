import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/views/radio/RadioWidget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalRadio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          elevation: 0.0,
          heroTag: null,
          child: Image.asset('assets/images/news-icon.png'),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Get.toNamed(CATEGORY_NEWS_SAJHASABAL,
                arguments: {"title": "समाचारहरु", "path": "updates_list"});
          },
        ),
        SizedBox(
          width: 20,
        ),
        FloatingActionButton(
          elevation: 0.0,
          heroTag: null,
          child: Image.asset('assets/images/radio-icon.png'),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Get.toNamed(RADIO_PAGE);
          },
        ),
      ],
    );
  }
}
