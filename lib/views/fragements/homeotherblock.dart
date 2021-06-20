import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:nice_button/NiceButton.dart';

class HomeOtherMenu extends StatelessWidget {
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: JOB_TILE_HEIGHT,
        padding: EdgeInsets.all(
          5,
        ),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int i) {
            return HomeOtherMenuTile(
              tile: this.mainController.homeOtherMenu[i],
            );
          },
          itemCount: this.mainController.homeOtherMenu.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class HomeOtherMenuTile extends StatelessWidget {
  HomeOtherMenuTile({
    this.tile,
  });
  final dynamic tile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(DIRECTORY_LISTING, arguments: {
          "title": this.tile['title'] ?? "TITLE",
          "id": this.tile['key'],
        });
      },
      child: CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage(
          this.tile['path'],
        ),
      ),
    );
  }
}

class HomeManpowerEmbassy extends StatelessWidget {
  final List manpowers, embassies, companies;
  HomeManpowerEmbassy({this.manpowers, this.embassies, this.companies});
  @override
  Widget build(BuildContext context) {
    List<Widget> allmanpowers = [];
    allmanpowers = this.manpowers.map((tile) {
      return JobTile(
        height: 90,
        divider: true,
        jobId: tile['id'],
        type: 'manpowerjobs',
        picture: tile['picture'],
        title: tile['title'],
        abstract: tile['abstract'],
        jobCount: tile['newjob'],
        childWidget: IgnorePointer(
          child: Row(
            children: [
              RatingBar.builder(
                initialRating: double.parse(tile['average'].toString()),
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
                text: "(" + tile['average'].toString() + "/5) ",
                textStyle: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
    List<Widget> allembassies = [];
    allembassies = this.embassies.map((tile) {
      return JobTile(
        divider: true,
        height: 90,
        type: 'html',
        html: tile['description_en'],
        picture: tile['picture'],
        title: tile['title'],
        location: tile['location'],
        contact: tile['contact'],
      );
    }).toList();
    List<Widget> allcompanies = [];
    allcompanies = this.companies.map((tile) {
      return JobTile(
        divider: true,
        height: 90,
        jobId: tile['id'],
        type: 'companiesjob',
        html: tile['description'],
        picture: tile['picture'],
        title: tile['title'],
        additionalheight: 60,
        otherChildWidget: Column(
          children: [
            TextFormatted(
              text: ((tile['average'] / 5) * 100).toString() +
                  '% people are satisfied.',
              textStyle: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
        childWidget: IgnorePointer(
          child: Row(
            children: [
              RatingBar.builder(
                initialRating: double.parse(tile['average'].toString()),
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
                text: "(" + tile['average'].toString() + "/5) ",
                textStyle: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
    return Container(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                indicatorColor: Theme.of(context).secondaryHeaderColor,
                tabs: [
                  Tab(
                    text: "म्यानपावरहरु",
                  ),
                  Tab(
                    text: "दुतावासहरु",
                  ),
                  Tab(
                    text: "कम्पनीहरु",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: (this.embassies.length > this.manpowers.length
                          ? this.embassies.length
                          : this.manpowers.length) *
                      90 +
                  JOB_TILE_HEIGHT,
              child: TabBarView(
                children: [
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ...allmanpowers,
                        Expanded(
                          child: NiceButton(
                            onPressed: () {
                              Get.toNamed(ALL_MANPOWER);
                            },
                            text: "View All",
                            fontSize: 12,
                            background: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ...allembassies,
                        Expanded(
                          child: NiceButton(
                            onPressed: () {
                              Get.toNamed(DIRECTORY_LISTING, arguments: {
                                'title': 'Embassy List',
                                'id': 5
                              });
                            },
                            text: "View All",
                            fontSize: 12,
                            background: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ...allcompanies,
                        Expanded(
                          child: NiceButton(
                            onPressed: () {
                              Get.toNamed(ALL_COMPANIES);
                            },
                            text: "View All",
                            fontSize: 12,
                            background: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HomeLTWorkPermit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(LT_WORKPERMIT_SEARCH,
                    arguments: {"type": LT_SEARCH, "data": ""});
              },
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormatted(
                            text: "LT Number",
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormatted(
                            text: "विज्ञापन पूर्व-स्वीकृति",
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(LT_WORKPERMIT_SEARCH,
                    arguments: {"type": PASSPORT_NO_SEARCH, "data": ""});
              },
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.contact_page_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormatted(
                            text: "Work Permit",
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormatted(
                            text: "श्रम स्वीकृति",
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
