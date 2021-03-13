import 'package:baideshikrojgar/models/User.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  // Logged in user
  User user;
  MainController({
    this.user,
  });
  // Internet connections
  bool isInternetConnected = false;
  setIsInternetConnected(bool val) {
    this.isInternetConnected = val;
    update();
  }

  // Banners
  List<Map<String, String>> banners = [
    {
      "path": "assets/images/one.png",
      "type": "assets",
    },
    {
      "path": "assets/images/two.jpg",
      "type": "assets",
    },
    {
      "path": "assets/images/three.jpg",
      "type": "assets",
    },
  ];
  // Home other menu
  List<Map<String, String>> homeOtherMenu = [
    {
      "path": "assets/images/Bank.png",
      "key": "1",
    },
    {
      "path": "assets/images/Embassies.png",
      "key": "2",
    },
    {
      "path": "assets/images/Insourance.png",
      "key": "3",
    },
    {
      "path": "assets/images/Medical.png",
      "key": "4",
    },
    {
      "path": "assets/images/Orientation.png",
      "key": "5",
    },
    {
      "path": "assets/images/Training.png",
      "key": "6",
    },
  ];
  List<dynamic> homeLatestJobs = [
    {
      "picture": "https://picsum.photos/200",
      "title": "A",
      "salarymax": "2000",
      "salarymin": "5000",
      "location": "Kathmandu nepal jhapa",
      "daysLeft": "Few days left for application",
    }
  ];
  List<dynamic> homeManpowers = [
    {
      "picture": "https://picsum.photos/200",
      "title": "A",
      "location": "Kathmandu nepal jhapa",
      "contact": "9860428885",
      "newjob": 41
    }
  ];
  List<dynamic> homeEmbassies = [
    {
      "picture": "https://picsum.photos/200",
      "title": "A",
      "location": "Kathmandu nepal jhapa",
      "contact": "9860428885",
    }
  ];
  List<dynamic> homeNews = [
    {
      "picture": "https://picsum.photos/200",
      "title":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's s",
      "date": "28 Feb, 2021",
      "abstract":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      "full_news": "lorem",
      "isBigTile": false,
    },
    {
      "picture": "https://picsum.photos/200",
      "title":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's s",
      "date": "28 Feb, 2021",
      "abstract":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      "full_news": "lorem",
      "isBigTile": true,
    },
  ];
  static MainController get to => Get.find();
  bool isRadioPlaying = false;
  setIsRadioPlaying(bool value) {
    this.isRadioPlaying = value;
    update();
  }
}
