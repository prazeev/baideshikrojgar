import 'package:audio_service/audio_service.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class JobTile extends StatefulWidget {
  final String picture,
      smallpicture,
      title,
      salarymin,
      salarymax,
      location,
      daysLeft,
      abstract,
      type,
      html,
      dateField,
      contact;
  final Widget otherChildWidget;
  final Color bgcolor;
  final bool isBigImage, bigTitle, divider, canCall, tyle;
  final dynamic jobId, jobCount;
  final double height, fontSize, additionalheight;
  final Widget childWidget;
  JobTile({
    this.picture = '',
    this.smallpicture = '',
    this.otherChildWidget,
    this.title = '',
    this.salarymax = '',
    this.salarymin = '',
    this.daysLeft = '',
    this.location = '',
    this.contact = '',
    this.height = 70.00,
    this.isBigImage = false,
    this.tyle = false,
    this.abstract = '',
    this.jobId = 0,
    this.jobCount = 0,
    this.dateField = '',
    this.type = 'job',
    this.bigTitle = false,
    this.childWidget,
    this.additionalheight = 0,
    this.canCall = false,
    this.html = '',
    this.divider = false,
    this.fontSize = 13,
    this.bgcolor = Colors.transparent,
  });
  @override
  _JobTileState createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (this.widget.type == "country") {
          Get.toNamed(COUNTRIES_JOBS, arguments: {
            "country_id": this.widget.jobId,
            "country_name": this.widget.title
          });
        }
        if (this.widget.type == "categories") {
          Get.toNamed(CATEGORIES_JOBS, arguments: {
            "category_id": this.widget.jobId,
            "category_name": this.widget.title
          });
        }
        if (this.widget.type == "html") {
          Get.toNamed(VIEW_HTML, arguments: {
            "title": this.widget.title,
            "html": this.widget.html,
            "showAds":
                this.widget.picture.contains('sajhasabal.com') ? false : true,
          });
        }
        if (this.widget.type == "job") {
          Get.toNamed(VIEW_JOB, arguments: this.widget.jobId);
        }
        if (this.widget.type == "radio") {
          AudioService.skipToQueueItem(this.widget.jobId);
        }
        if (this.widget.type == "manpower") {
          Get.toNamed(MANPOWER_SINGLE, arguments: {
            "id": this.widget.jobId,
            "title": this.widget.title,
          });
        }
        if (this.widget.type == "manpowerjobs") {
          Get.toNamed(MANPOWER_JOBS, arguments: {
            "manpower": this.widget.title,
            "id": this.widget.jobId,
            "widget": JobTile(
              height: this.widget.height + this.widget.additionalheight,
              childWidget: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      this.widget.childWidget,
                      this.widget.otherChildWidget == null
                          ? Container()
                          : this.widget.otherChildWidget
                    ],
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            // TextFormatted(
                            //   text: "Go to direction",
                            //   textStyle: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 10,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: this.widget.title,
              abstract: this.widget.abstract,
              location: this.widget.location,
              contact: this.widget.contact,
              picture: this.widget.picture,
              jobId: this.widget.jobId,
              canCall: true,
              type: "manpower",
            ),
          });
        }
        if (this.widget.type == "companiesjob") {
          Get.toNamed(COMPANY_JOBS, arguments: {
            "company": this.widget.title,
            "id": this.widget.jobId,
            "widget": Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobTile(
                  height: this.widget.height + this.widget.additionalheight,
                  childWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      this.widget.childWidget,
                      this.widget.otherChildWidget == null
                          ? Container()
                          : this.widget.otherChildWidget
                    ],
                  ),
                  title: this.widget.title,
                  abstract: this.widget.abstract,
                  location: this.widget.location,
                  contact: this.widget.contact,
                  picture: this.widget.picture,
                  jobId: this.widget.jobId,
                  canCall: true,
                  type: "manpower",
                ),
              ],
            ),
          });
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 5,
              right: 5,
              top: 3,
              bottom: 3,
            ),
            height: this.widget.height == JOB_TILE_HEIGHT
                ? JOB_TILE_HEIGHT
                : this.widget.height,
            decoration: BoxDecoration(
              color: this.widget.bgcolor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                this.widget.picture != ''
                    ? CachedNetworkImage(
                        imageUrl: this.widget.picture,
                        imageBuilder: (context, imageProvider) => Container(
                          height: this.widget.isBigImage ? 100 : 80,
                          width: this.widget.isBigImage ? 100 : 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        // fit: BoxFit.cover,
                      )
                    : Container(),
                this.widget.smallpicture != ''
                    ? CachedNetworkImage(
                        imageUrl: this.widget.smallpicture,
                        height: 40,
                        width: 40,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        // fit: BoxFit.cover,
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormatted(
                          text: this.widget.title,
                          maxline: 2,
                          textStyle: this.widget.bigTitle
                              ? TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: Colors.black,
                                )
                              : TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: this.widget.fontSize,
                                  color: Colors.black,
                                ),
                        ),
                        this.widget.salarymin != '' &&
                                this.widget.salarymax != ''
                            ? Row(
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
                                    text: this.widget.salarymin +
                                        ' - ' +
                                        this.widget.salarymax,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 11,
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        this.widget.abstract != ''
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextFormatted(
                                      maxline: 2,
                                      text: " " + this.widget.abstract,
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        this.widget.location != ''
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    color: Colors.green,
                                    size: 11,
                                  ),
                                  Expanded(
                                    child: TextFormatted(
                                      maxline: 2,
                                      text: " " + this.widget.location,
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        this.widget.contact != ''
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: Colors.green,
                                    size: 11,
                                  ),
                                  Expanded(
                                    child: TextFormatted(
                                      maxline: 2,
                                      text: " " + this.widget.contact,
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        this.widget.daysLeft.length > 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextFormatted(
                                    text: "Expires: ",
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: Colors.green,
                                    ),
                                  ),
                                  TextFormatted(
                                    text: this.widget.daysLeft,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        this.widget.dateField.length > 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextFormatted(
                                    text: this.widget.daysLeft,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        this.widget.childWidget != null
                            ? this.widget.childWidget
                            : Container(),
                      ],
                    ),
                  ),
                ),
                this.widget.jobCount > 0
                    ? CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: TextFormatted(
                          text: this.widget.jobCount.toString(),
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 1,
                      ),
                this.widget.canCall && this.widget.contact.length > 0
                    ? Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FlatButton(
                          onPressed: () async {
                            List numbers = this.widget.contact.split(",");
                            if (numbers.length > 0) {
                              String number = numbers[0].toString();
                              String url = 'tel:' + number;
                              if (await canLaunch(url)) {
                                await launch(url);
                              }
                            }
                          },
                          child: Icon(Icons.call, color: Colors.white),
                        ),
                      )
                    : SizedBox(
                        height: 1,
                      ),
              ],
            ),
          ),
          this.widget.divider
              ? Divider(
                  height: 1,
                )
              : SizedBox(
                  height: 1,
                )
        ],
      ),
    );
  }
}
