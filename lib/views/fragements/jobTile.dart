import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class JobTile extends StatefulWidget {
  final String picture,
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
  final bool isBigImage, bigTitle, divider, canCall;
  final dynamic jobId, jobCount;
  final double height, fontSize;
  JobTile({
    this.picture = '',
    this.title = '',
    this.salarymax = '',
    this.salarymin = '',
    this.daysLeft = '',
    this.location = '',
    this.contact = '',
    this.height = 70.00,
    this.isBigImage = false,
    this.abstract = '',
    this.jobId = 0,
    this.jobCount = 0,
    this.dateField = '',
    this.type = 'job',
    this.bigTitle = false,
    this.canCall = false,
    this.html = '',
    this.divider = false,
    this.fontSize = 13,
  });
  @override
  _JobTileState createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          });
        }
        if (this.widget.type == "job") {
          print(this.widget.jobId);
          Get.toNamed(VIEW_JOB, arguments: this.widget.jobId);
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
              color: Colors.white,
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
                    : SizedBox(
                        height: 1,
                      ),
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
                            : SizedBox(
                                height: 1,
                              ),
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
                            : SizedBox(
                                height: 1,
                              ),
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
                            : SizedBox(
                                height: 1,
                              ),
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
                            : SizedBox(
                                height: 1,
                              ),
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
                            : SizedBox(
                                height: 1,
                              ),
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
                            : SizedBox(
                                height: 1,
                              ),
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
