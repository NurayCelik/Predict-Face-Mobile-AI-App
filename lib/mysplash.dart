import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'home_page.dart';


class MySplash extends StatefulWidget {
  static const routeName = '/splash-screen';
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: HomePage(),
      title: Text(
        'Female Vs Male',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Color(0xFFeeda28),
        ),
      ),
      image: Image.asset('assets/images/start.png'),
      photoSize: 50.0,
      backgroundColor: Color(0xff424449),
      loaderColor: Color(0xffeeda28),
    );
  }
}
