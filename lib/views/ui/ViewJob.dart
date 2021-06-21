import 'dart:convert';

import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/shimmer.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/BannerAds.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:baideshikrojgar/views/ui/LTWorkPermitSearch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewJob extends StatefulWidget {
  @override
  _ViewJobState createState() => _ViewJobState();
}

class _ViewJobState extends State<ViewJob> {
  Map data = {
    "title_en": "...",
    "description_en": "...",
  };
  int jobid = Get.arguments;
  MainController mainController = Get.find();
  String title = "View Post";
  bool isError = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchJob(jobid);
  }

  fetchJob(int id) async {
    setState(() {
      isLoading = true;
    });
    dynamic res = await this.mainController.apiController.getDataFuture(
          'view_job/' + id.toString(),
          ignoreOffline: this.mainController.isInternetConnected,
        );
    var d = json.decode(res.body);
    if (d['error']) {
      setState(() {
        isError = true;
      });
    } else {
      setState(() {
        isError = false;
        data = d['data'];
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Fetching..."),
        ),
        body: SimmerLoading(
          loadingCount: 30,
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton:
          this.data['manpower']['is_promoted'] > 0 && !this.data['has_expired']
              ? data['has_applied'] == 1
                  ? FloatingActionButton.extended(
                      onPressed: () async {
                        var data =
                            await Get.toNamed(APPLY_JOB, arguments: this.data);
                        if (data == 'success') {
                          fetchJob(jobid);
                        }
                      },
                      label: Text('Edit Application'),
                    )
                  : FloatingActionButton.extended(
                      onPressed: () async {
                        var data =
                            await Get.toNamed(APPLY_JOB, arguments: this.data);
                        if (data == 'success') {
                          fetchJob(jobid);
                        }
                      },
                      label: Text('Apply now'),
                    )
              : null,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: TextFormatted(
              text: data['title_en'],
            ),
            floating: true,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {
                  Share.share(
                    data['title_en'] +
                        ' http://sajhajobs.com/jobs/' +
                        data['id'].toString(),
                    subject: "Wow, did you see that?",
                  );
                },
              ),
              data['is_subscribed']
                  ? IconButton(
                      icon: Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        this.mainController.unsubscribeModel("job", data['id']);
                        setState(() {
                          data['is_subscribed'] = !data['is_subscribed'];
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.star_border_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        this.mainController.subscribeModel("job", data['id']);
                        setState(() {
                          data['is_subscribed'] = !data['is_subscribed'];
                        });
                      },
                    ),
            ],
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 190.00,
            flexibleSpace: getFlexibleAppBar(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              AppBannerAd(adSize: AdSize.leaderboard),
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                child: getJobDetails(),
              ),
              Divider(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                height: 5,
              ),
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                child: getJobInfoBlock(),
              ),
              Divider(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                height: 5,
              ),
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                child: getOtherFacilities(),
              ),
              Divider(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                height: 5,
              ),
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                child: getOtherQualifications(),
              ),
              Divider(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                height: 5,
              ),
              Container(
                // color: Theme.of(context).primaryColor.withOpacity(0.08),
                child: getViewInfo(),
              ),
              Divider(
                // color: Theme.of(context).primaryColor.withOpacity(0.08),
                height: 5,
              ),
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                child: getUserDesclimerInfo(),
              ),
              Divider(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                height: 5,
              ),
              Container(
                // color: Theme.of(context).primaryColor.withOpacity(0.08),
                child: getContactDetails(),
              ),
              SizedBox(
                height: 40,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget getUserDesclimerInfo() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormatted(
            text:
                "Information provided by the Department of Foreign Employment",
            maxline: 2,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
          TextFormatted(
            text:
                "If you are thinking about foreign employment, following instruction is important:",
            maxline: 2,
          ),
          TextFormatted(
            text: " - Always check the LT detail before applying.",
            maxline: 5,
          ),
          TextFormatted(
            text:
                " - Know about the remaining quota before applying. Quota might have been finished.",
            maxline: 5,
          ),
          TextFormatted(
            maxline: 5,
            text:
                " - Know about the status and transaction history of Recruiting Agency and Foreign employer. You may use Google to search for it.",
          ),
        ],
      ),
    );
  }

  Widget getContactDetails() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SimplePrimaryTitle(
            title: "Contact Us",
          ),
          JobTile(
            height: 100,
            divider: true,
            canCall: true,
            title: data['manpower']['name'],
            fontSize: 14,
            jobId: data['manpower']['id'],
            type: 'manpowerjobs',
            picture: getFirstImage(data['manpower']['logo']),
            location: data['manpower']['location'],
            contact: data['manpower']['contact'],
            otherChildWidget: Column(
              children: [
                TextFormatted(
                  text: ((data['manpower']['average'] / 5) * 100).toString() +
                      '% people are satisfied.',
                  textStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
            additionalheight: 50,
            childWidget: IgnorePointer(
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating:
                        double.parse(data['manpower']['average'].toString()),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                    ),
                    itemSize: 20,
                    glowRadius: 1,
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  TextFormatted(
                    text: "(" + data['manpower']['average'].toString() + "/5) ",
                    textStyle: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getViewInfo() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: FlatButton(
              onPressed: () {
                Get.toNamed(VIEW_HTML, arguments: {
                  "title": this.data['title_en'],
                  "html": this.data['description_en'],
                });
              },
              child: Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_to_home_screen,
                      size: 40,
                      color: Colors.green,
                    ),
                    TextFormatted(
                      text: "Ads view",
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: FlatButton(
              onPressed: () async {
                String url =
                    BASE_URL_FULL + 'jobs/' + this.data['id'].toString();
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              child: Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Icon(
                      Icons.web_sharp,
                      size: 40,
                      color: Colors.green,
                    ),
                    TextFormatted(
                      text: "Web view",
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getOtherQualifications() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimplePrimaryTitle(
              title: "Other Qualifications",
            ),
            Html(data: this.data['other_qualifications']),
          ],
        ),
      ),
    );
  }

  Widget getOtherFacilities() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimplePrimaryTitle(
              title: "Other Facilities",
            ),
            Html(data: this.data['other_facilities']),
          ],
        ),
      ),
    );
  }

  Widget getJobDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimplePrimaryTitle(
              title: "Job Details",
            ),
            Container(
              padding: EdgeInsets.only(
                left: 5,
              ),
              child: Wrap(
                children: this.data['lt_number'].split(',').map<Widget>((lt) {
                  return Container(
                    margin: EdgeInsets.only(right: 5),
                    child: FlatButton(
                      color: Colors.red,
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(1),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            content: LTSearchResult(lt),
                            actions: [
                              FlatButton(
                                onPressed: () => Navigator.pop(
                                    context, true), // passing true
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          TextFormatted(
                            text: "LT: ",
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          TextFormatted(
                            text: lt,
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            DataTable(columns: <DataColumn>[
              DataColumn(
                label: TextFormatted(
                  text: "Particulars",
                ),
              ),
              DataColumn(
                label: TextFormatted(
                  text: "Details",
                ),
              ),
            ], rows: <DataRow>[
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Company Name",
                  ),
                ),
                DataCell(
                  TextFormatted(
                    text: this.data['company_name_en'],
                  ),
                ),
              ]),
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Country",
                  ),
                ),
                DataCell(
                  TextFormatted(
                    text: this.data['country']['title_en'],
                  ),
                ),
              ]),
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Visa Ticket",
                  ),
                ),
                DataCell(
                  TextFormatted(
                    text: getYesNoLabel(this.data['visa_ticket']),
                  ),
                ),
              ]),
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Minimum Qualification",
                  ),
                ),
                DataCell(
                  TextFormatted(
                    text: getMinimumQualification(
                        this.data['minimum_qualification']),
                  ),
                ),
              ]),
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Working Experience",
                  ),
                ),
                DataCell(
                  TextFormatted(
                    text: getMinimumQualification(
                        this.data['working_experience']),
                  ),
                ),
              ]),
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Food",
                  ),
                ),
                DataCell(
                  TextFormatted(
                    text: getYesNoLabel(this.data['food']),
                  ),
                ),
              ]),
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Accomodation",
                  ),
                ),
                DataCell(
                  TextFormatted(
                    text: getYesNoLabel(this.data['accommodation']),
                  ),
                ),
              ]),
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Pre-medical in Nepal",
                  ),
                ),
                DataCell(
                  TextFormatted(
                    text: getYesNoLabel(this.data['pre_medical_in_nepal']),
                  ),
                ),
              ]),
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Contract Period (in yrs)",
                  ),
                ),
                DataCell(
                  TextFormatted(
                    text: this.data['contract_period'],
                  ),
                ),
              ]),
              DataRow(cells: [
                DataCell(
                  TextFormatted(
                    text: "Apply Before",
                  ),
                ),
                DataCell(
                  CountdownTimer(
                    endTime: getTimeInSeconds(this.data['expires_on']),
                  ),
                ),
              ]),
            ])
          ],
        ),
      ),
    );
  }

  Widget getJobInfoBlock() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimplePrimaryTitle(
              title: "Quota Details",
            ),
            DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: TextFormatted(
                    text: "Position",
                  ),
                ),
                DataColumn(
                  label: TextFormatted(
                    text: "Male",
                  ),
                ),
                DataColumn(
                  label: TextFormatted(
                    text: "Female",
                  ),
                ),
                DataColumn(
                  label: TextFormatted(
                    text: "Salary",
                  ),
                ),
              ],
              rows: this.data['positions'].map<DataRow>((element) {
                return DataRow(cells: <DataCell>[
                  DataCell(
                    TextFormatted(
                      text: element['title_en'],
                    ),
                  ),
                  DataCell(
                    TextFormatted(
                      text: element['pivot']['male_required'].toString(),
                    ),
                  ),
                  DataCell(
                    TextFormatted(
                      text: element['pivot']['female_required'].toString(),
                    ),
                  ),
                  DataCell(
                    TextFormatted(
                      text: element['pivot']['salary'].toString(),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFlexibleAppBar() {
    return FlexibleSpaceBar(
      background: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: CachedNetworkImageProvider(
        //       getImageFromString(
        //         data['description_en'],
        //       ),
        //     ),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
          ),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  color: Colors.blue[900].withOpacity(0.8),
                  padding: EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    height: 100,
                    imageUrl: getFirstImage(data['manpower']['logo']),
                  ),
                ),
                Container(
                  height: 116,
                  width: MediaQuery.of(context).size.width - 100 - 8 - 10,
                  color: Colors.blue[900].withOpacity(0.8),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormatted(
                        text: data['title_en'],
                        maxline: 2,
                        textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Colors.white,
                          ),
                          data['has_expired']
                              ? TextFormatted(
                                  text: 'Expired',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                )
                              : TextFormatted(
                                  text: data['remaining_days_nice'].toString(),
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                          Row(
                            children: [
                              Text(
                                " | ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.remove_red_eye_sharp,
                                color: Colors.white,
                                size: 14,
                              ),
                              TextFormatted(
                                text: " " + data['views'].toString() + ' views',
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
