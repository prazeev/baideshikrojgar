import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  MainController mainController = Get.find();
  TabController _tabController;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 5)
      ..addListener(() {
        setState(() {
          currentTab = _tabController.index.toInt();
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getHeaderTitle(),
        ),
      ),
      floatingActionButton: currentTab > 0
          ? FloatingActionButton(
              elevation: 10.0,
              child: Icon(
                Icons.add,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                switch (currentTab) {
                  case 1:
                    Get.toNamed(UPDATE_EXPERIENCE, arguments: null);
                    break;
                }
              },
            )
          : SizedBox(
              height: 1,
            ),
      body: TabBarView(
        controller: _tabController,
        children: [
          getBasicInformation(),
          getWorkExperience(),
          Text('A'),
          Text('A'),
          Text('A'),
        ],
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Basic".tr,
              icon: Icon(Icons.perm_contact_calendar),
            ),
            Tab(
              text: "Experience".tr,
              icon: Icon(Icons.work),
            ),
            Tab(
              text: "Training".tr,
              icon: Icon(Icons.model_training),
            ),
            Tab(
              text: "Education".tr,
              icon: Icon(Icons.school),
            ),
            Tab(
              text: "Language".tr,
              icon: Icon(Icons.g_translate),
            ),
          ],
        ),
      ),
    );
  }

  getHeaderTitle() {
    switch (currentTab) {
      case 1:
        return [
          TextFormatted(
            text: "Work Experiences",
          ),
        ];
        break;
      default:
        return [
          Text(
            mainController.user.name,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          Text(
            mainController.user.email,
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          )
        ];
    }
  }

  getWorkExperience() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int i) {
        return _buildExperienceRow(this.mainController.user.experiences[i]);
      },
      separatorBuilder: (BuildContext context, int i) {
        return Divider(
          height: 1,
          color: Theme.of(context).secondaryHeaderColor,
        );
      },
      itemCount: this.mainController.user.experiences.length,
    );
  }

  _buildExperienceRow(dynamic experience) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormatted(
                text: experience['company_name'].toString(),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem(
                      value: 'edit-experience-' + experience['id'].toString(),
                      child: TextNormal(
                        text: "Edit",
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete-experience-' + experience['id'].toString(),
                      child: TextNormal(
                        text: "Delete",
                      ),
                    ),
                  ];
                },
                onSelected: (String value) {
                  List values = value.split('-experience-');
                  bool isEdit = (values[0] == 'edit');
                  bool isDelete = (values[0] == 'delete');
                  if (isEdit) {
                    Get.toNamed(UPDATE_EXPERIENCE, arguments: experience);
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          TextFormatted(
            text: experience['job_title'].toString(),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_city,
                    color: Colors.black,
                  ),
                  TextFormatted(
                    text: " " + experience['country'].toString(),
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.black,
                  ),
                  TextFormatted(
                    text: " " + experience['start_date'].toString(),
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  TextNormal(
                    text: ' to ',
                  ),
                  experience['end_date'] == ''
                      ? TextFormatted(
                          text: "now",
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        )
                      : TextFormatted(
                          text: " " + experience['end_date'].toString(),
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              ...experience['responsibilities']
                  .toString()
                  .split("-sajasabal-media-private-limited-usa-tokyo-")
                  .map((e) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restore_page_rounded,
                        color: Colors.white,
                      ),
                      TextFormatted(
                        text: " " + e.toString(),
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()
            ],
          ),
        ],
      ),
    );
  }

  getBasicInformation() {
    return ListView(
      children: [
        renderProfilePicture(),
        renderNameBlock(),
        Container(
          height: 40,
          color: Colors.white,
        ),
        renderBasicInformationBlock(),
        renderPassportInformationBlock(),
        renderMoreInformationBlock(),
      ],
    );
  }

  _getBasicInfoRow({String title, String value, String key = '-'}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: TextFormatted(
              text: title,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                TextFormatted(text: value),
                InkWell(
                  child: Icon(
                    Icons.edit,
                    size: 18.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  renderBasicInformationBlock() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 40,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: TextFormatted(
                text: "Basic Information",
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _getBasicInfoRow(
            title: "Email",
            value: mainController.user.email,
            key: 'email',
          ),
          _getBasicInfoRow(
            title: "Mobile number",
            value: mainController.user.mobilenumber,
            key: 'mobile_number',
          ),
          _getBasicInfoRow(
            title: "Birthdate",
            value: mainController.user.birthdate,
            key: 'dob',
          ),
          _getBasicInfoRow(
            title: "Gender",
            value: mainController.user.gender.toString(),
            key: 'gender',
          ),
          _getBasicInfoRow(
            title: "Address (P)",
            value: mainController.user.permanentaddress,
            key: 'pa',
          ),
          _getBasicInfoRow(
            title: "Address (T)",
            value: mainController.user.temporaryaddress,
            key: 'ta',
          ),
        ],
      ),
    );
  }

  renderPassportInformationBlock() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 40,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: TextFormatted(
                text: "Passport Information",
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _getBasicInfoRow(
            title: "Passport number",
            value: mainController.user.passportno,
            key: 'passport_number',
          ),
          _getBasicInfoRow(
            title: "Passport expiry date",
            value: mainController.user.passportexpiry,
            key: 'passport_expiry_date',
          ),
        ],
      ),
    );
  }

  renderMoreInformationBlock() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 40,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: TextFormatted(
                text: "Additional Information",
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _getBasicInfoRow(
            title: "Father's name",
            value: mainController.user.fathersname,
            key: 'fathers_name',
          ),
          _getBasicInfoRow(
            title: "Height",
            value: mainController.user.height,
            key: 'height',
          ),
          _getBasicInfoRow(
            title: "Weight",
            value: mainController.user.weight,
            key: 'weight',
          ),
          _getBasicInfoRow(
            title: "Father's name",
            value: mainController.user.fathersname,
            key: 'fathers_name',
          ),
          _getBasicInfoRow(
            title: "Height",
            value: mainController.user.height,
            key: 'height',
          ),
          _getBasicInfoRow(
            title: "Marital Status",
            value: mainController.user.maritualstatus,
            key: 'maritualstatus',
          ),
          _getBasicInfoRow(
            title: "Religion",
            value: mainController.user.religion,
            key: 'religion',
          ),
          _getBasicInfoRow(
            title: "Nationality",
            value: mainController.user.nationality,
            key: 'nationality',
          ),
        ],
      ),
    );
  }

  renderNameBlock() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormatted(
                text: mainController.user.name,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.edit,
                  size: 18.0,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () {},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormatted(
                text: mainController.user.bio,
                textStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.edit,
                  size: 18.0,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () {},
              )
            ],
          ),
        ],
      ),
    );
  }

  renderProfilePicture() {
    return Container(
      color: Colors.white,
      height: 200,
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                mainController.user.picture,
              ),
              radius: 80,
            ),
            Positioned(
              right: 0,
              height: 50,
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(80),
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
