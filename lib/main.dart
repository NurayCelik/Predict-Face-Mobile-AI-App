import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import './home_page.dart';
import './start_page.dart';
import './mysplash.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
// flutter build apk --split-per-abi
//flutter build appbundle --target-platform android-arm,android-arm64
//flutter build apk --release      

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Load ads.
  }

  @override
  Widget build(BuildContext context) {
    // Set portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        title: 'Predict Face',
        home: StartPage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          StartPage.routeName: (ctx) => StartPage(),
          HomePage.routeName: (ctx) => HomePage(),
          MySplash.routeName: (ctx) => MySplash(),
        });
  }
}
