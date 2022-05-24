import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gadget_boy/screens/splashScreen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: kIsWeb
        ? const FirebaseOptions(
      apiKey: "AIzaSyCn6kyCer_dW1WobdGvrdCc96aijKr1WQU",
      appId: "1:349291214690:android:26dce35002b9eb90765e3b",
      messagingSenderId: "349291214690",
      projectId: "gadget-boy-0522",
      storageBucket: "gadget-boy-0522.appspot.com",
    ): null,
  );

  await FlutterDownloader.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MaterialApp(
        home: Wrapper(),
      ),
    );
  }


}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
