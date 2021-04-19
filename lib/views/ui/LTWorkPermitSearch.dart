import 'dart:convert';

import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/utlis/global/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nice_button/NiceButton.dart';

class LTWorkPermitSearch extends StatefulWidget {
  final dynamic details = Get.arguments;
  @override
  _LTWorkPermitSearchState createState() => _LTWorkPermitSearchState();
}

class _LTWorkPermitSearchState extends State<LTWorkPermitSearch> {
  TextEditingController textEditingController = TextEditingController();
  String searchData = '';
  Widget search;
  @override
  void initState() {
    this.textEditingController =
        TextEditingController(text: this.widget.details['data']);
    setState(() {
      searchData = this.widget.details['data'];
    });
    searchLtData();
    super.initState();
  }

  searchLtData() {
    setState(() {
      search = this.widget.details['type'] == LT_SEARCH
          ? LTSearchResult(this.textEditingController.text)
          : PassportSearchResult(this.textEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: TextFormatted(
          text: this.widget.details['type'] == LT_SEARCH
              ? "LT Search"
              : "Passport search",
        ),
      ),
      backgroundColor: Colors.black12,
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    radius: 1,
                    elevation: 0.1,
                    hint: this.widget.details['type'] == LT_SEARCH
                        ? "विज्ञापन पूर्व-स्वीकृति खोज्नुहोस्"
                        : "श्रम स्वीकृति खोज्नुहोस्",
                    textEditingController: textEditingController,
                    onTextChange: (String text) {},
                    keyboardType: TextInputType.number,
                    onSubmit: (String text) {
                      setState(() {
                        searchData = this.textEditingController.text.trim();
                      });
                      this.searchLtData();
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        searchData = this.textEditingController.text.trim();
                      });
                      this.searchLtData();
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          search,
          Container(
            padding: const EdgeInsets.all(8),
            child: this.widget.details['type'] == LT_SEARCH
                ? TextFormatted(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                    maxline: 50,
                    text:
                        "पूर्व श्रम स्वीकृति भनेको कुनै पनि कामको लागि सम्वन्धित देशमा नेपाली जनशक्ति पठाउन मिल्ने वा नमिल्ने भन्ने महत्वपूर्ण आदेश हो । बैदेशिक रोजगारीका लागि म्यानपावरले दिने बिज्ञापन सहि हो कि होइन भन्ने आधिकारिकता बुझ्‍न परेमा प्रकाशित विज्ञापनमा उल्लेख हुने Lot Number माथिको बक्समा टाइप गरि आधिकारिकता बुझ्न सकिन्छ ।  \n\n(उदाहरणको लागि पत्रिका वा अनलाइनमा आउने बैदेशिक रोजगारको बिज्ञापनमा Lt. No:  345678 छ भने माथिको बक्समा 345678 टाईप गरि खोज्न सक्नुहुनेछ), माथिको बक्समा Lot Number चेक गरेपछि विज्ञापन स्वीकृत भएको देश, कम्पनी, पद, तलव, खाना/बस्ने व्यवस्था, भिषा/टिकट, करार अवधि र लागत खर्चबारे थाहा पाउन सकिन्छ ।",
                  )
                : TextFormatted(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                    maxline: 50,
                    text:
                        "बैदेशिक रोजगारीको लागि सम्पूर्ण प्रक्रिया पुरा भएपछि अन्तिममा श्रम स्वीकृति लिनुपर्दछ । यदी यस्तो श्रम-स्वीकृतिनै लिईएको छैन भने तपाइँलाई कामदारको रुपमा बैदेशिक रोजगारमा जान अनुमति छैन भन्ने बुझ्नुपर्छ । त्यसैले बैदेशिक रोजगारीमा जानु अघिनै आफ्नो श्रम स्वीकृति छ/छैन हेर्नुपर्छ । जसको लागि माथिको बक्समा आफ्नो Passport नम्बर टाइप गरेर खोज्नुपर्छ । (उदाहरणको लागि तपाइँले बैदेशिक रोजगारीको लागि सबै प्रक्रिया पुरा गरेर बैदेशिक रोजगारमा उड्नुपुर्व आफ्नो पासपोर्ट नम्बर (माथिको बक्समा) हानेर सर्च गरेपछि यदी श्रम स्वीकृति भएको छ भने तपाइको नाम, तपाइँ जान लागेको देश, कम्पनीको नाम तथा पद सहितको विवरण हेर्न सक्नुहुन्छ । यदी श्रम स्वीकृति देखाएन भने बैदेशिक रोजगार बिभागमा बुझ्नुपर्छ । \nयाद राख्नुहोस्:- बैदेशिक रोजगारीको लागि कुनैपनि व्यक्ति वा म्यानपावर मार्फत जानुअघि आफ्नो श्रम स्वीकृति भए/नभएको अनिवार्य हेर्नुहोस् । यदी कोहि कसैले बिना श्रम स्वीकृति तपाइँलाई बैदेशिक रोजगारीमा लाँदैछ भने त्यो अवैध हो । अवैधानिक बाटोबाट रोजगारीमा जाँदा ठगिनुका साथै मानव तस्करको फन्दामा परि विदेशमै अलपत्र पर्न सकिन्छ । अवैधानिक बाटोबाट रोजगारीमा जाँदा कानूनी कारबाही हुने, सम्झौता बमोजिम काम नपाउने र कल्याणकारी कोष, बीमा कम्पनीबाट प्राप्त हुने सेवा सुविधा प्राप्त नहुने अवस्था आउँछ ।",
                  ),
          )
        ],
      ),
    );
  }
}

