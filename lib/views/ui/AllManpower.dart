import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/utlis/global/textformfield.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllManpower extends StatefulWidget {
  @override
  _AllManpowerState createState() => _AllManpowerState();
}

class _AllManpowerState extends State<AllManpower> {
  MainController mainController = Get.find();
  GlobalKey _scaffoldKey;
  ScrollController scrollController = ScrollController();
  TextEditingController searchTextController = TextEditingController(text: "");
  bool isGridView = false;
  List<dynamic> datas = [];
  @override
  void initState() {
    setState(() {
      _scaffoldKey = GlobalKey<ScaffoldState>();
    });
    this.fetchData(first: true);
    super.initState();

    scrollController
      ..addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          this.fetchData();
        }
      });
  }

  fetchData({bool first = false}) async {
    dynamic data = await this.mainController.fetchAllDatas(
          key: 'manpowers',
          first: first,
          path: first ? 'manpowers/' + this.searchTextController.text : '',
        );
    if (first) {
      setState(() {
        datas = [];
      });
    }
    setState(() {
      datas = [...datas, ...data];
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: TextFormatted(
            text: "All Manpowers",
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: !isGridView ? Icon(Icons.grid_on) : Icon(Icons.list),
                  onPressed: () {
                    setState(() {
                      isGridView = !isGridView;
                    });
                  },
                ),
              ],
            ),
          ]),
      body: Column(
        children: [
          CustomTextField(
            elevation: 1,
            hint: "Search manpowers",
            radius: 0,
            textEditingController: searchTextController,
            onTextChange: (String text) {
              this.fetchData(first: true);
            },
          ),
          Expanded(
            child: isGridView
                ? GridView.builder(
                    itemCount: datas.length,
                    controller: scrollController,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150.0,
                      crossAxisSpacing: 7.0,
                      mainAxisSpacing: 7.0,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) => _buildGrid(
                      datas[index],
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0.1,
                        color: Colors.grey,
                      );
                    },
                    itemBuilder: (context, index) => _buildList(
                      datas[index],
                    ),
                    itemCount: datas.length,
                    controller: scrollController,
                  ),
          ),
        ],
      ),
    );
  }

  _buildList(dynamic item) {
    return JobTile(
      height: 90,
      jobId: item['id'],
      type: 'manpowerjobs',
      picture: getFirstImage(item['logo']),
      title: item['name'],
      location: item['location'],
      contact: item['contact'],
      jobCount: item['active_jobs_count'],
    );
  }

  _buildGrid(dynamic item) {
    return Stack(
      children: [
        Column(
          children: [
            CachedNetworkImage(
              height: 100,
              imageUrl: getFirstImage(item['logo']),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormatted(
                    text: item['name'],
                    maxline: 5,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.location_city,
                    color: Colors.green,
                    size: 11,
                  ),
                  TextFormatted(
                    text: "Location: ",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                  TextFormatted(
                    text: item['location'],
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: 0,
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: TextFormatted(
                text: "Jobs: " + item['active_jobs_count'].toString(),
                textStyle: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          height: 20,
          width: 100,
        )
      ],
    );
  }
}
