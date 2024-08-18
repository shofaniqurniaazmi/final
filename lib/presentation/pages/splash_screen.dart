import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutritrack/common/assets/assets.dart';
import 'package:nutritrack/presentation/pages/onboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Onboard(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200, //! dari width logo di figma
          height: 200, //! dari heigh logo ddi figma
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(nutritrackLogo),
            ),
          ),
        ),
      ),
    );
  }
}
