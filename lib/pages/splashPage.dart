import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';


@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final SecureStorage secureStorage = SecureStorage();
    Constants.doctortoken = await secureStorage.readSecureData('doctortoken') ?? '';
    Constants.admintoken = await secureStorage.readSecureData('admintoken') ?? '';
    Constants.nursetoken = await secureStorage.readSecureData('nursetoken') ?? '';

    // Decide the next route
    if (Constants.doctortoken.isNotEmpty) {
      context.router.replaceAll([const DoctorDashboardRoute()]);
    } else if (Constants.admintoken.isNotEmpty) {
      context.router.replaceAll([const AdminDashboardRoute()]);
    } else if (Constants.nursetoken.isNotEmpty) {
      context.router.replaceAll([const StaffDashboardRoute()]);
    } else {
      context.router.replaceAll([const LoginRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
