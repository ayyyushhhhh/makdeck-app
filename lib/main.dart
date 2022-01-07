import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makdeck/screens/home_page.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuthentication.initFirebaseAuth();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
