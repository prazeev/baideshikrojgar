import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/global/Accodain.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/utlis/global/textformfield.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:nice_button/NiceButton.dart';

class ApplyJob extends StatefulWidget {
  @override
  _ApplyJobState createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  dynamic data = Get.arguments;
  MainController mainController = Get.find();
  List _selectedPositions = [];
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController othermessagecontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (data['has_applied'] == 1) {
      setState(() {
        _selectedPositions =
            data['application']['positions'].map((e) => e['id']).toList();
      });
    }
    setState(() {
      fullnamecontroller = TextEditingController(
        text: mainController.user.name,
      );
      addresscontroller = TextEditingController(
        text: mainController.user.temporaryaddress,
      );
      phonenumbercontroller = TextEditingController(
        text: mainController.user.mobilenumber,
      );
      emailcontroller = TextEditingController(
        text: mainController.user.displayemail,
      );
    });
  }

  applyForJob() async {
    if (this.fullnamecontroller.text.trim().length < 5) {
      AwesomeDialog(
        context: Get.context,
        title: "Error",
        dialogType: DialogType.ERROR,
        desc: "Sorry, fullname must be more than 5 character.",
      )..show();
    } else if (this.addresscontroller.text.trim().length < 5) {
      AwesomeDialog(
        context: Get.context,
        title: "Error",
        dialogType: DialogType.ERROR,
        desc: "Sorry, address must be more than 5 character.",
      )..show();
    } else if (this.phonenumbercontroller.text.trim().length < 5) {
      AwesomeDialog(
        context: Get.context,
        title: "Error",
        dialogType: DialogType.ERROR,
        desc: "Sorry, phone number must be more than 5 character.",
      )..show();
    } else if (this.emailcontroller.text.trim().length < 5) {
      AwesomeDialog(
        context: Get.context,
        title: "Error",
        dialogType: DialogType.ERROR,
        desc: "Sorry, email must be more than 5 character.",
      )..show();
    } else if (_selectedPositions.length < 1) {
      AwesomeDialog(
        context: Get.context,
        title: "Error",
        dialogType: DialogType.ERROR,
        desc: "Sorry, atleast a position needs to be selected.",
      )..show();
    } else {
      var formdata =
          'Message: ${this.othermessagecontroller.text.trim()} <br>Full name: ${this.fullnamecontroller.text.trim()}<br>Email: ${this.emailcontroller.text.trim()}<br>Mobile Number: ${this.phonenumbercontroller.text.trim()}<br>Address: ${this.addresscontroller.text.trim()}';
      dynamic res = await this.mainController.apiController.postDataFuture({
        "additional_messages": formdata,
        "positions": _selectedPositions.join(","),
      }, '/job/' + this.data['id'].toString() + '/apply');
      dynamic response = json.decode(res.body);
      if (response['error']) {
        AwesomeDialog(
          context: Get.context,
          title: "Error",
          dialogType: DialogType.ERROR,
          desc: response['message'],
        )..show();
      } else {
        this.mainController.user.setName(this.fullnamecontroller.text.trim());
        this
            .mainController
            .user
            .setMobileNumber(this.phonenumbercontroller.text.trim());
        this
            .mainController
            .user
            .setTemporaryAddress(this.addresscontroller.text.trim());
        this
            .mainController
            .user
            .setDisplayEmail(this.emailcontroller.text.trim());
        Get.back(result: 'success');
        AwesomeDialog(
          context: Get.context,
          title: "Success",
          dialogType: DialogType.SUCCES,
          desc: response['message'],
        )..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Apply Job'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Stack(
          children: [
            ListView(
              children: [
                TextFormatted(
                  text: "You are applying for:",
                ),
                Divider(
                  height: 20,
                ),
                SimplePrimaryTitle(
                  title: data['title_en'],
                ),
                Divider(
                  height: 20,
                ),
                TextFormatted(
                  text:
                      "Please select desired position and click \"Apply\" to apply for this job.",
                  maxline: 2,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormatted(
                  text:
                      "Employeers are more attracted with user having updated profile.",
                  maxline: 2,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  height: 20,
                ),
                Container(
                  child: Column(
                    children: [
                      CustomTextField(
                        icon: Icons.people,
                        elevation: 10,
                        radius: 1,
                        hint: "Enter your full name here...",
                        textEditingController: fullnamecontroller,
                      ),
                      CustomTextField(
                        icon: Icons.local_activity,
                        elevation: 10,
                        radius: 1,
                        hint: "Enter your full address here...",
                        textEditingController: addresscontroller,
                      ),
                      CustomTextField(
                        icon: Icons.phone,
                        elevation: 10,
                        radius: 1,
                        keyboardType: TextInputType.phone,
                        hint: "Enter your phone number...",
                        textEditingController: phonenumbercontroller,
                      ),
                      CustomTextField(
                        icon: Icons.email,
                        elevation: 10,
                        radius: 1,
                        keyboardType: TextInputType.emailAddress,
                        hint: "Enter your email address...",
                        textEditingController: emailcontroller,
                      ),
                      MultiSelectBottomSheetField(
                        buttonText: Text(
                          "Click here for selecting desired positions",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        buttonIcon: Icon(
                          Icons.open_in_browser,
                          color: Colors.white,
                        ),
                        chipDisplay: MultiSelectChipDisplay(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Theme.of(context).primaryColor,
                          )),
                        ),
                        onConfirm: (values) {
                          setState(() {
                            _selectedPositions = values;
                          });
                        },
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(1),
                        ),
                        items: this
                            .data['positions']
                            .map<MultiSelectItem>(
                              (e) => MultiSelectItem(
                                e['id'],
                                e['title_en'],
                              ),
                            )
                            .toList(),
                        // icon: Icon(Icons.check),
                        searchable: true,
                        initialValue: _selectedPositions,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AppTextInputField(
                        border: true,
                        textEditingController: othermessagecontroller,
                        maxLine: 5,
                        keyboardType: TextInputType.emailAddress,
                        hint:
                            "Please describe any other message to manpower...",
                      ),
                    ],
                  ),
                ),
                JobTile(
                  picture: getFirstImage(data['manpower']['logo']),
                  // bigTitle: true,
                  height: 100,
                  title: data['manpower']['name'],
                  location: data['manpower']['location'],
                  contact: data['manpower']['contact'],
                  fontSize: 14,
                  canCall: true,
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: RaisedButton(
                onPressed: () {
                  this.applyForJob();
                },
                child: this.data['has_applied'] == 1
                    ? Text('Edit Application')
                    : Text('Apply now'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
