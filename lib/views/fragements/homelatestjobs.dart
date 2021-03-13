import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nice_button/NiceButton.dart';

class HomeLatestJobs extends StatefulWidget {
  @override
  _HomeLatestJobsState createState() => _HomeLatestJobsState();
}

class _HomeLatestJobsState extends State<HomeLatestJobs> {
  MainController mainController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormatted(
                text: "Latest Jobs",
              ),
              ViewAllButton(
                onPressed: () {},
              ),
            ],
          ),
        ),
        SizedBox(
          height: JOB_TILE_HEIGHT * this.mainController.homeLatestJobs.length +
              (this.mainController.homeLatestJobs.length * 1.5),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int i) {
              dynamic job = this.mainController.homeLatestJobs[i];
              return JobTile(
                picture: job['picture'],
                title: job['title'],
                salarymax: job['salarymax'],
                salarymin: job['salarymin'],
                location: job['location'],
                daysLeft: job['daysLeft'],
              );
            },
            separatorBuilder: (BuildContext context, int i) {
              return Divider(
                height: 1.5,
                color: Theme.of(context).secondaryHeaderColor,
              );
            },
            itemCount: this.mainController.homeLatestJobs.length,
          ),
        ),
      ],
    );
  }
}

class ViewAllButton extends StatelessWidget {
  final dynamic onPressed;
  ViewAllButton({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPressed(),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            ),
            TextFormatted(
              text: " View all",
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
