import 'package:flutter/material.dart';

class TextNormal extends StatefulWidget {
  final String text;
  TextNormal({this.text});
  @override
  _TextNormalState createState() => _TextNormalState();
}

class _TextNormalState extends State<TextNormal> {
  @override
  Widget build(BuildContext context) {
    return Text(this.widget.text);
  }
}

class TextFormatted extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final int maxline;
  TextFormatted({
    this.text,
    this.textStyle,
    this.maxline = 1,
  });
  @override
  _TextFormattedState createState() => _TextFormattedState();
}

class _TextFormattedState extends State<TextFormatted> {
  @override
  Widget build(BuildContext context) {
    return Text(
      this.widget.text == null ? '-' : this.widget.text,
      maxLines: this.widget.maxline,
      style: this.widget.textStyle,
    );
  }
}

class SimplePrimaryTitle extends StatelessWidget {
  final String title;
  SimplePrimaryTitle({this.title});
  @override
  Widget build(BuildContext context) {
    return TextFormatted(
      text: this.title,
      maxline: 12,
      textStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
