import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/utlis/global/textformfield.dart';
import 'package:baideshikrojgar/views/fragements/BannerAds.dart';
import 'package:baideshikrojgar/views/fragements/Reviews.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CompanyJobs extends StatefulWidget {
  @override
  _CompanyJobsState createState() => _CompanyJobsState();
}

class _CompanyJobsState extends State<CompanyJobs> {
  MainController mainController = Get.find();
  GlobalKey _scaffoldKey;
  ScrollController scrollController = ScrollController();
  TextEditingController searchTextController = TextEditingController(text: "");
  bool isGridView = false;
  List<dynamic> datas = [];
  Map details = Get.arguments;

  int selectedIndex = 0;
  double myRating = 1;
  List<dynamic> reviews = [];
  String reviewText = '';

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
          if (selectedIndex == 0) {
            this.fetchData();
          } else {
            this.fetchDataReviews();
          }
        }
      });
  }

  fetchData({bool first = false}) async {
    dynamic data = await this.mainController.fetchAllDatas(
          key: 'jobs_by_countries',
          first: first,
          path: first
              ? 'jobs_by_company/' +
                  details["id"].toString() +
                  '/' +
                  details['company']
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

  fetchDataReviews({bool first = false}) async {
    dynamic data = await this.mainController.fetchAllDatas(
          key: 'categories',
          first: first,
          path: first ? 'reviews/' + details["id"].toString() + '/company' : '',
        );
    if (first) {
      setState(() {
        reviews = [];
      });
    }
    for (var e in data) {
      if (e['user']['email'] == mainController.user.email.toString()) {
        setState(() {
          myRating = double.parse(e['rating'].toString());
          reviewText = e['review'];
        });
      }
    }
    setState(() {
      reviews = [...reviews, ...data];
    });
  }

  postRating() async {
    await this.mainController.apiController.postDataFuture({
      "rating": myRating,
      "review": reviewText,
    }, "/reviews/" + details["id"].toString() + "/company",
        message: "Posting rating...");
    setState(() {
      selectedIndex = 1;
    });
    this.fetchDataReviews(first: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton:
          !mainController.user.email.contains('demo@sajhajobs.com')
              ? FloatingActionButton.extended(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      title: "Rate this company",
                      dialogType: DialogType.NO_HEADER,
                      body: Center(
                        child: Column(
                          children: [
                            SimplePrimaryTitle(
                              title: "How is this company?",
                            ),
                            RatingBar.builder(
                              initialRating: myRating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                              itemSize: 40,
                              glowRadius: 1,
                              onRatingUpdate: (double rating) {
                                setState(() {
                                  myRating = rating;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            AppTextInputField(
                              hint: "Write your review.",
                              // icon: Icons.edit,
                              maxLine: 5,
                              border: true,
                              elevation: false,
                              textEditingController:
                                  TextEditingController(text: reviewText),
                              onTextChange: (String text) {
                                setState(() {
                                  reviewText = text;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: TextFormatted(
                                    text: "Cancel",
                                  ),
                                ),
                                FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    this.postRating();
                                    Get.back();
                                  },
                                  child: TextFormatted(
                                    text: "Rate",
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )..show();
                  },
                  label: Row(
                    children: [
                      Icon(Icons.star),
                      TextFormatted(
                        text: "Rate this company",
                      ),
                    ],
                  ),
                )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (int index) {
          if (index == 0) {
            this.fetchData(first: true);
          } else {
            this.fetchDataReviews(first: true);
          }
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Reviews',
            backgroundColor: Colors.pink,
          ),
        ],
      ),
      appBar: AppBar(
          title: TextFormatted(
            text: details['company'],
          ),
          actions: <Widget>[
            // Row(
            //   children: <Widget>[
            //     IconButton(
            //       icon: !isGridView ? Icon(Icons.grid_on) : Icon(Icons.list),
            //       onPressed: () {
            //         setState(() {
            //           isGridView = !isGridView;
            //         });
            //       },
            //     ),
            //   ],
            // ),
          ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // selectedIndex == 0
          //     ? CustomTextField(
          //         elevation: 1,
          //         hint: "Search jobs in: " + details['manpower'],
          //         radius: 0,
          //         textEditingController: searchTextController,
          //         onTextChange: (String text) {
          //           this.fetchData(first: true);
          //         },
          //       )
          //     : Container(),
          AppBannerAd(
            adSize: AdSize.fullBanner,
          ),
          details.containsKey('widget') && details['widget'] != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    details['widget'],
                    Divider(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: this.selectedIndex == 0
                          ? SimplePrimaryTitle(
                              title: "Active Jobs",
                            )
                          : SimplePrimaryTitle(
                              title: "Reviews",
                            ),
                    ),
                    Divider(
                      height: 10,
                    ),
                  ],
                )
              : SizedBox(
                  height: 1,
                ),
          datas.length == 0 && selectedIndex == 0
              ? Center(
                  child: Text("No jobs for this company."),
                )
              : SizedBox(
                  height: 1,
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
                  : selectedIndex == 0
                      ? ListView.separated(
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
                        )
                      : SingleChildScrollView(
                          controller: scrollController,
                          child: BaideshikRojgarReviews(
                              reviews: this.reviews,
                              fetchFunction: (bool first) {
                                this.fetchDataReviews(first: first);
                              }),
                        )),
        ],
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
