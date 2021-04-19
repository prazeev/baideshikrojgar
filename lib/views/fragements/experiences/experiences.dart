import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/utlis/global/textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nice_button/NiceButton.dart';

class ExperienceAction extends StatefulWidget {
  @override
  _ExperienceActionState createState() => _ExperienceActionState();
}

class _ExperienceActionState extends State<ExperienceAction> {
  Map<String, dynamic> experience = Get.arguments;
  TextEditingController companyname;
  TextEditingController country;
  TextEditingController jobTitle;
  bool isnew = false;
  bool isWorking = false;
  int focusedResponsibility = 0;

  TextEditingController responsibilityTextField = new TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      isnew = !experience.isNullOrBlank ? false : true;
    });
    if (!isnew) {
      setState(() {
        companyname =
            TextEditingController(text: experience['company_name'].toString());
        jobTitle =
            TextEditingController(text: experience['job_title'].toString());
        country = TextEditingController(text: experience['country'].toString());
      });
      if ((experience['end_date'] ?? '').length == 0) {
        setState(() {
          isWorking = true;
        });
      }
    } else {
      experience = {
        'company_name': '',
        'country': '',
        'job_title': '',
        'responsibilities': '',
        'start_date': '',
        'end_date': ''
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    var responsibilities = experience['responsibilities']
        .split("-sajasabal-media-private-limited-usa-tokyo-");
    return Scaffold(
      appBar: AppBar(
        title: TextNormal(
          text: this.isnew ? "Add Experience" : "Edit Experience",
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
        ),
        child: ListView(
          children: [
            CustomTextField(
              textEditingController: companyname,
              hint: "Enter company name. Eg, Sajhasabal Media Pvt. Ltd.",
              icon: Icons.location_city,
              label: "Company name",
              radius: 1,
              elevation: 5,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              textEditingController: country,
              hint: "Enter country name.",
              icon: Icons.elevator_sharp,
              label: "Country",
              radius: 1,
              elevation: 5,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              textEditingController: jobTitle,
              hint: "Enter job title you are working on.",
              icon: Icons.elevator_sharp,
              label: "Job Title",
              radius: 1,
              elevation: 5,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  Dialog(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: [
                          Container(
                            height: 400,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: this.isnew
                                  ? DateTime.now()
                                  : DateTime.parse(experience['start_date']),
                              onDateTimeChanged: (DateTime newDateTime) {
                                String convertedDateTime =
                                    "${newDateTime.year.toString()}-${newDateTime.month.toString().padLeft(2, '0')}-${newDateTime.day.toString().padLeft(2, '0')}";
                                setState(() {
                                  experience['start_date'] = convertedDateTime;
                                });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: RaisedButton(
                              onPressed: () {
                                Get.back();
                              },
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text("Done"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: TextFormatted(
                      text: "Start at",
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    height: 25,
                  ),
                  Material(
                    elevation: 5,
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      padding: EdgeInsets.only(top: 10, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(experience['start_date'] ?? ''),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  Dialog(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: [
                          Container(
                            height: 400,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: this.isnew
                                  ? DateTime.now()
                                  : DateTime.parse(experience['end_date']),
                              onDateTimeChanged: (DateTime newDateTime) {
                                String convertedDateTime =
                                    "${newDateTime.year.toString()}-${newDateTime.month.toString().padLeft(2, '0')}-${newDateTime.day.toString().padLeft(2, '0')}";
                                setState(() {
                                  experience['end_date'] = convertedDateTime;
                                });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: RaisedButton(
                              onPressed: () {
                                Get.back();
                              },
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text("Done"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: TextFormatted(
                      text: "End at",
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    height: 25,
                  ),
                  Material(
                    elevation: 5,
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      padding: EdgeInsets.only(top: 10, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(experience['end_date'] ?? ''),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: TextFormatted(
                text: "Responsibilities",
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              height: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...responsibilities.map((e) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _handleResponsibilityAction(
                                responsibilities.indexOf(e), responsibilities);
                          },
                          child: Expanded(
                            child: TextNormal(
                              text: e,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _handleResponsibilityDeleteAction(
                                  responsibilities.indexOf(e),
                                  responsibilities);
                            })
                      ],
                    ),
                  );
                }).toList()
              ],
            ),
            SizedBox(
              width: 20,
              child: ElevatedButton(
                onPressed: () {
                  _handleResponsibilityAction(-1, responsibilities);
                },
                child: Text("+ Add more responsibility"),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            NiceButton(
              onPressed: () {},
              text: isnew ? "Add Experience" : "Edit Experience",
              background: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }

  _handleResponsibilityDeleteAction(int index, dynamic responsibilities) {
    AwesomeDialog(
      context: context,
      borderSide: BorderSide(color: Colors.green, width: 2),
      width: 280,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Warning',
      desc: 'Are you sure, you want to remove this responsibility?',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        responsibilities.removeAt(index);
        setState(() {
          experience['responsibilities'] = responsibilities
              .join("-sajasabal-media-private-limited-usa-tokyo-");
        });
      },
    )..show();
  }

  _handleResponsibilityAction(int index, dynamic responsibilities) {
    setState(() {
      focusedResponsibility = index;
      responsibilityTextField = TextEditingController(
          text: index >= 0 ? responsibilities[index] : '');
    });
    Get.dialog(
      Dialog(
        child: Container(
          height: 180,
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              TextFormField(
                minLines: 2,
                controller: responsibilityTextField,
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText:
                      'Add your responsibility as ' + experience['job_title'],
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: RaisedButton(
                  onPressed: () {
                    if (responsibilityTextField.text.trim().length == 0) return;
                    if (focusedResponsibility == -1) {
                      responsibilities.add(responsibilityTextField.text);
                      setState(() {
                        experience['responsibilities'] = responsibilities.join(
                            "-sajasabal-media-private-limited-usa-tokyo-");
                      });
                    } else {
                      responsibilities[focusedResponsibility] =
                          responsibilityTextField.text;
                      setState(() {
                        experience['responsibilities'] = responsibilities.join(
                            "-sajasabal-media-private-limited-usa-tokyo-");
                      });
                    }
                    Get.back();
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("Done"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
