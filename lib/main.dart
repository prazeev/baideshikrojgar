import 'package:audio_service/audio_service.dart';
import 'package:baideshikrojgar/utlis/constants/Constants.dart';
import 'package:baideshikrojgar/views/fragements/experiences/experiences.dart';
import 'package:baideshikrojgar/views/radio/RadioScreen.dart';
import 'package:baideshikrojgar/views/ui/AllCatrgories.dart';
import 'package:baideshikrojgar/views/ui/AllCompanies.dart';
import 'package:baideshikrojgar/views/ui/AllCountry.dart';
import 'package:baideshikrojgar/views/ui/AllJobs.dart';
import 'package:baideshikrojgar/views/ui/AllManpower.dart';
import 'package:baideshikrojgar/views/ui/ApplyJob.dart';
import 'package:baideshikrojgar/views/ui/CategoriesJobs.dart';
import 'package:baideshikrojgar/views/ui/CategoryDataSajhasabal.dart';
import 'package:baideshikrojgar/views/ui/CompanyJobs.dart';
import 'package:baideshikrojgar/views/ui/CountryJobs.dart';
import 'package:baideshikrojgar/views/ui/CountryWiseInfo.dart';
import 'package:baideshikrojgar/views/ui/DirectoryList.dart';
import 'package:baideshikrojgar/views/ui/Forex.dart';
import 'package:baideshikrojgar/views/ui/Home.dart';
import 'package:baideshikrojgar/views/ui/LTWorkPermitSearch.dart';
import 'package:baideshikrojgar/views/ui/Login.dart';
import 'package:baideshikrojgar/views/ui/ManpowerJobs.dart';
import 'package:baideshikrojgar/views/ui/ManpowerSinglePage.dart';
import 'package:baideshikrojgar/views/ui/Notifications.dart';
import 'package:baideshikrojgar/views/ui/Profile.dart';
import 'package:baideshikrojgar/views/ui/ReadNews.dart';
import 'package:baideshikrojgar/views/ui/SplashScreen.dart';
import 'package:baideshikrojgar/views/ui/TrendingJobs.dart';
import 'package:baideshikrojgar/views/ui/ValidCountries.dart';
import 'package:baideshikrojgar/views/ui/ViewHtml.dart';
import 'package:baideshikrojgar/views/ui/ViewJob.dart';
import 'package:baideshikrojgar/views/ui/ViewPost.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
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
      builder: EasyLoading.init(),
      getPages: [
        GetPage(
          name: SPLASHSCREEN,
          page: () => AudioServiceWidget(
            child: SplashScreen(),
          ),
        ),
        GetPage(
          name: LOGIN_PAGE,
          page: () => LoginPage(),
        ),
        GetPage(
          name: NOTIFICATION,
          page: () => Notifications(),
        ),
        GetPage(
          name: PROFILE,
          page: () => Profile(),
        ),
        GetPage(
          name: UPDATE_EXPERIENCE,
          page: () => ExperienceAction(),
        ),
        GetPage(
          name: HOME_PAGE,
          page: () => MainScreen(),
        ),
        GetPage(
          name: ALL_JOBS,
          page: () => AllJobs(),
        ),
        GetPage(
          name: ALL_COMPANIES,
          page: () => AllCompanies(),
        ),
        GetPage(
          name: COMPANY_JOBS,
          page: () => CompanyJobs(),
        ),
        GetPage(
          name: VIEW_JOB,
          page: () => ViewJob(),
        ),
        GetPage(
          name: APPLY_JOB,
          page: () => ApplyJob(),
        ),
        GetPage(
          name: ALL_MANPOWER,
          page: () => AllManpower(),
        ),
        GetPage(
          name: RADIO_PAGE,
          page: () => RadioScreen(),
        ),
        GetPage(
          name: MANPOWER_SINGLE,
          page: () => ManpowerSinglePage(),
        ),
        GetPage(
          name: FEATURED_JOBS,
          page: () => TrendingJobs(),
        ),
        GetPage(
          name: MANPOWER_JOBS,
          page: () => ManpowerJobs(),
        ),
        GetPage(
          name: DIRECTORY_LISTING,
          page: () => DirectoryList(),
        ),
        GetPage(
          name: COUNTRIES_JOBS,
          page: () => CountryJobs(),
        ),
        GetPage(
          name: ALL_COUNTRIES,
          page: () => AllCountry(),
        ),
        GetPage(
          name: VALID_COUNTRIES,
          page: () => ValidCountries(),
        ),
        GetPage(
          name: CATEGORIES_JOBS,
          page: () => CategoriesJobs(),
        ),
        GetPage(
          name: COUNTRY_WISE_INFO,
          page: () => CountryWiseInfo(),
        ),
        GetPage(
          name: VIEW_HTML,
          page: () => ViewHtml(),
        ),
        GetPage(
          name: VIEW_POST,
          page: () => ViewPost(),
        ),
        GetPage(
          name: ALL_CATEGORIES,
          page: () => AllCatrgories(),
        ),
        GetPage(
          name: LT_WORKPERMIT_SEARCH,
          page: () => LTWorkPermitSearch(),
        ),
        GetPage(
          name: READ_NEWS,
          page: () => ReadNews(),
        ),
        GetPage(
          name: FOREX,
          page: () => Forex(),
        ),
        GetPage(
          name: CATEGORY_NEWS_SAJHASABAL,
          page: () => CategoryDataSajhasabal(),
        ),
      ],
      initialRoute: SPLASHSCREEN,
    );
  }
}
