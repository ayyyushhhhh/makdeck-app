import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makdeck/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makdeck',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: "Montserrat",
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: "SourceSansPro",
          ),
          headline2: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          headline5: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
