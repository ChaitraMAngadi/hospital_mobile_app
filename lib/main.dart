import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/provider/adminProvider.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/provider/loginProvider.dart';
import 'package:hospital_mobile_app/provider/supportingstaffProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=> Loginprovider()),
      ChangeNotifierProvider(create: (_)=> Doctorprovider()),
      ChangeNotifierProvider(create: (_)=> Adminprovider()),
      ChangeNotifierProvider(create: (_)=> Supportingstaffprovider())
      
  ],
  child:   MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      title: 'Hospital Management',
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
    );
  }
}
