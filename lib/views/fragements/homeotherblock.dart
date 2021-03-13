import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:flutter/material.dart';
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
    return CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage(
        this.tile['path'],
      ),
    );
  }
}

class HomeManpowerEmbassy extends StatelessWidget {
  final MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
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
                ],
              ),
            ),
            Container(
              height:
                  this.mainController.homeManpowers.length * JOB_TILE_HEIGHT +
                      JOB_TILE_HEIGHT +
                      (this.mainController.homeManpowers.length * 1.5),
              child: TabBarView(
                children: [
                  ListView.separated(
                    itemBuilder: (BuildContext context, int i) {
                      dynamic tile = this.mainController.homeManpowers[i];
                      if (i == this.mainController.homeManpowers.length - 1) {
                        return Column(
                          children: [
                            JobTile(
                              picture: tile['picture'],
                              title: tile['title'],
                              location: tile['location'],
                              contact: tile['contact'],
                              jobCount: 5,
                            ),
                            NiceButton(
                              onPressed: () {},
                              text: 'View all',
                              elevation: 0,
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                              ),
                              fontSize: 14,
                              width: double.infinity,
                              background: Theme.of(context).primaryColor,
                            ),
                          ],
                        );
                      }
                      return JobTile(
                        picture: tile['picture'],
                        title: tile['title'],
                        location: tile['location'],
                        contact: tile['contact'],
                        jobCount: 5,
                      );
                    },
                    separatorBuilder: (BuildContext context, int i) {
                      return Divider(
                        height: 1.5,
                      );
                    },
                    itemCount: this.mainController.homeManpowers.length,
                  ),
                  ListView.separated(
                    itemBuilder: (BuildContext context, int i) {
                      dynamic tile = this.mainController.homeEmbassies[i];
                      if (i == this.mainController.homeEmbassies.length - 1) {
                        return Column(
                          children: [
                            JobTile(
                              picture: tile['picture'],
                              title: tile['title'],
                              location: tile['location'],
                              contact: tile['contact'],
                            ),
                            NiceButton(
                              onPressed: () {},
                              text: 'View all',
                              elevation: 0,
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                              ),
                              fontSize: 14,
                              width: double.infinity,
                              background: Theme.of(context).primaryColor,
                            ),
                          ],
                        );
                      }
                      return JobTile(
                        picture: tile['picture'],
                        title: tile['title'],
                        location: tile['location'],
                        contact: tile['contact'],
                      );
                    },
                    separatorBuilder: (BuildContext context, int i) {
                      return Divider(
                        height: 1.5,
                      );
                    },
                    itemCount: this.mainController.homeEmbassies.length,
                  ),
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
          Expanded(
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
          )
        ],
      ),
    );
  }
}
