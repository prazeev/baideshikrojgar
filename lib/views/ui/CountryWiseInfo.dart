import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/utlis/global/textformfield.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryWiseInfo extends StatefulWidget {
  @override
  _CountryWiseInfoState createState() => _CountryWiseInfoState();
}

class _CountryWiseInfoState extends State<CountryWiseInfo> {
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
          key: 'countries',
          first: first,
          path: first
              ? 'promotedCountries/' + searchTextController.text.trim()
              : '',
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
          text: "देशगत जानकारी",
        ),
      ),
      body: Column(
        children: [
          CustomTextField(
            elevation: 1,
            hint: "Search here",
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
                      maxCrossAxisExtent: 250.0,
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
      // jobId: item['slug'],
      type: 'html',
      html: item['description_np'],
      picture: item['flag'],
      bigTitle: true,
      // isBigImage: true,
      title: item['title_np'],
      abstract: item['abstract_en'],
      // jobCount: item['active_jobs_count'],
    );
  }

  _buildGrid(dynamic item) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: item['flag'],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormatted(
                    text: item['title_en'],
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
          ],
        ),
        // Positioned(
        //   right: 0,
        //   child: Container(
        //     color: Theme.of(context).primaryColor,
        //     child: Center(
        //       child: TextFormatted(
        //         text: "Jobs: " + item['active_jobs_count'].toString(),
        //         textStyle: TextStyle(color: Colors.white, fontSize: 10),
        //       ),
        //     ),
        //   ),
        //   height: 20,
        //   width: 100,
        // )
      ],
    );
  }
}
