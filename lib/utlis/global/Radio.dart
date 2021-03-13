import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalRadio extends StatelessWidget {
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0.0,
      child: MainController.to.isRadioPlaying
          ? new Icon(Icons.pause)
          : new Icon(
              Icons.play_arrow,
            ),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        MainController.to.setIsRadioPlaying(!mainController.isRadioPlaying);
      },
    );
  }
}