class LTSearchResult extends StatefulWidget {
  final String lotno;
  LTSearchResult(this.lotno);
  @override
  _LTSearchResultState createState() => _LTSearchResultState();
}

class _LTSearchResultState extends State<LTSearchResult> {
  MainController mainController = Get.find();
  List results = [];
  bool notFound = true;
  bool searching = true;

  String current = '';

  @override
  void initState() {
    super.initState();
  }

  searchLt() async {
    if (this.widget.lotno.trim().length > 0) {
      setState(() {
        searching = true;
      });
      var result = await this.mainController.apiController.postDataFuture(
        {"LotNo": this.widget.lotno.toString()},
        "/lt_search",
      );
      var data = json.decode(result.body);
      setState(() {
        searching = false;
      });
      if (data['error'] ?? false) {
        setState(() {
          notFound = true;
        });
      } else {
        setState(() {
          notFound = false;
          results = data['body'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.lotno.trim().length == 0) {
      return Text(" ");
    }
    if (this.widget.lotno != this.current) {
      setState(() {
        current = this.widget.lotno;
      });
      this.searchLt();
    }
    if (this.searching) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (this.notFound) {
      return TextFormatted(
        maxline: 5,
        textStyle: TextStyle(color: Colors.red),
        text:
            "Sorry, there is no any records for this search. Please try different one.",
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: SimplePrimaryTitle(
                    title:
                        "यो LT Details (विज्ञापन पूर्व-स्वीकृति विवरण)  वैदेशिक रोजगार बिभागबाट जस्ताको तस्तै लिईएको हो।",
                  ),
                ),
                ...this.results.map((e) {
                  int position = this.results.indexOf(e);
                  Widget top = SizedBox(
                    height: 1,
                  );
                  if (position == 0) {
                    top = Container(
                      width: double.infinity,
                      child: Column(children: [
                        LeftRightContent(
                            "Working Company", e['CompanyName'].toString()),
                        LeftRightContent("LT", e['LotNo'].toString()),
                        LeftRightContent("Country", e['Country'].toString()),
                        LeftRightContent(
                            "Recruiting Agency", e['RaName'].toString()),
                        LeftRightContent(
                            "Approval Date (AD)", e['ApprovedDate'].toString()),
                      ]),
                    );
                  }
                  return Container(
                    color: Colors.blueGrey,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        top,
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              TextFormatted(
                                text: e['SkillName'],
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        LeftRightContent(
                            "Male", e['ApprovedNoOfMen'].toString()),
                        LeftRightContent(
                            "Female", e['ApprovedNoOfWomen'].toString()),
                        LeftRightContent(
                            "Salary",
                            e['Salary'].toString() +
                                " " +
                                e['Currency'].toString()),
                        LeftRightContent(
                            "Fooding", e['FoodFacility'].toString()),
                        LeftRightContent(
                            "Accommodation", e['Accomodation'].toString()),
                        LeftRightContent(
                            "Duration (yr)", e['ContractPeriod'].toString()),
                        LeftRightContent("Service Charge (NRs.)",
                            e['ServiceCharge'].toString()),
                        LeftRightContent("Others Charge (NRs.)",
                            e['OtherCharge'].toString()),
                        LeftRightContent(
                            "Total Fee (NRs.)", e['TotalExpense'].toString()),
                      ],
                    ),
                  );
                }).toList(),
              ]),
        ),
      );
    }
  }
}

