import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class JobTile extends StatefulWidget {
  final String picture,
      title,
      salarymin,
      salarymax,
      location,
      daysLeft,
      abstract,
      contact;
  final bool isBigImage;
  final int jobId, jobCount;
  final double height;
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
  });
  @override
  _JobTileState createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  height: this.widget.isBigImage ? 80 : 60,
                  width: this.widget.isBigImage ? 80 : 60,
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
                children: [
                  TextFormatted(
                    text: this.widget.title,
                    maxline: 2,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  this.widget.salarymin != '' && this.widget.salarymax != ''
                      ? Row(
                          children: [
                            Icon(
                              Icons.money,
                              color: Colors.green,
                              size: 13,
                            ),
                            TextFormatted(
                              text: " Salary (Nrs): ",
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                            TextFormatted(
                              text: this.widget.salarymin +
                                  ' - ' +
                                  this.widget.salarymax,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
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
                              size: 13,
                            ),
                            TextFormatted(
                              text: " " + this.widget.location,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  this.widget.abstract != ''
                      ? Expanded(
                          child: TextFormatted(
                            text: this.widget.abstract,
                            maxline: 3,
                            textStyle: TextStyle(fontSize: 12),
                          ),
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
                              size: 13,
                            ),
                            TextFormatted(
                              text: " " + this.widget.contact,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormatted(
                        text: this.widget.daysLeft,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.green,
                        ),
                      ),
                    ],
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
        ],
      ),
    );
  }
}
