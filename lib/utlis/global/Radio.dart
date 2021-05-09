import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/views/radio/RadioWidget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalRadio extends StatelessWidget {
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0.0,
      child: MainController.to.isRadioPlaying
          ? RadioPlayPauseButton()
          : new Icon(
              Icons.play_arrow,
            ),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if (!mainController.isRadioPlaying) {
          Get.toNamed(RADIO_PAGE);
          MainController.to.setIsRadioPlaying(!mainController.isRadioPlaying);
        }
      },
    );
  }
}