class PassportSearchResult extends StatefulWidget {
  final String passportno;
  PassportSearchResult(this.passportno);
  @override
  _PassportSearchResultState createState() => _PassportSearchResultState();
}

class _PassportSearchResultState extends State<PassportSearchResult> {
  MainController mainController = Get.find();
  List results = [];
  bool notFound = true;
  bool searching = true;

  String current = '';

  @override
  void initState() {
    super.initState();
  }

  searchLt() async {
    if (this.widget.passportno.trim().length > 0) {
      setState(() {
        searching = true;
      });
      var result = await this.mainController.apiController.postDataFuture(
        {"PassportNo": this.widget.passportno.toString()},
        "/passport_search",
      );
      var data = json.decode(result.body);
      print(data);
      setState(() {
        searching = false;
      });
      if (data['error'] ?? false) {
        setState(() {
          notFound = true;
        });
      } else {
        setState(() {
          notFound = false;
          results = data['body'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.passportno.trim().length == 0) {
      return Text(" ");
    }
    if (this.widget.passportno != this.current) {
      setState(() {
        current = this.widget.passportno;
      });
      this.searchLt();
    }
    if (this.searching) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (this.notFound) {
      return TextFormatted(
        maxline: 5,
        textStyle: TextStyle(color: Colors.red),
        text:
            "Sorry, there is no any records for this search. Please try different one.",
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...this.results.map((e) {
              int position = this.results.indexOf(e);
              Widget top = SizedBox(
                height: 1,
              );
              if (position == 0) {
                top = Container(
                  width: double.infinity,
                  child: Column(children: [
                    LeftRightContent("Name", e['Name'].toString()),
                    LeftRightContent(
                        "Passport Number", e['PassportNo'].toString()),
                  ]),
                );
              }
              return Container(
                color: Colors.blueGrey,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    top,
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          TextFormatted(
                            text: e['AgencyName'],
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    LeftRightContent(
                        "Company Name", e['CompanyName'].toString()),
                    LeftRightContent("Country", e['Country'].toString()),
                    LeftRightContent(
                        "Salary",
                        e['Salary'].toString() +
                            " " +
                            e['Currency'].toString()),
                    LeftRightContent("Skill Name", e['SkillName'].toString()),
                    LeftRightContent(
                        "Approved Date", e['ApprovedDate'].toString()),
                    LeftRightContent(
                        "Duration (yr)", e['ContractPeriod'].toString()),
                    LeftRightContent("Gender", e['Gender'].toString()),
                    LeftRightContent(
                        "Insurance Name",
                        e['InsuranceName'].length > 0
                            ? e['InsuranceName']
                            : "N/A"),
                    LeftRightContent("Medical",
                        e['Medical'].length > 0 ? e['Medical'] : "N/A"),
                    LeftRightContent(
                        "Policy Expiry Date",
                        e['PolicyExpiryDate'].length > 0
                            ? e['PolicyExpiryDate']
                            : "N/A"),
                    LeftRightContent("Policy Number",
                        e['PolicyNo'].length > 0 ? e['PolicyNo'] : "N/A"),
                    LeftRightContent("Sticker Number",
                        e['StickerNo'].length > 0 ? e['StickerNo'] : "N/A"),
                  ],
                ),
              );
            }).toList(),
          ]);
    }
  }
}

class LeftRightContent extends StatelessWidget {
  final String title, details;
  LeftRightContent(this.title, this.details);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormatted(
                  text: this.title,
                ),
              ),
              Expanded(
                child: TextFormatted(
                  text: this.details,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
