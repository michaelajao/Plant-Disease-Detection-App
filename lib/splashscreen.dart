import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plant_detection/Home.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
  MySplash({Key key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Home(),
      title: Text(
        "Plant Disease Detection",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color(0xFFE99600)),
      ),
      image: Image.asset('assets/plant.png'),
      gradientBackground: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.greenAccent, Colors.lightBlueAccent]),
      photoSize: 50,
      loaderColor: Color(0xFFEEDA28),
    );
  }
}
