import 'dart:convert';

import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forex extends StatefulWidget {
  @override
  _ForexState createState() => _ForexState();
}

class _ForexState extends State<Forex> {
  Map forex = {
    "data": [],
    "date": '',
    "flag_url": '',
  };
  MainController mainController = Get.find();
  @override
  void initState() {
    this.fetchForex();
  }

  fetchForex() async {
    var res = await this.mainController.apiController.getDataFuture(
          "forex",
        );
    var data = json.decode(res.body);
    setState(() {
      forex = {
        "data": data['data'],
        "date": data['date'],
        "flag_url": data['flag_url'],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("विनिमय दर"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextFormatted(
                        text: "Date: ",
                      ),
                      TextFormatted(
                        text: this.forex['date'],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextFormatted(
                        text: "Source: Nepal Rastra Bank ",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: TextFormatted(
                      text: "Currency",
                    ),
                  ),
                  DataColumn(
                    label: TextFormatted(
                      text: "Unit",
                    ),
                  ),
                  DataColumn(
                    label: TextFormatted(
                      text: "Buy",
                    ),
                  ),
                  DataColumn(
                    label: TextFormatted(
                      text: "Sell",
                    ),
                  ),
                ],
                rows: this.forex['data'].map<DataRow>((e) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Row(
                          children: [
                            CachedNetworkImage(
                                height: 17,
                                width: 25,
                                imageUrl: BASE_URL_FULL +
                                    "/img/flags/" +
                                    e['BaseCurrency'].toLowerCase() +
                                    ".jpg"),
                            TextFormatted(
                              text: e['BaseCurrency'],
                            )
                          ],
                        ),
                      ),
                      DataCell(
                        TextFormatted(
                          text: e['BaseValue'],
                        ),
                      ),
                      DataCell(
                        TextFormatted(
                          text: e['TargetBuy'],
                        ),
                      ),
                      DataCell(
                        TextFormatted(
                          text: e['TargetSell'],
                        ),
                      ),
                    ],
                  );
                }).toList())
          ],
        ),
      ),
    );
  }
}
