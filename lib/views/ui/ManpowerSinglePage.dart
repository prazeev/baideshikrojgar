import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class ManpowerSinglePage extends StatefulWidget {
  @override
  _ManpowerSinglePageState createState() => _ManpowerSinglePageState();
}

class _ManpowerSinglePageState extends State<ManpowerSinglePage> {
  MainController mainController = Get.find();
  Map<String, dynamic> details = Get.arguments;
  String title = "View Post";
  Map data = {};
  bool isLoading = true;
  bool permissionGranted = false;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(27.7172, 85.3240), zoom: 14.4746);
  Set<Marker> markers = Set();
  @override
  void initState() {
    super.initState();
    setState(() {
      title = details['title'];
    });
    fetchPost(details['id']);
  }

  fetchPost(int id) async {
    if (await Permission.location.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    }
    setState(() {
      isLoading = true;
    });
    if (!permissionGranted) {
      AwesomeDialog(
        context: Get.context,
        title: "Action needed",
        desc:
            "Please allow permission of accessing location. We need this because of using manpower location.",
      );
      return;
    }
    dynamic res = await this.mainController.apiController.getDataFuture(
          'manpower/' + id.toString(),
          ignoreOffline: this.mainController.isInternetConnected,
        );
    var d = json.decode(res.body);
    setState(() {
      data = d;
      isLoading = false;
    });

    _goToTheLake();
  }

  _buildText(String text) {
    return this.isLoading ? "Loading..." : text;
  }

  _getData(dynamic data, String key) {
    if (data != null && data.containsKey(key)) {
      return _buildText(data[key]);
    } else {
      return "Loading...";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: this.markers,
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              margin: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  JobTile(
                    type: 'null',
                    height: 120,
                    title: _getData(data, 'name'),
                    location: _getData(data, 'address'),
                    bgcolor: Colors.transparent,
                    contact: _getData(data, 'contact'),
                    canCall: true,
                    abstract: _getData(data, 'abstract'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToTheLake,
        backgroundColor: Colors.green,
        child: Icon(Icons.home),
      ),
    );
  }

  double _parseLatLang(dynamic data) {
    double d = double.parse(data.toString());
    return d;
  }

  Future<void> _goToTheLake() async {
    if (!this.isLoading) {
      Marker resultMarker = Marker(
        markerId: MarkerId('location'),
        infoWindow: InfoWindow(
          title: this.title,
        ),
        position: LatLng(
          _parseLatLang(data['latitude']),
          _parseLatLang(data['longitude']),
        ),
        onTap: () {
          launchMap(lat: data['latitude'], long: data['longitude']);
        },
        visible: true,
      );
// Add it to Set
      markers.clear();
      markers.add(resultMarker);
      setState(() {});
      GoogleMapController controller = await _controller.future;
      CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(
            _parseLatLang(data['latitude']), _parseLatLang(data['longitude'])),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    }
  }
}
