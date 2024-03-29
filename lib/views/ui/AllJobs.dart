import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/utlis/global/textformfield.dart';
import 'package:baideshikrojgar/views/fragements/BannerAds.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AllJobs extends StatefulWidget {
  @override
  _AllJobsState createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
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

  refreshHandler() async {
    await this.fetchData(first: true);
  }

  fetchData({bool first = false}) async {
    dynamic data = await this.mainController.fetchAllDatas(
          key: 'latest_jobs',
          first: first,
          path: first ? 'latest_jobs/' + this.searchTextController.text : '',
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
            text: "All Jobs",
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
      body: RefreshIndicator(
        onRefresh: () => refreshHandler(),
        child: Column(
          children: [
            CustomTextField(
              elevation: 1,
              hint: "Search jobs",
              radius: 0,
              textEditingController: searchTextController,
              onTextChange: (String text) {
                this.fetchData(first: true);
              },
            ),
            AppBannerAd(adSize: AdSize.fullBanner),
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
      ),
    );
  }

  _buildList(dynamic item) {
    return JobTile(
      height: 100,
      jobId: item['id'],
      picture: getFirstImage(item['images']),
      title: item['title_en'],
      salarymax: item['salary_max'],
      salarymin: item['salary_min'],
      location: item['manpower']['location'],
      daysLeft: getTimeFormatted(item['expires_on']),
    );
  }

  _buildGrid(dynamic item) {
    return InkWell(
      onTap: () {
        Get.toNamed(VIEW_JOB, arguments: item['id']);
      },
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: getFirstImage(item['images']),
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
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.money,
                      color: Colors.green,
                      size: 11,
                    ),
                    TextFormatted(
                      text: " Salary (Nrs): ",
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 11,
                      ),
                    ),
                    TextFormatted(
                      text: item['salary_min'] + ' - ' + item['salary_max'],
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
              color: getTimeFormatted(item['expires_on'],
                      jsontype: true)['isCommingSoon']
                  ? Colors.red
                  : Theme.of(context).primaryColor,
              child: Center(
                child: TextFormatted(
                  text: getTimeFormatted(item['expires_on']),
                  textStyle: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
            height: 20,
            width: 100,
          )
        ],
      ),
    );
  }
}
