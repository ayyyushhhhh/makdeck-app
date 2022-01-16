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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
