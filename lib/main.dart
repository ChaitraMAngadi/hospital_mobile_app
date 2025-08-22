import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/pages/loginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      title: 'Hospital Management',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
