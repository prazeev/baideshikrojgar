import 'package:flutter/material.dart';

class Accodain extends StatefulWidget {
  Accodain({this.title, this.children, this.onRefresh});
  final String title;
  final List<Widget> children;
  final onRefresh;
  @override
  _AccodainState createState() => _AccodainState(title, children, onRefresh);
}

class _AccodainState extends State<Accodain> {
  bool isExpanded;
  String title;
  List<Widget> children;
  dynamic onRefresh;
  _AccodainState(this.title, this.children, this.onRefresh);
  @override
  void initState() {
    setState(() {
      isExpanded = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 10),
          color: Theme.of(context).primaryColor,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: isExpanded
                        ? Icon(
                            Icons.clear,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                  Text(
                    title,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: onRefresh,
                color: Colors.white,
              ),
            ],
          ),
        ),
        Column(
          children: isExpanded ? children : <Widget>[],
        ),
      ],
    );
  }
}
