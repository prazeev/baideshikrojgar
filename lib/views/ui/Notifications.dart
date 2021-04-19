import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  MainController mainController = Get.find();
  TabController _controller;
  ScrollController scrollControllerNotifications = ScrollController();
  ScrollController scrollControllerApplications = ScrollController();
  ScrollController scrollControllerSubscriptions = ScrollController();

  List notifications = [];
  List applications = [];
  List subscriptions = [];
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
    this.getAllNotifications(first: true);
    this.getAllApplications(first: true);
    this.getAllSubscriptions(first: true);
    super.initState();

    scrollControllerNotifications
      ..addListener(() {
        if (scrollControllerNotifications.position.pixels ==
            scrollControllerNotifications.position.maxScrollExtent) {
          this.getAllNotifications();
        }
      });
    scrollControllerApplications
      ..addListener(() {
        if (scrollControllerApplications.position.pixels ==
            scrollControllerApplications.position.maxScrollExtent) {
          this.getAllApplications();
        }
      });
    scrollControllerSubscriptions
      ..addListener(() {
        if (scrollControllerSubscriptions.position.pixels ==
            scrollControllerSubscriptions.position.maxScrollExtent) {
          this.getAllSubscriptions();
        }
      });
  }

  getAllNotifications({bool first = false}) async {
    dynamic data = await this.mainController.fetchAllDatas(
          key: 'jobs_by_countries',
          first: first,
          path: first ? 'notifications/all/1' : '',
        );
    if (first) {
      setState(() {
        notifications = [];
      });
    }
    setState(() {
      notifications = [...notifications, ...data];
    });
  }

  getAllApplications({bool first = false}) async {
    dynamic data = await this.mainController.fetchAllDatas(
          key: 'countries',
          first: first,
          path: first ? 'applications' : '',
        );
    if (first) {
      setState(() {
        applications = [];
      });
    }
    setState(() {
      applications = [...applications, ...data];
    });
  }

  getAllSubscriptions({bool first = false}) async {
    dynamic data = await this.mainController.fetchAllDatas(
          key: 'manpowers',
          first: first,
          path: first ? 'subscriptions' : '',
        );
    if (first) {
      setState(() {
        subscriptions = [];
      });
    }
    setState(() {
      subscriptions = [...subscriptions, ...data];
    });
  }

  deteleNotification(int index) async {
    String url = index == -1
        ? 'notifications/clear/'
        : 'notifications/clear/' + notifications[index]['id'].toString();
    dynamic data = await this.mainController.apiController.getDataFuture(url);
    dynamic d = json.decode(data.body);
    if (d['error']) {
      AwesomeDialog(
        context: Get.context,
        title: "Error",
        dialogType: DialogType.ERROR,
        desc: d['message'],
      )..show();
    } else {
      if (index != -1) {
        setState(() {
          notifications = List.from(notifications)..removeAt(index);
        });
      } else {
        setState(() {
          notifications = [];
        });
      }
    }
  }

  @override
  void dispose() {
    scrollControllerNotifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex == 0
          ? FlatButton(
              onPressed: () {
                deteleNotification(-1);
              },
              child: Text("Clear all"))
          : null,
      appBar: AppBar(
        title: TextNormal(
          text: "System panel",
        ),
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(
              text: "Notifications",
            ),
            Tab(
              text: "Application History",
            ),
            Tab(
              text: "Saved Items",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          getNotifications(),
          getApplications(),
          getSubscriptions(),
        ],
      ),
    );
  }

  getSubscriptions() {
    if (subscriptions.length == 0) {
      return Center(
        child: Text('No saved item in system.'),
      );
    }
    return ListView.separated(
      itemCount: this.subscriptions.length,
      controller: scrollControllerSubscriptions,
      itemBuilder: (BuildContext context, int i) {
        return subscriptionBuilder(subscriptions[i]);
      },
      separatorBuilder: (BuildContext context, int i) {
        return Divider(
          height: 1,
        );
      },
    );
  }

  subscriptionBuilder(dynamic data) {
    switch (data['subscribable_type']) {
      case 'App\\Jobs':
        return JobTile(
          jobId: data['model']['id'],
          type: 'job',
          height: 100,
          picture: getFirstImage(data['model']['images']),
          title: data['model']['title_en'],
          salarymax: data['model']['salary_max'].toString(),
          salarymin: data['model']['salary_min'].toString(),
          location: data['model']['company_name_en'],
        );
      case 'App\\Manpower':
        return JobTile(
          jobId: data['model']['id'],
          type: 'manpower',
          height: 100,
          picture: getFirstImage(data['model']['logo']),
          title: data['model']['name'],
          location: data['model']['address'],
          contact: data['model']['contact'],
          canCall: true,
        );
      default:
        return Text(data['subscribable_type']);
    }
  }

  getApplications() {
    if (applications.length == 0) {
      return Center(
        child: Text('No applications in system.'),
      );
    }
    return ListView.separated(
      itemCount: this.applications.length,
      controller: scrollControllerApplications,
      itemBuilder: (BuildContext context, int i) {
        return applicationBuilder(this.applications[i]);
      },
      separatorBuilder: (BuildContext context, int i) {
        return Divider(
          height: 1,
        );
      },
    );
  }

  applicationBuilder(dynamic data) {
    var reversedmessages = new List.from(data['message_history'].reversed);
    return ExpansionTile(
      title: Text(data['job']['title_en']),
      children: [
        JobTile(
          height: 100,
          title: data['manpower']['name'],
          picture: getFirstImage(data['manpower']['logo']),
          contact: data['manpower']['contact'],
          location: data['manpower']['address'],
          canCall: true,
        ),
        DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                child: TabBar(
                  tabs: [
                    Tab(
                      text: "Messages (" +
                          data['message_history'].length.toString() +
                          ")",
                    ),
                    Tab(
                      text: "Application Details",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: reversedmessages.map<Widget>((message) {
                          return ListTile(
                            title: Text(
                              message['message'],
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              child: CachedNetworkImage(
                                imageUrl: getFirstImage(
                                  data['manpower']['logo'],
                                ),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            subtitle: Text(
                              getTimeFormatted(
                                message['created_at'],
                              ),
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          FlatButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormatted(
                                  text: "Applied date: ",
                                ),
                                TextFormatted(
                                    text: getNiceDate(data['created_at'])),
                              ],
                            ),
                          ),
                          FlatButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormatted(
                                  text: "Edited date: ",
                                ),
                                TextFormatted(
                                    text: getNiceDate(data['updated_at'])),
                              ],
                            ),
                          ),
                          FlatButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormatted(
                                  text: "Applied positions: ",
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      data['positions'].map<Widget>((position) {
                                    return TextFormatted(
                                      text: position['title_en'],
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Get.toNamed(VIEW_JOB, arguments: data['job_id']);
                            },
                            child: Text(
                              "View Job",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  getNotifications() {
    if (notifications.length == 0) {
      return Center(
        child: Text('No notifications in system.'),
      );
    }
    return ListView.separated(
      itemCount: this.notifications.length,
      controller: scrollControllerNotifications,
      itemBuilder: (BuildContext context, int i) {
        return slideableBuilder(this.notifications[i]);
      },
      separatorBuilder: (BuildContext context, int i) {
        return Divider(
          height: 1,
        );
      },
    );
  }

  _handleTap(dynamic data) {
    switch (data['op']) {
      case "open page":
        if (data['params'].containsKey('params') &&
            data['params']['params'].containsKey('from') &&
            data['params']['params']['from'] == 'importantnews') {
          Get.toNamed(CATEGORY_NEWS_SAJHASABAL, arguments: {
            "title": "आधारभुत जानकारीहरु",
            "path": "foreign-jobs-information"
          });
        }
        if (data['params'].containsKey('params') &&
            data['params']['params'].containsKey('from') &&
            data['params']['params']['from'] == 'news') {
          Get.toNamed(CATEGORY_NEWS_SAJHASABAL,
              arguments: {"title": "समाचारहरु", "path": "updates_list"});
        }
        if (data['params'].containsKey('path') &&
            data['params']['path'] == 'ViewJob') {
          Get.toNamed(
            VIEW_JOB,
            arguments: int.parse(data['params']['params']['id']),
          );
        }
        break;
    }
  }

  slideableBuilder(dynamic data) {
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: () {
          _handleTap(data['data']);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.indigoAccent,
          child: Image.asset('assets/images/logo.png'),
          foregroundColor: Colors.white,
        ),
        isThreeLine: true,
        title: TextFormatted(
          maxline: 10,
          text: data['data']['title'].length > 0
              ? data['data']['title']
              : "Notification",
        ),
        trailing: (data['data']['op'] == 'open link')
            ? Column(
                children: [
                  FlatButton(
                    onPressed: () async {
                      String url = data['data']['params']['params']['url'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    child: Text("Open now"),
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ],
              )
            : FlatButton(
                child: Text(
                  'Clear',
                  // style: TextStyle(color: Colors.white),
                ),
                // color: Colors.red,
                onPressed: () {
                  deteleNotification(
                    notifications.indexOf(data),
                  );
                },
              ),
        // isThreeLine: true,
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormatted(
              text: data['data']['description'],
              maxline: 4,
            ),
            TextFormatted(
              text: getNiceDate(data['created_at']),
              maxline: 1,
              textStyle: TextStyle(
                color: Colors.green,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
    // return Slidable(
    //   actionPane: SlidableDrawerActionPane(),
    //   actionExtentRatio: 0.25,
    //   child: Container(
    //     color: Colors.white,
    //     child: ListTile(
    //       onTap: () {
    //         _handleTap(data['data']);
    //       },
    //       leading: CircleAvatar(
    //         backgroundColor: Colors.indigoAccent,
    //         child: Image.asset('assets/images/logo.png'),
    //         foregroundColor: Colors.white,
    //       ),
    //       title: TextFormatted(
    //         maxline: 10,
    //         text: data['data']['title'].length > 0
    //             ? data['data']['title']
    //             : "Notification",
    //       ),
    //       trailing: (data['data']['op'] == 'open link')
    //           ? FlatButton(
    //               onPressed: () async {
    //                 String url = data['data']['params']['params']['url'];
    //                 if (await canLaunch(url)) {
    //                   await launch(url);
    //                 }
    //               },
    //               child: Text("Open now"),
    //               color: Theme.of(context).secondaryHeaderColor,
    //             )
    //           : null,
    //       // isThreeLine: true,
    //       subtitle: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           TextFormatted(
    //             text: data['data']['description'],
    //             maxline: 4,
    //           ),
    //           TextFormatted(
    //             text: getNiceDate(data['created_at']),
    //             maxline: 1,
    //             textStyle: TextStyle(
    //               color: Colors.green,
    //               fontSize: 12,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   actions: <Widget>[
    //     IconSlideAction(
    //       caption: 'Delete',
    //       color: Colors.red,
    //       icon: Icons.delete,
    //       onTap: () {
    //         deteleNotification(notifications.indexOf(data));
    //       },
    //     ),
    //   ],
    // );
  }
}
