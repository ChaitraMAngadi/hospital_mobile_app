import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/editPatientPage.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/patientInvisitsPage.dart';
import 'package:hospital_mobile_app/doctorController/patientInVisit/viewDiagnosisPage.dart';
import 'package:hospital_mobile_app/doctorController/patientOutVisit/diagnosisPage.dart';
import 'package:hospital_mobile_app/doctorController/patientOutVisit/patientOutvisitsPage.dart';
import 'package:hospital_mobile_app/doctorController/registerPatientPage.dart';
import 'package:hospital_mobile_app/pages/adminDashboard.dart';
import 'package:hospital_mobile_app/pages/doctorDashboard.dart';
import 'package:hospital_mobile_app/pages/loginPage.dart';
import 'package:hospital_mobile_app/pages/splashPage.dart';
import 'package:hospital_mobile_app/pages/supportingStaffDashboard.dart';


part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {


  // flutter pub run build_runner build --delete-conflicting-outputs
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: DoctorDashboardRoute.page,
        ),
        AutoRoute(

          page: AdminDashboardRoute.page,
        ),
        AutoRoute(
          page: StaffDashboardRoute.page,
        ),
        AutoRoute(
          page: RegisterPatientRoute.page,
        ),
        AutoRoute(
          page: EditPatientRoute.page,
        ),
        AutoRoute(
          page: PatientInvisitsRoute.page,
        ),
        AutoRoute(
          page: PatientOutvisitsRoute.page,
        ),
        AutoRoute(
          page: DiagnosisRoute.page,
        ),
         AutoRoute(
          page: ViewDiagnosisRoute.page,
        ),
        // AutoRoute(
        //   page: HomeRoute.page,
        //   initial: true,
        // ),
        // AutoRoute(
        //   page: DashboardRoute.page,
        // ),
        // AutoRoute(
        //   page: EditProfileRoute.page,
        // ),
        // AutoRoute(
        //   page: SelectNotificationTimesRoute.page,
        // ),
        // AutoRoute(
        //   page: RecordsRoute.page,
        //   // initial: true,
        // ),
      ];
}
