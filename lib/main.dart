import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/views/ui/Home.dart';
import 'package:baideshikrojgar/views/ui/Login.dart';
import 'package:baideshikrojgar/views/ui/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Baideshik Rojgar",
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        secondaryHeaderColor: Colors.orange,
      ),
      getPages: [
        GetPage(
          name: SPLASHSCREEN,
          page: () => SplashScreen(),
        ),
        GetPage(
          name: LOGIN_PAGE,
          page: () => LoginPage(),
        ),
        GetPage(
          name: HOME_PAGE,
          page: () => MainScreen(),
        ),
      ],
      initialRoute: SPLASHSCREEN,
    );
  }
}
