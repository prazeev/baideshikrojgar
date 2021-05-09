import 'dart:ui';

import 'package:baideshikrojgar/utlis/constants/ChannelList.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RadioPlayer extends StatefulWidget {
  Channel channel;
  RadioPlayer(this.channel);
  @override
  _RadioPlayerState createState() => _RadioPlayerState();
}

class _RadioPlayerState extends State<RadioPlayer> {
  String url;
  @override
  initState() {
    super.initState();

    url = widget.channel.url;

    audioStart();
  }

  audioStart() async {}

  Future playingStatus() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: NetworkImage(
            this.widget.channel.imgurl,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: this.widget.channel.imgurl,
                imageBuilder: (context, imageProvider) => Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                height: 50,
              ),
              TextFormatted(
                text: this.widget.channel.title,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              TextFormatted(
                text: this.widget.channel.gerne,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.pause_sharp),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: 0.3,
                backgroundColor: Colors.transparent,
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormatted(
                    text: "0:00:05",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextFormatted(
                    text: " / ",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextFormatted(
                    text: "0:05:42",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
