import 'dart:async';

import 'package:flutter/material.dart';
import 'data.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home())));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Center(child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 50),
            child: Material(
              elevation: 18.0,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/logo.jpg'),
                    ),
                  ),),
            ),
          ))
        ],
      ),
    );
  }

}

