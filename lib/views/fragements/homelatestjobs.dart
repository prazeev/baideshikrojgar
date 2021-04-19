import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLatestJobs extends StatefulWidget {
  final List jobs;
  HomeLatestJobs({this.jobs});
  @override
  _HomeLatestJobsState createState() => _HomeLatestJobsState();
}

class _HomeLatestJobsState extends State<HomeLatestJobs> {
  @override
  Widget build(BuildContext context) {
    List homelatestjobs = this.widget.jobs.map<Widget>((dynamic job) {
      return JobTile(
        height: 80,
        divider: true,
        type: 'job',
        picture: job['picture'],
        jobId: job['id'],
        title: job['title'],
        salarymax: job['salarymax'],
        salarymin: job['salarymin'],
        // location: job['location'],
        daysLeft: job['daysLeft'],
      );
    }).toList();

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
              RaisedButton(
                child: ViewAllButton(),
                onPressed: () => Get.toNamed(ALL_JOBS),
              )
            ],
          ),
        ),
        Column(
          children: [...homelatestjobs],
        ),
      ],
    );
  }
}

class ViewAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
