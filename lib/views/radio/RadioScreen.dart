import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:baideshikrojgar/utlis/constants/ChannelList.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/radio/RadioPlayer.dart';
import 'package:baideshikrojgar/views/radio/RadioWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadioScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RadioScreenState();
  }
}

class RadioScreenState extends State<RadioScreen> {
  List<Channel> list = [];
  @override
  void initState() {
    super.initState();
    fetch();
  }

  fetch() async {
    setState(() {
      list = getChannels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Radio Channels"),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              AppBar().preferredSize.height,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new ExactAssetImage('assets/images/radio.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: AudioServiceWidget(
              child: RadioWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
